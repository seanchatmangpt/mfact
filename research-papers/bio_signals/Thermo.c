// Lean compiler output
// Module: Thermo
// Imports: public import Init public meta import Init
#include <lean/lean.h>
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wunused-parameter"
#pragma clang diagnostic ignored "-Wunused-label"
#elif defined(__GNUC__) && !defined(__CLANG__)
#pragma GCC diagnostic ignored "-Wunused-parameter"
#pragma GCC diagnostic ignored "-Wunused-label"
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
#endif
#ifdef __cplusplus
extern "C" {
#endif
LEAN_EXPORT lean_object* l_BioSignal_ctorIdx(uint8_t);
LEAN_EXPORT lean_object* l_BioSignal_ctorIdx___boxed(lean_object*);
LEAN_EXPORT lean_object* l_BioSignal_toCtorIdx(uint8_t);
LEAN_EXPORT lean_object* l_BioSignal_toCtorIdx___boxed(lean_object*);
LEAN_EXPORT lean_object* l_BioSignal_ctorElim___redArg(lean_object*);
LEAN_EXPORT lean_object* l_BioSignal_ctorElim___redArg___boxed(lean_object*);
LEAN_EXPORT lean_object* l_BioSignal_ctorElim(lean_object*, lean_object*, uint8_t, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_BioSignal_ctorElim___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_BioSignal_Propagating_elim___redArg(lean_object*);
LEAN_EXPORT lean_object* l_BioSignal_Propagating_elim___redArg___boxed(lean_object*);
LEAN_EXPORT lean_object* l_BioSignal_Propagating_elim(lean_object*, uint8_t, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_BioSignal_Propagating_elim___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_BioSignal_Attenuated_elim___redArg(lean_object*);
LEAN_EXPORT lean_object* l_BioSignal_Attenuated_elim___redArg___boxed(lean_object*);
LEAN_EXPORT lean_object* l_BioSignal_Attenuated_elim(lean_object*, uint8_t, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_BioSignal_Attenuated_elim___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_energy(uint8_t);
LEAN_EXPORT lean_object* l_energy___boxed(lean_object*);
LEAN_EXPORT lean_object* l_BioSignal_ctorIdx(uint8_t v_x_1_){
_start:
{
if (v_x_1_ == 0)
{
lean_object* v___x_2_; 
v___x_2_ = lean_unsigned_to_nat(0u);
return v___x_2_;
}
else
{
lean_object* v___x_3_; 
v___x_3_ = lean_unsigned_to_nat(1u);
return v___x_3_;
}
}
}
LEAN_EXPORT lean_object* l_BioSignal_ctorIdx___boxed(lean_object* v_x_4_){
_start:
{
uint8_t v_x_boxed_5_; lean_object* v_res_6_; 
v_x_boxed_5_ = lean_unbox(v_x_4_);
v_res_6_ = l_BioSignal_ctorIdx(v_x_boxed_5_);
return v_res_6_;
}
}
LEAN_EXPORT lean_object* l_BioSignal_toCtorIdx(uint8_t v_x_7_){
_start:
{
lean_object* v___x_8_; 
v___x_8_ = l_BioSignal_ctorIdx(v_x_7_);
return v___x_8_;
}
}
LEAN_EXPORT lean_object* l_BioSignal_toCtorIdx___boxed(lean_object* v_x_9_){
_start:
{
uint8_t v_x_4__boxed_10_; lean_object* v_res_11_; 
v_x_4__boxed_10_ = lean_unbox(v_x_9_);
v_res_11_ = l_BioSignal_toCtorIdx(v_x_4__boxed_10_);
return v_res_11_;
}
}
LEAN_EXPORT lean_object* l_BioSignal_ctorElim___redArg(lean_object* v_k_12_){
_start:
{
lean_inc(v_k_12_);
return v_k_12_;
}
}
LEAN_EXPORT lean_object* l_BioSignal_ctorElim___redArg___boxed(lean_object* v_k_13_){
_start:
{
lean_object* v_res_14_; 
v_res_14_ = l_BioSignal_ctorElim___redArg(v_k_13_);
lean_dec(v_k_13_);
return v_res_14_;
}
}
LEAN_EXPORT lean_object* l_BioSignal_ctorElim(lean_object* v_motive_15_, lean_object* v_ctorIdx_16_, uint8_t v_t_17_, lean_object* v_h_18_, lean_object* v_k_19_){
_start:
{
lean_inc(v_k_19_);
return v_k_19_;
}
}
LEAN_EXPORT lean_object* l_BioSignal_ctorElim___boxed(lean_object* v_motive_20_, lean_object* v_ctorIdx_21_, lean_object* v_t_22_, lean_object* v_h_23_, lean_object* v_k_24_){
_start:
{
uint8_t v_t_boxed_25_; lean_object* v_res_26_; 
v_t_boxed_25_ = lean_unbox(v_t_22_);
v_res_26_ = l_BioSignal_ctorElim(v_motive_20_, v_ctorIdx_21_, v_t_boxed_25_, v_h_23_, v_k_24_);
lean_dec(v_k_24_);
lean_dec(v_ctorIdx_21_);
return v_res_26_;
}
}
LEAN_EXPORT lean_object* l_BioSignal_Propagating_elim___redArg(lean_object* v_Propagating_27_){
_start:
{
lean_inc(v_Propagating_27_);
return v_Propagating_27_;
}
}
LEAN_EXPORT lean_object* l_BioSignal_Propagating_elim___redArg___boxed(lean_object* v_Propagating_28_){
_start:
{
lean_object* v_res_29_; 
v_res_29_ = l_BioSignal_Propagating_elim___redArg(v_Propagating_28_);
lean_dec(v_Propagating_28_);
return v_res_29_;
}
}
LEAN_EXPORT lean_object* l_BioSignal_Propagating_elim(lean_object* v_motive_30_, uint8_t v_t_31_, lean_object* v_h_32_, lean_object* v_Propagating_33_){
_start:
{
lean_inc(v_Propagating_33_);
return v_Propagating_33_;
}
}
LEAN_EXPORT lean_object* l_BioSignal_Propagating_elim___boxed(lean_object* v_motive_34_, lean_object* v_t_35_, lean_object* v_h_36_, lean_object* v_Propagating_37_){
_start:
{
uint8_t v_t_boxed_38_; lean_object* v_res_39_; 
v_t_boxed_38_ = lean_unbox(v_t_35_);
v_res_39_ = l_BioSignal_Propagating_elim(v_motive_34_, v_t_boxed_38_, v_h_36_, v_Propagating_37_);
lean_dec(v_Propagating_37_);
return v_res_39_;
}
}
LEAN_EXPORT lean_object* l_BioSignal_Attenuated_elim___redArg(lean_object* v_Attenuated_40_){
_start:
{
lean_inc(v_Attenuated_40_);
return v_Attenuated_40_;
}
}
LEAN_EXPORT lean_object* l_BioSignal_Attenuated_elim___redArg___boxed(lean_object* v_Attenuated_41_){
_start:
{
lean_object* v_res_42_; 
v_res_42_ = l_BioSignal_Attenuated_elim___redArg(v_Attenuated_41_);
lean_dec(v_Attenuated_41_);
return v_res_42_;
}
}
LEAN_EXPORT lean_object* l_BioSignal_Attenuated_elim(lean_object* v_motive_43_, uint8_t v_t_44_, lean_object* v_h_45_, lean_object* v_Attenuated_46_){
_start:
{
lean_inc(v_Attenuated_46_);
return v_Attenuated_46_;
}
}
LEAN_EXPORT lean_object* l_BioSignal_Attenuated_elim___boxed(lean_object* v_motive_47_, lean_object* v_t_48_, lean_object* v_h_49_, lean_object* v_Attenuated_50_){
_start:
{
uint8_t v_t_boxed_51_; lean_object* v_res_52_; 
v_t_boxed_51_ = lean_unbox(v_t_48_);
v_res_52_ = l_BioSignal_Attenuated_elim(v_motive_47_, v_t_boxed_51_, v_h_49_, v_Attenuated_50_);
lean_dec(v_Attenuated_50_);
return v_res_52_;
}
}
LEAN_EXPORT lean_object* l_energy(uint8_t v_s_53_){
_start:
{
if (v_s_53_ == 0)
{
lean_object* v___x_54_; 
v___x_54_ = lean_unsigned_to_nat(10u);
return v___x_54_;
}
else
{
lean_object* v___x_55_; 
v___x_55_ = lean_unsigned_to_nat(0u);
return v___x_55_;
}
}
}
LEAN_EXPORT lean_object* l_energy___boxed(lean_object* v_s_56_){
_start:
{
uint8_t v_s_boxed_57_; lean_object* v_res_58_; 
v_s_boxed_57_ = lean_unbox(v_s_56_);
v_res_58_ = l_energy(v_s_boxed_57_);
return v_res_58_;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_Init(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_Thermo(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
