use std::path::PathBuf;

fn main() {
    let project_dir = std::env::var("CARGO_MANIFEST_DIR").unwrap();
    let lib_path = PathBuf::from(project_dir).join("lib");
    println!("cargo:rustc-link-search=native={}", lib_path.display());

    println!("cargo:rustc-link-lib=static=gcdlib"); 

    println!("cargo:rustc-link-lib=dylib=gnat");
    println!("cargo:rerun-if-changed=lib/libgcdlib.a");
}
