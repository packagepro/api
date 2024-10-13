use thiserror::Error;

#[derive(Error, Debug)]
pub enum PackageProError {
    #[error("Invalid slug {0}.")]
    InvalidSlug(String),
}
