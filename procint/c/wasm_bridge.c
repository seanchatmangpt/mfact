#include <emscripten.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include <lean/lean.h>

// Declarations of Lean generated initialization functions
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_procint_ProcInt_Petri_Computable(uint8_t builtin);

// The Lean function we exported
lean_object* execute_petri_net_fire(lean_object* input);

// Allocates memory in WASM
EMSCRIPTEN_KEEPALIVE
void* alloc(int size) {
    return malloc(size);
}

// Deallocates memory in WASM
EMSCRIPTEN_KEEPALIVE
void dealloc(void* ptr, int size) {
    free(ptr);
}

static int initialized = 0;

// The main WebAssembly execute bridge
EMSCRIPTEN_KEEPALIVE
char* execute(char* json_in, int len) {
    if (!initialized) {
        // Initialize our module and its dependencies
        initialize_Init(1);
        initialize_procint_ProcInt_Petri_Computable(1);
        initialized = 1;
    }

    // Convert C string input to Lean string
    lean_object* input_obj = lean_mk_string(json_in);

    // Call the computable Petri net fire function
    lean_object* output_obj = execute_petri_net_fire(input_obj);

    // Convert Lean string output to C string
    const char* output_cstr = lean_string_cstr(output_obj);
    
    // Allocate a new copy of the output C string in WASM memory
    // because the caller is responsible for deallocating the result
    char* result = strdup(output_cstr);

    // Dec the references of the strings
    lean_dec(output_obj);

    return result;
}

// =========================================================================
// Lean Runtime Stubs and Core Implementations
// =========================================================================

lean_object* initialize_Init(uint8_t builtin) {
    return lean_io_result_mk_ok(lean_box(0));
}

void lean_notify_assert(const char * fileName, int line, const char * condition) {}
void lean_inc_heartbeat(void) {}
void lean_internal_panic_out_of_memory(void) { abort(); }

void* mi_malloc_small(size_t sz) {
    return malloc(sz);
}

bool lean_string_eq_cold(lean_object* s1, lean_object* s2) {
    return strcmp(lean_string_cstr(s1), lean_string_cstr(s2)) == 0;
}

LEAN_EXPORT lean_object * lean_alloc_object(size_t sz) {
    return (lean_object*)malloc(sz);
}

LEAN_EXPORT void lean_free_object(lean_object * o) {
    if (o == NULL) return;
    uint8_t tag = o->m_tag;
    if (tag < LeanMaxCtorTag) { // It's a constructor!
        unsigned num_objs = o->m_other; 
        lean_object ** objs = ((lean_ctor_object*)o)->m_objs;
        for (unsigned i = 0; i < num_objs; i++) {
            lean_dec(objs[i]);
        }
    } else if (tag == LeanArray || tag == LeanStructArray) {
        lean_array_object * arr = (lean_array_object*)o;
        for (size_t i = 0; i < arr->m_size; i++) {
            lean_dec(arr->m_data[i]);
        }
    }
    free(o);
}

LEAN_EXPORT void lean_dec_ref_cold(lean_object * o) {
    lean_free_object(o);
}

lean_object * lean_array_push(lean_obj_arg a, lean_obj_arg v) {
    lean_array_object * arr = (lean_array_object*)a;
    if (arr->m_size >= arr->m_capacity) {
        size_t new_cap = arr->m_capacity * 2;
        size_t sz = sizeof(lean_array_object) + new_cap * sizeof(lean_object*);
        lean_array_object * new_arr = (lean_array_object*)realloc(arr, sz);
        new_arr->m_capacity = new_cap;
        arr = new_arr;
    }
    arr->m_data[arr->m_size] = v;
    arr->m_size++;
    return (lean_object*)arr;
}

lean_object * lean_array_to_list(lean_obj_arg a) {
    lean_array_object * arr = (lean_array_object*)a;
    lean_object * list = lean_box(0); // List.nil
    for (size_t i = arr->m_size; i > 0; i--) {
        lean_object * cons = lean_alloc_ctor(1, 2, 0); // tag 1, 2 fields
        lean_object * val = arr->m_data[i - 1];
        lean_inc(val);
        lean_ctor_set(cons, 0, val);
        lean_ctor_set(cons, 1, list);
        list = cons;
    }
    lean_dec(a);
    return list;
}

lean_object * lean_mk_string(const char * s) {
    size_t len = strlen(s);
    size_t sz = sizeof(lean_string_object) + len + 1;
    lean_string_object * o = (lean_string_object*)malloc(sz);
    o->m_header.m_rc = 1;
    o->m_header.m_tag = LeanString;
    o->m_size = len + 1;
    o->m_capacity = len + 1;
    o->m_length = len;
    strcpy(o->m_data, s);
    return (lean_object*)o;
}

lean_object * lean_string_append(lean_obj_arg s1, b_lean_obj_arg s2) {
    const char * c1 = lean_string_cstr(s1);
    const char * c2 = lean_string_cstr(s2);
    size_t l1 = strlen(c1);
    size_t l2 = strlen(c2);
    size_t new_len = l1 + l2;
    size_t sz = sizeof(lean_string_object) + new_len + 1;
    lean_string_object * o = (lean_string_object*)malloc(sz);
    o->m_header.m_rc = 1;
    o->m_header.m_tag = LeanString;
    o->m_size = new_len + 1;
    o->m_capacity = new_len + 1;
    o->m_length = new_len;
    strcpy(o->m_data, c1);
    strcat(o->m_data, c2);
    lean_dec(s1);
    return (lean_object*)o;
}

lean_obj_res lean_string_utf8_extract(b_lean_obj_arg s, b_lean_obj_arg b, b_lean_obj_arg e) {
    const char * str = lean_string_cstr(s);
    size_t start = lean_unbox(b);
    size_t end = lean_unbox(e);
    size_t len = strlen(str);
    if (start > len) start = len;
    if (end > len) end = len;
    if (end < start) end = start;
    size_t sub_len = end - start;
    
    size_t sz = sizeof(lean_string_object) + sub_len + 1;
    lean_string_object * o = (lean_string_object*)malloc(sz);
    o->m_header.m_rc = 1;
    o->m_header.m_tag = LeanString;
    o->m_size = sub_len + 1;
    o->m_capacity = sub_len + 1;
    
    size_t utf8_len = 0;
    for (size_t i = 0; i < sub_len; i++) {
        unsigned char c = (unsigned char)str[start + i];
        if ((c & 0xc0) != 0x80) utf8_len++;
    }
    o->m_length = utf8_len;
    
    memcpy(o->m_data, str + start, sub_len);
    o->m_data[sub_len] = '\0';
    return (lean_object*)o;
}

lean_obj_res lean_string_utf8_next_fast_cold(size_t i, unsigned char c) {
    if (c < 0x80) return lean_box(i + 1);
    else if ((c & 0xe0) == 0xc0) return lean_box(i + 2);
    else if ((c & 0xf0) == 0xe0) return lean_box(i + 3);
    else if ((c & 0xf8) == 0xf0) return lean_box(i + 4);
    return lean_box(i + 1);
}

lean_object* lean_obj_once_cold(lean_object** loc, lean_once_cell_t* tok, lean_object* (*init)(void)) {
    if (tok->state == 0) {
        tok->state = 1;
        *loc = init();
    }
    return *loc;
}

uint8_t lean_uint8_once_cold(uint8_t* loc, lean_once_cell_t* tok, uint8_t (*init)(void)) {
    if (tok->state == 0) {
        tok->state = 1;
        *loc = init();
    }
    return *loc;
}

lean_object* lean_big_usize_to_nat(size_t n) {
    return lean_box(n);
}

lean_object* lean_nat_big_add(lean_object* a1, lean_object* a2) {
    return lean_box(lean_unbox(a1) + lean_unbox(a2));
}

lean_object* lean_nat_big_sub(lean_object* a1, lean_object* a2) {
    size_t n1 = lean_unbox(a1);
    size_t n2 = lean_unbox(a2);
    return lean_box(n1 > n2 ? n1 - n2 : 0);
}

lean_object* lean_nat_big_succ(lean_object* a) {
    return lean_box(lean_unbox(a) + 1);
}

bool lean_nat_big_lt(lean_object* a1, lean_object* a2) {
    return lean_unbox(a1) < lean_unbox(a2);
}

bool lean_nat_big_le(lean_object* a1, lean_object* a2) {
    return lean_unbox(a1) <= lean_unbox(a2);
}

bool lean_nat_big_eq(lean_object* a1, lean_object* a2) {
    return lean_unbox(a1) == lean_unbox(a2);
}

// =========================================================================
// Lean String Slice and splitOnAux implementations
// =========================================================================

lean_object * l_String_Slice_Pos_nextn(lean_object * s, lean_object * n, lean_object * pos) {
    size_t p = lean_unbox(pos);
    size_t steps = lean_unbox(n);
    return lean_box(p + steps);
}

lean_object * l_String_Slice_toString(lean_object * slice) {
    lean_object * str = lean_ctor_get(slice, 0);
    lean_object * start = lean_ctor_get(slice, 1);
    lean_object * stop = lean_ctor_get(slice, 2);
    lean_object * res = lean_string_utf8_extract(str, start, stop);
    lean_dec(slice);
    return res;
}

lean_object * l_String_Slice_trimAscii(lean_object * slice) {
    lean_object * str_obj = lean_ctor_get(slice, 0);
    const char * str = lean_string_cstr(str_obj);
    size_t start = lean_unbox(lean_ctor_get(slice, 1));
    size_t stop = lean_unbox(lean_ctor_get(slice, 2));
    
    while (start < stop && (unsigned char)str[start] <= 32) start++;
    while (stop > start && (unsigned char)str[stop - 1] <= 32) stop--;
    
    lean_object * res = lean_alloc_ctor(0, 3, 0);
    lean_inc(str_obj);
    lean_ctor_set(res, 0, str_obj);
    lean_ctor_set(res, 1, lean_box(start));
    lean_ctor_set(res, 2, lean_box(stop));
    lean_dec(slice);
    return res;
}

lean_object * l_String_splitOnAux(lean_object * s_obj, lean_object * sep_obj, lean_object * i_obj, lean_object * j_obj, lean_object * pos_obj, lean_object * acc_obj) {
    const char * s = lean_string_cstr(s_obj);
    const char * sep = lean_string_cstr(sep_obj);
    size_t s_len = strlen(s);
    size_t sep_len = strlen(sep);
    
    lean_object * list = lean_box(0);
    
    if (sep_len == 0) {
        lean_inc(s_obj);
        lean_object * cons = lean_alloc_ctor(1, 2, 0);
        lean_ctor_set(cons, 0, s_obj);
        lean_ctor_set(cons, 1, list);
        lean_dec(s_obj);
        lean_dec(sep_obj);
        lean_dec(acc_obj);
        lean_dec(i_obj);
        lean_dec(j_obj);
        lean_dec(pos_obj);
        return cons;
    }
    
    size_t max_parts = s_len + 1;
    size_t * starts = (size_t*)malloc(max_parts * sizeof(size_t));
    size_t * ends = (size_t*)malloc(max_parts * sizeof(size_t));
    size_t count = 0;
    
    size_t cur = 0;
    while (cur <= s_len) {
        const char * found = strstr(s + cur, sep);
        if (found) {
            size_t idx = found - s;
            starts[count] = cur;
            ends[count] = idx;
            count++;
            cur = idx + sep_len;
        } else {
            starts[count] = cur;
            ends[count] = s_len;
            count++;
            break;
        }
    }
    
    for (size_t idx = count; idx > 0; idx--) {
        size_t part_start = starts[idx - 1];
        size_t part_end = ends[idx - 1];
        
        lean_object * sub = lean_string_utf8_extract(s_obj, lean_box(part_start), lean_box(part_end));
        
        lean_object * cons = lean_alloc_ctor(1, 2, 0);
        lean_ctor_set(cons, 0, sub);
        lean_ctor_set(cons, 1, list);
        list = cons;
    }
    
    free(starts);
    free(ends);
    
    lean_dec(s_obj);
    lean_dec(sep_obj);
    lean_dec(acc_obj);
    lean_dec(i_obj);
    lean_dec(j_obj);
    lean_dec(pos_obj);
    
    return list;
}

// =========================================================================
// Additional stubs for reverse, quote, slice, pos_! and Pattern buildTable
// =========================================================================

lean_object * l_List_reverse___redArg(lean_object * list) {
    lean_object * acc = lean_box(0);
    lean_object * cur = list;
    while (!lean_is_scalar(cur)) {
        lean_object * head = lean_ctor_get(cur, 0);
        lean_object * tail = lean_ctor_get(cur, 1);
        lean_inc(head);
        
        lean_object * cons = lean_alloc_ctor(1, 2, 0);
        lean_ctor_set(cons, 0, head);
        lean_ctor_set(cons, 1, acc);
        acc = cons;
        cur = tail;
    }
    lean_dec(list);
    return acc;
}

lean_object * l_Nat_reprFast(lean_object * nat) {
    size_t val = lean_unbox(nat);
    char buf[32];
    sprintf(buf, "%zu", val);
    lean_object * res = lean_mk_string(buf);
    lean_dec(nat);
    return res;
}

uint8_t l_String_Slice_posGE___redArg(lean_object * pos, lean_object * stop) {
    return lean_unbox(pos) >= lean_unbox(stop);
}

lean_object * l_String_Slice_pos_x21(lean_object * slice, lean_object * pos) {
    lean_object * str_obj = lean_ctor_get(slice, 0);
    const char * str = lean_string_cstr(str_obj);
    size_t p = lean_unbox(pos);
    uint32_t c = (unsigned char)str[p];
    return lean_box(c);
}

lean_object * l_String_Slice_slice_x21(lean_object * slice, lean_object * b, lean_object * e) {
    lean_object * str_obj = lean_ctor_get(slice, 0);
    lean_object * res = lean_alloc_ctor(0, 3, 0);
    lean_inc(str_obj);
    lean_ctor_set(res, 0, str_obj);
    lean_ctor_set(res, 1, b);
    lean_ctor_set(res, 2, e);
    lean_dec(slice);
    return res;
}

lean_object * l_String_Slice_toNat_x3f(lean_object * slice) {
    lean_object * s = l_String_Slice_toString(slice);
    const char * str = lean_string_cstr(s);
    char * end;
    long val = strtol(str, &end, 10);
    lean_object * res;
    if (end != str && val >= 0) {
        res = lean_alloc_ctor(1, 1, 0); // Option.some
        lean_ctor_set(res, 0, lean_box(val));
    } else {
        res = lean_box(0); // Option.none
    }
    lean_dec(s);
    return res;
}

lean_object * l_String_Slice_Pattern_ForwardSliceSearcher_buildTable(lean_object * pattern) {
    return lean_box(0);
}

lean_object * l_String_quote(lean_object * s) {
    const char * c = lean_string_cstr(s);
    size_t len = strlen(c);
    size_t sz = sizeof(lean_string_object) + len + 3;
    lean_string_object * o = (lean_string_object*)malloc(sz);
    o->m_header.m_rc = 1;
    o->m_header.m_tag = LeanString;
    o->m_size = len + 3;
    o->m_capacity = len + 3;
    o->m_length = len + 2;
    o->m_data[0] = '"';
    strcpy(o->m_data + 1, c);
    o->m_data[len + 1] = '"';
    o->m_data[len + 2] = '\0';
    lean_dec(s);
    return (lean_object*)o;
}
