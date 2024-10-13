use crate::entities::repository::Repository;
use crate::entities::user::User;

#[derive(Clone, Debug)]
pub struct Artifact {
    version: String,
    published_at: chrono::DateTime<chrono::Utc>,
}

#[derive(Clone, Debug)]
pub struct ArtifactDigests {
    sha1: String,
    sha256: String,
    sha512: String,
    md5: String,
    blake2b_256: String,
}

#[derive(Clone, Debug)]
pub struct ArtifactLicense {
    spdx_identifier: String,
    spdx_full_name: String,
}

#[derive(Clone, Debug)]
pub struct DetailedArtifact {
    repository: Repository,
    artifact: Artifact,
    author: User,
    licenses: Vec<ArtifactLicense>,
    digests: ArtifactDigests,
    uncompressed_byte_count: u64,
    compressed_byte_count: u64,
}
