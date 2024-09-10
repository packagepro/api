-- migrate:up
CREATE TYPE repository_type AS ENUM ('raw');
CREATE TABLE repositories
(
    organization_name    varchar(255)    NOT NULL REFERENCES organizations ON DELETE CASCADE ON UPDATE CASCADE,
    repository_name_slug varchar(255)    NOT NULL,
    type                 repository_type NOT NULL,
    CONSTRAINT well_formatted_name_slug CHECK (repository_name_slug ~* '^[a-z0-9-]+$'),
    CONSTRAINT repositories_pkey PRIMARY KEY (organization_name, repository_name_slug)
);

CREATE TYPE repository_role AS ENUM ('owner', 'admin', 'contributor', 'reader', 'no-access');
CREATE TABLE repositories_users_permissions
(
    username             varchar(255)    NOT NULL REFERENCES users ON DELETE CASCADE ON UPDATE CASCADE,
    organization_name    varchar(255)    NOT NULL REFERENCES organizations ON DELETE CASCADE ON UPDATE CASCADE,
    repository_name_slug varchar(255)    NOT NULL,
    role                 repository_role NOT NULL,
    FOREIGN KEY (organization_name, repository_name_slug) REFERENCES repositories (organization_name, repository_name_slug),
    CONSTRAINT repositories_users_permissions_pkey PRIMARY KEY (username, organization_name, repository_name_slug)
);

CREATE INDEX idx__repositories_users_permissions__username__organization_name ON repositories_users_permissions (username, organization_name);
CREATE INDEX idx__repositories_users_permissions__username__repository_name_slug ON repositories_users_permissions (username, repository_name_slug);

CREATE TABLE repositories_groups_permissions
(
    organization_name    varchar(255)    NOT NULL REFERENCES organizations ON DELETE CASCADE ON UPDATE CASCADE,
    group_name_slug      varchar(255)    NOT NULL,
    repository_name_slug varchar(255)    NOT NULL,
    role                 repository_role NOT NULL,
    FOREIGN KEY (organization_name, repository_name_slug) REFERENCES repositories (organization_name, repository_name_slug),
    FOREIGN KEY (organization_name, group_name_slug) REFERENCES groups (organization_name, group_name_slug),
    CONSTRAINT repositories_groups_permissions_pkey PRIMARY KEY (organization_name, group_name_slug, repository_name_slug)
);
-- migrate:down
DROP TABLE IF EXISTS repositories_groups_permissions;
DROP TABLE IF EXISTS repositories_users_permissions;
DROP TYPE IF EXISTS repository_role;
DROP TABLE IF EXISTS repositories;
DROP TYPE IF EXISTS repository_type;
