(* virt-dib
 * Copyright (C) 2017 Red Hat Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *)

open Common_utils
open Common_gettext.Gettext

open Output_format

let squashfs_check (g : Guestfs.guestfs) =
  g#available [| "squashfs" |]

let squashfs_run_fs (g : Guestfs.guestfs) filename _ =
  message (f_"Compressing the image as squashfs");
  g#mksquashfs ~excludes:[| "sys/*"; "proc/*"; "dev/*" |] ~compress:"xz"
    "/" filename

let fmt = {
  defaults with
    name = "squashfs";
    check_appliance_prerequisites = Some squashfs_check;
    run_on_filesystem = Some squashfs_run_fs;
}

let () = register_format fmt
