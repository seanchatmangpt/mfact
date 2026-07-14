#include <lean/lean.h>
#include <stdint.h>
#include <string.h>

#ifndef lean_byte_array_size
#define lean_byte_array_size lean_sarray_size
#endif
#ifndef lean_byte_array_data
#define lean_byte_array_data lean_sarray_cptr
#endif

// CPU reference implementation for fallback and correctness checks
static void check_state_equation_cpu(
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
        
        int ok = 1;
        for (uint32_t p = 0; p < P; p++) {
            int64_t val = M[p];
            for (uint32_t t = 0; t < T; t++) {
                int64_t pre_val = pre[p * T + t];
                int64_t post_val = post[p * T + t];
                val += (post_val - pre_val) * (int64_t)u[t];
            }
            if (val != M_prime[p]) {
                ok = 0;
                break;
            }
        }
        results[i] = ok ? 1 : 0;
    }
}

#ifdef __APPLE__
#import <Metal/Metal.h>
#import <Foundation/Foundation.h>
#endif

// C-compatible entry point matching Lean's external declaration
extern lean_object* check_state_equation_gpu_ffi(
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
    
#ifdef __APPLE__
    @autoreleasepool {
        // MSL (Metal Shading Language) Compute Shader Source
        const char* msl_source = 
        "#include <metal_stdlib>\n"
        "using namespace metal;\n"
        "\n"
        "kernel void check_state_equation_kernel(\n"
        "    device const int32_t* pre [[buffer(0)]],\n"
        "    device const int32_t* post [[buffer(1)]],\n"
        "    device const int32_t* markings [[buffer(2)]],\n"
        "    device uint8_t* results [[buffer(3)]],\n"
        "    constant uint32_t& P [[buffer(4)]],\n"
        "    constant uint32_t& T [[buffer(5)]],\n"
        "    uint id [[thread_position_in_grid]])\n"
        "{\n"
        "    device const int32_t* cand = markings + id * (2 * P + T);\n"
        "    device const int32_t* M = cand;\n"
        "    device const int32_t* M_prime = cand + P;\n"
        "    device const int32_t* u = cand + 2 * P;\n"
        "    \n"
        "    bool ok = true;\n"
        "    for (uint32_t p = 0; p < P; p++) {\n"
        "        int64_t val = M[p];\n"
        "        for (uint32_t t = 0; t < T; t++) {\n"
        "            int64_t pre_val = pre[p * T + t];\n"
        "            int64_t post_val = post[p * T + t];\n"
        "            val += (post_val - pre_val) * u[t];\n"
        "        }\n"
        "        if (val != M_prime[p]) {\n"
        "            ok = false;\n"
        "            break;\n"
        "        }\n"
        "    }\n"
        "    results[id] = ok ? 1 : 0;\n"
        "}\n";

        // Initialize default Metal GPU device
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        if (!device) {
            check_state_equation_cpu(P, T, pre_data, post_data, markings_data, results_data, num_candidates);
            return results_obj;
        }
        
        id<MTLCommandQueue> commandQueue = [device newCommandQueue];
        if (!commandQueue) {
            check_state_equation_cpu(P, T, pre_data, post_data, markings_data, results_data, num_candidates);
            return results_obj;
        }
        
        // Compile MSL shader source code
        NSString* sourceStr = [NSString stringWithUTF8String:msl_source];
        NSError* error = nil;
        id<MTLLibrary> library = [device newLibraryWithSource:sourceStr options:nil error:&error];
        if (!library) {
            check_state_equation_cpu(P, T, pre_data, post_data, markings_data, results_data, num_candidates);
            return results_obj;
        }
        
        id<MTLFunction> function = [library newFunctionWithName:@"check_state_equation_kernel"];
        if (!function) {
            check_state_equation_cpu(P, T, pre_data, post_data, markings_data, results_data, num_candidates);
            return results_obj;
        }
        
        id<MTLComputePipelineState> pipelineState = [device newComputePipelineStateWithFunction:function error:&error];
        if (!pipelineState) {
            check_state_equation_cpu(P, T, pre_data, post_data, markings_data, results_data, num_candidates);
            return results_obj;
        }
        
        // Prepare GPU buffers (shared memory mode for zero-copy unified memory on Apple Silicon)
        id<MTLBuffer> preBuffer = [device newBufferWithBytes:pre_data length:P * T * sizeof(int32_t) options:MTLResourceStorageModeShared];
        id<MTLBuffer> postBuffer = [device newBufferWithBytes:post_data length:P * T * sizeof(int32_t) options:MTLResourceStorageModeShared];
        id<MTLBuffer> markingsBuffer = [device newBufferWithBytes:markings_data length:num_candidates * cand_size_bytes options:MTLResourceStorageModeShared];
        id<MTLBuffer> resultsBuffer = [device newBufferWithBytes:results_data length:num_candidates options:MTLResourceStorageModeShared];
        
        if (!preBuffer || !postBuffer || !markingsBuffer || !resultsBuffer) {
            check_state_equation_cpu(P, T, pre_data, post_data, markings_data, results_data, num_candidates);
            return results_obj;
        }
        
        // Encode and dispatch compute commands
        id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
        id<MTLComputeCommandEncoder> encoder = [commandBuffer computeCommandEncoder];
        [encoder setComputePipelineState:pipelineState];
        [encoder setBuffer:preBuffer offset:0 atIndex:0];
        [encoder setBuffer:postBuffer offset:0 atIndex:1];
        [encoder setBuffer:markingsBuffer offset:0 atIndex:2];
        [encoder setBuffer:resultsBuffer offset:0 atIndex:3];
        [encoder setBytes:&P length:sizeof(uint32_t) atIndex:4];
        [encoder setBytes:&T length:sizeof(uint32_t) atIndex:5];
        
        MTLSize gridSize = MTLSizeMake(num_candidates, 1, 1);
        NSUInteger threadGroupSizeValue = MIN(pipelineState.maxTotalThreadsPerThreadgroup, num_candidates);
        if (threadGroupSizeValue == 0) threadGroupSizeValue = 1;
        MTLSize threadGroupSize = MTLSizeMake(threadGroupSizeValue, 1, 1);
        [encoder dispatchThreads:gridSize threadsPerThreadgroup:threadGroupSize];
        
        [encoder endEncoding];
        [commandBuffer commit];
        [commandBuffer waitUntilCompleted];
        
        // Read results back to Lean ByteArray
        memcpy(results_data, [resultsBuffer contents], num_candidates);
    }
#else
    // CPU Fallback on non-Apple systems
    check_state_equation_cpu(P, T, pre_data, post_data, markings_data, results_data, num_candidates);
#endif
    
    return results_obj;
}
