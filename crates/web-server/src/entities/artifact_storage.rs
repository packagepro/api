use std::path::PathBuf;
use uuid::Uuid;

#[derive(Clone, Debug)]
pub struct FileSystemConfiguration {
    path: PathBuf,
}

#[derive(Clone, Debug)]
pub struct S3Configuration {}

#[derive(Clone, Debug)]
pub struct AzureBlobStorageConfiguration {}

#[derive(Clone, Debug)]
pub enum ArtifactStorageConfig {
    FileSystem(FileSystemConfiguration),
    S3(S3Configuration),
    AzureBlobStorage(AzureBlobStorageConfiguration),
}

#[derive(Clone, Debug)]
pub struct ArtifactStorage {
    id: Uuid,
    config: ArtifactStorageConfig,
    notes: String,
}
