(** Zarith/GMP conversions using the same C API as the original ppx_cstubs bridge. *)

module MPZ = struct
  type t
  type ptr = t Ctypes.abstract Ctypes.ptr

  external size : unit -> int = "faugere_zarith_size" [@@noalloc]
  external alignment : unit -> int = "faugere_zarith_alignment" [@@noalloc]
  external clear_raw : nativeint -> unit = "faugere_zarith_clear" [@@noalloc]
  external init_raw : nativeint -> unit = "faugere_zarith_init" [@@noalloc]
  external set_raw : Z.t -> nativeint -> unit = "faugere_zarith_set"
  external to_z_raw : nativeint -> Z.t = "faugere_zarith_to_z"

  let t : t Ctypes.abstract Ctypes.typ =
    Ctypes.abstract ~name:"__mpz_struct" ~size:(size ()) ~alignment:(alignment ())

  let with_ptr f p =
    let result = f (Ctypes.raw_address_of_ptr (Ctypes.to_voidp p)) in
    (* A raw address does not keep its Ctypes allocation alive during a call. *)
    ignore (Sys.opaque_identity p);
    result

  let clear p = with_ptr clear_raw p

  let make () =
    let r = Ctypes.allocate_n ~finalise:clear t ~count:1 in
    with_ptr init_raw r;
    r

  let of_z x =
    let r = make () in
    with_ptr (set_raw x) r;
    r

  let to_z p = with_ptr to_z_raw p
end
