#include <lean/lean.h>
#include <cuda_runtime.h>
#include <iostream>
#include <stdint.h>
#include <string.h>

#ifndef lean_byte_array_size
#define lean_byte_array_size lean_sarray_size
#endif
#ifndef lean_byte_array_data
#define lean_byte_array_data lean_sarray_cptr
#endif

// CUDA Kernel for solving Petri Net state equation feasibility on GPU
__global__ void check_state_equation_kernel(
    const int32_t* pre,
    const int32_t* post,
    const int32_t* markings,
    uint8_t* results,
    uint32_t P,
    uint32_t T,
    int num_candidates)
{
    int id = blockIdx.x * blockDim.x + threadIdx.x;
    if (id < num_candidates) {
        const int32_t* cand = markings + id * (2 * P + T);
        const int32_t* M = cand;
        const int32_t* M_prime = cand + P;
        const int32_t* u = cand + 2 * P;
        
        bool ok = true;
        for (uint32_t p = 0; p < P; p++) {
            long long val = M[p];
            for (uint32_t t = 0; t < T; t++) {
                long long pre_val = pre[p * T + t];
                long long post_val = post[p * T + t];
                val += (post_val - pre_val) * u[t];
            }
            if (val != M_prime[p]) {
                ok = false;
                break;
            }
        }
        results[id] = ok ? 1 : 0;
    }
}

// CPU reference implementation for fallback and correctness checks
bool check_state_equation_cpu(
    uint32_t P, uint32_t T,
    const int32_t* pre,
    const int32_t* post,
    const int32_t* markings,
    uint8_t* results,
    size_t num_candidates)
{
    for (size_t i = 0; i < num_candidates; i++) {
        const int32_t* cand = markings + i * (2 * P + T);
        const int32_t* M = cand;
        const int32_t* M_prime = cand + P;
        const int32_t* u = cand + 2 * P;
        
        bool ok = true;
        for (uint32_t p = 0; p < P; p++) {
            int64_t val = M[p];
            for (uint32_t t = 0; t < T; t++) {
                int64_t pre_val = pre[p * T + t];
                int64_t post_val = post[p * T + t];
                val += (post_val - pre_val) * (int64_t)u[t];
            }
            if (val != M_prime[p]) {
                ok = false;
                break;
            }
        }
        results[i] = ok ? 1 : 0;
    }
    return true;
}

// C FFI wrapper conforming to the Lean 4 ABI (with C linkage)
extern "C" lean_object* check_state_equation_gpu_ffi(
    lean_object* pre_obj, 
    lean_object* post_obj, 
    lean_object* markings_obj)
{
    size_t pre_size = lean_byte_array_size(pre_obj);
    uint8_t* pre_raw = lean_byte_array_data(pre_obj);
    
    size_t post_size = lean_byte_array_size(post_obj);
    uint8_t* post_raw = lean_byte_array_data(post_obj);
    
    size_t markings_size = lean_byte_array_size(markings_obj);
    uint8_t* markings_raw = lean_byte_array_data(markings_obj);
    
    // Header check
    if (pre_size < 8 || post_size < 8) {
        lean_object* results_obj = lean_alloc_sarray(1, 0, 0);
        return results_obj;
    }
    
    uint32_t P = *(const uint32_t*)pre_raw;
    uint32_t T = *(const uint32_t*)(pre_raw + 4);
    
    const int32_t* pre_data = (const int32_t*)(pre_raw + 8);
    const int32_t* post_data = (const int32_t*)(post_raw + 8);
    const int32_t* markings_data = (const int32_t*)markings_raw;
    
    size_t cand_size_bytes = (2 * P + T) * sizeof(int32_t);
    size_t num_candidates = markings_size / cand_size_bytes;
    
    lean_object* results_obj = lean_alloc_sarray(1, num_candidates, num_candidates);
    uint8_t* results_data = lean_byte_array_data(results_obj);
    
    // Bounds check to avoid memory issues
    if (pre_size < 8 + P * T * sizeof(int32_t) ||
        post_size < 8 + P * T * sizeof(int32_t) ||
        markings_size < num_candidates * cand_size_bytes) {
        memset(results_data, 0, num_candidates);
        return results_obj;
    }

    int32_t *d_pre = nullptr;
    int32_t *d_post = nullptr;
    int32_t *d_markings = nullptr;
    uint8_t *d_results = nullptr;

    // Allocate GPU device memory
    cudaError_t err;
    err = cudaMalloc(&d_pre, P * T * sizeof(int32_t));
    if (err != cudaSuccess) goto cleanup;
    err = cudaMalloc(&d_post, P * T * sizeof(int32_t));
    if (err != cudaSuccess) goto cleanup;
    err = cudaMalloc(&d_markings, num_candidates * cand_size_bytes);
    if (err != cudaSuccess) goto cleanup;
    err = cudaMalloc(&d_results, num_candidates);
    if (err != cudaSuccess) goto cleanup;

    // Copy data from Host to Device
    err = cudaMemcpy(d_pre, pre_data, P * T * sizeof(int32_t), cudaMemcpyHostToDevice);
    if (err != cudaSuccess) goto cleanup;
    err = cudaMemcpy(d_post, post_data, P * T * sizeof(int32_t), cudaMemcpyHostToDevice);
    if (err != cudaSuccess) goto cleanup;
    err = cudaMemcpy(d_markings, markings_data, num_candidates * cand_size_bytes, cudaMemcpyHostToDevice);
    if (err != cudaSuccess) goto cleanup;

    // Launch CUDA Kernel
    {
        int threadsPerBlock = 256;
        int blocksPerGrid = (num_candidates + threadsPerBlock - 1) / threadsPerBlock;
        check_state_equation_kernel<<<blocksPerGrid, threadsPerBlock>>>(
            d_pre, d_post, d_markings, d_results, P, T, num_candidates);
    }

    // Copy results back from Device to Host
    err = cudaMemcpy(results_data, d_results, num_candidates, cudaMemcpyDeviceToHost);
    if (err != cudaSuccess) goto cleanup;

cleanup:
    if (err != cudaSuccess) {
        // Fallback: CPU solver on CUDA error
        check_state_equation_cpu(P, T, pre_data, post_data, markings_data, results_data, num_candidates);
    }
    
    // Free device memory allocations
    if (d_pre) cudaFree(d_pre);
    if (d_post) cudaFree(d_post);
    if (d_markings) cudaFree(d_markings);
    if (d_results) cudaFree(d_results);

    return results_obj;
}
