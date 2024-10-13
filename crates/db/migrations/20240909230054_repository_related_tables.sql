-- migrate:up
CREATE TYPE repository_type AS ENUM ('raw');
CREATE TABLE repositories
(
    organization_name    varchar(255)    NOT NULL REFERENCES organizations ON DELETE CASCADE ON UPDATE CASCADE,
    repository_name_slug varchar(255)    NOT NULL,
    type                 repository_type NOT NULL,
    description          varchar(255),
    scm_repository_url   varchar(255),
    created_at           date            NOT NULL DEFAULT now(),
    updated_at           date            NOT NULL DEFAULT now(),
    CONSTRAINT well_formatted_name_slug CHECK (repository_name_slug ~* '^[a-z0-9-]+$'),
    CONSTRAINT repositories_pkey PRIMARY KEY (organization_name, repository_name_slug)
);

CREATE TRIGGER repositories_update_modtime
    BEFORE UPDATE
    ON repositories
    FOR EACH ROW
EXECUTE PROCEDURE package_pro_update_modtime();

CREATE TABLE repository_labels
(
    organization_name    varchar(255) NOT NULL REFERENCES organizations ON DELETE CASCADE ON UPDATE CASCADE,
    repository_name_slug varchar(255) NOT NULL,
    label                varchar(255) NOT NULL,
    created_at           date         NOT NULL DEFAULT now(),
    FOREIGN KEY (organization_name, repository_name_slug) REFERENCES repositories (organization_name, repository_name_slug) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT repository_labels_pkey PRIMARY KEY (organization_name, repository_name_slug, label)
);

CREATE TYPE repository_role AS ENUM ('owner', 'admin', 'contributor', 'reader', 'no-access');
CREATE TABLE repositories_users_permissions
(
    username             varchar(255)    NOT NULL REFERENCES users ON DELETE CASCADE ON UPDATE CASCADE,
    organization_name    varchar(255)    NOT NULL REFERENCES organizations ON DELETE CASCADE ON UPDATE CASCADE,
    repository_name_slug varchar(255)    NOT NULL,
    role                 repository_role NOT NULL,
    created_at           date            NOT NULL DEFAULT now(),
    updated_at           date            NOT NULL DEFAULT now(),
    FOREIGN KEY (organization_name, repository_name_slug) REFERENCES repositories (organization_name, repository_name_slug) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT repositories_users_permissions_pkey PRIMARY KEY (username, organization_name, repository_name_slug)
);

CREATE TRIGGER repositories_users_permissions_update_modtime
    BEFORE UPDATE
    ON repositories_users_permissions
    FOR EACH ROW
EXECUTE PROCEDURE package_pro_update_modtime();

CREATE INDEX idx__repositories_users_permissions__username__organization_name ON repositories_users_permissions (username, organization_name);
CREATE INDEX idx__repositories_users_permissions__username__repository_name_slug ON repositories_users_permissions (username, repository_name_slug);

CREATE TABLE repositories_groups_permissions
(
    organization_name    varchar(255)    NOT NULL REFERENCES organizations ON DELETE CASCADE ON UPDATE CASCADE,
    group_name_slug      varchar(255)    NOT NULL,
    repository_name_slug varchar(255)    NOT NULL,
    role                 repository_role NOT NULL,
    created_at           date            NOT NULL DEFAULT now(),
    updated_at           date            NOT NULL DEFAULT now(),
    FOREIGN KEY (organization_name, repository_name_slug) REFERENCES repositories (organization_name, repository_name_slug) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (organization_name, group_name_slug) REFERENCES groups (organization_name, group_name_slug) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT repositories_groups_permissions_pkey PRIMARY KEY (organization_name, group_name_slug, repository_name_slug)
);

CREATE TRIGGER repositories_groups_permissions_update_modtime
    BEFORE UPDATE
    ON repositories_groups_permissions
    FOR EACH ROW
EXECUTE PROCEDURE package_pro_update_modtime();

-- migrate:down
DROP TABLE IF EXISTS repositories_groups_permissions;
DROP TABLE IF EXISTS repositories_users_permissions;
DROP TYPE IF EXISTS repository_role;
DROP TABLE IF EXISTS repository_labels;
DROP TABLE IF EXISTS repositories;
DROP TYPE IF EXISTS repository_type;
