#include <stddef.h>
#include <gmp.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <zarith.h>

CAMLprim value arbduet_zarith_size(value unit)
{
  return Val_long(sizeof(__mpz_struct));
}

CAMLprim value arbduet_zarith_alignment(value unit)
{
  struct aligned_mpz { char c; __mpz_struct z; };
  return Val_long(offsetof(struct aligned_mpz, z));
}

CAMLprim value arbduet_zarith_clear(value ptr)
{
  mpz_clear((mpz_ptr) Nativeint_val(ptr));
  return Val_unit;
}

CAMLprim value arbduet_zarith_init(value ptr)
{
  mpz_init((mpz_ptr) Nativeint_val(ptr));
  return Val_unit;
}

CAMLprim value arbduet_zarith_set(value z, value ptr)
{
  CAMLparam2(z, ptr);
  ml_z_mpz_set_z((mpz_ptr) Nativeint_val(ptr), z);
  CAMLreturn(Val_unit);
}

CAMLprim value arbduet_zarith_to_z(value ptr)
{
  CAMLparam1(ptr);
  CAMLreturn(ml_z_from_mpz((mpz_ptr) Nativeint_val(ptr)));
}
