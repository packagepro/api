use cornucopia::CodegenSettings;
use postgres::{Client, NoTls};
use std::env;
use std::path::Path;

fn main() -> Result<(), cornucopia::Error> {
    // Compile our SQL
    cornucopia()
}

fn cornucopia() -> Result<(), cornucopia::Error> {
    let queries_path = "queries";

    let out_dir = env::var_os("OUT_DIR").unwrap();
    let file_path = Path::new(&out_dir).join("cornucopia.rs");

    let settings = CodegenSettings {
        is_async: true,
        derive_ser: false,
    };

    let db_url = std::env::var("DATABASE_URL").unwrap();
    let mut client = Client::connect(&db_url, NoTls).unwrap();

    // Rerun this build script if the queries or migrations change.
    println!("cargo:rerun-if-changed={queries_path}");
    println!("cargo:rerun-if-changed=schema.sql");

    cornucopia::generate_live(
        &mut client,
        queries_path,
        Some(&file_path.to_string_lossy()),
        settings,
    )?;

    Ok(())
}
