use std::{
    env, 
    error::Error, 
    fs::{self, File}, 
    io::Write, 
    path::PathBuf,
};

fn main() -> Result<(), Box<dyn Error>> {
    // build directory for this crate
    let out_dir = PathBuf::from(env::var_os("OUT_DIR").unwrap());

    // Extend the library search path
    println!("cargo:rustc-link-search={}", out_dir.display());

    // put "link.x" in the build directory
    File::create(out_dir.join("link.x"))?.write_all(include_bytes!("link.x"))?;

    // link to "librt.a"
    fs::copy("librt.a", out_dir.join("librt.a"));

    // rebuild if "librt.a" has changed
    println!("cargo::rerun-if-changed=librt.a");

    Ok(())
}
