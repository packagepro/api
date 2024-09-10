-- migrate:up
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE TYPE artifact_storage_type AS ENUM ('file-system', 's3', 'azure-blob-storage');
CREATE TABLE artifact_storage_configuration
(
    id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_name varchar(255)          NOT NULL REFERENCES organizations ON DELETE CASCADE ON UPDATE CASCADE,
    type              artifact_storage_type NOT NULL,
    configuration     json                  NOT NULL,
    notes             text
);

CREATE TABLE artifacts
(
    organization_name       varchar(255) NOT NULL REFERENCES organizations ON DELETE CASCADE ON UPDATE CASCADE,
    repository_name_slug    varchar(255) NOT NULL,
    version_name            varchar(255) NOT NULL,
    storage_configuration   uuid         NOT NULL REFERENCES artifact_storage_configuration ON DELETE RESTRICT ON UPDATE CASCADE,
    storage_location        text         NOT NULL,
    author                  varchar(255) NOT NULL REFERENCES users ON DELETE RESTRICT ON UPDATE CASCADE,
    uncompressed_byte_count bigint       NOT NULL,
    compressed_byte_count   bigint       NOT NULL,
    hash_sha1               varchar(255) NOT NULL,
    hash_sha256             varchar(255) NOT NULL,
    hash_sha512             varchar(255) NOT NULL,
    hash_md5                varchar(255) NOT NULL,
    hash_blake2b_256        varchar(255) NOT NULL,
    published_at            date         NOT NULL DEFAULT NOW(),
    FOREIGN KEY (organization_name, repository_name_slug) REFERENCES repositories (organization_name, repository_name_slug) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT artifacts_pkey PRIMARY KEY (organization_name, repository_name_slug, version_name)
);

-- Multiple licenses can be applied to the same artifact
CREATE TABLE artifact_licenses
(
    organization_name    varchar(255) NOT NULL REFERENCES organizations ON DELETE CASCADE ON UPDATE CASCADE,
    repository_name_slug varchar(255) NOT NULL,
    version_name         varchar(255) NOT NULL,
    spdx_identifier      varchar(255) NOT NULL,
    spdx_full_name       varchar(255) NOT NULL,
    FOREIGN KEY (organization_name, repository_name_slug, version_name) REFERENCES artifacts (organization_name, repository_name_slug, version_name),
    CONSTRAINT artifact_licenses_pkey PRIMARY KEY (organization_name, repository_name_slug, version_name,
                                                   spdx_identifier)
);

-- migrate:down
DROP TABLE IF EXISTS artifact_licenses;
DROP TABLE IF EXISTS artifacts;
DROP TABLE IF EXISTS artifact_storage_configuration;
DROP TYPE IF EXISTS artifact_storage_type;
DROP EXTENSION IF EXISTS "pgcrypto";
