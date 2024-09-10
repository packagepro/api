-- migrate:up
CREATE TABLE groups
(
    organization_name  varchar(255)      NOT NULL REFERENCES organizations ON DELETE CASCADE ON UPDATE CASCADE,
    group_name_slug    varchar(255)      NOT NULL,
    group_display_name varchar(255),
    -- The organization-level permissions that this groups has
    role               organization_role NOT NULL,
    CONSTRAINT groups_pkey PRIMARY KEY (organization_name, group_name_slug),
    CONSTRAINT well_formatted_name_slug CHECK (group_name_slug ~* '^[a-z0-9-]+$')
);

CREATE INDEX idx__groups__display_name ON groups (group_name_slug);

-- Allow users to belong to groups
CREATE TYPE group_role AS ENUM ('owner', 'member');
CREATE TABLE users_groups
(
    username          varchar(255) NOT NULL REFERENCES users ON DELETE CASCADE ON UPDATE CASCADE,
    organization_name varchar(255) NOT NULL,
    group_name_slug   varchar(255) NOT NULL,
    role              group_role   NOT NULL,
    FOREIGN KEY (organization_name, group_name_slug) REFERENCES groups (organization_name, group_name_slug),
    CONSTRAINT users_groups_pkey PRIMARY KEY (username, organization_name, group_name_slug)
);

CREATE INDEX idx__users_groups__username__organization_name ON users_groups (username, organization_name);
CREATE INDEX idx__users_groups__username__group_name_slug ON users_groups (username, group_name_slug);

-- migrate:down
DROP TABLE IF EXISTS users_groups;
DROP TYPE IF EXISTS group_role;
DROP TABLE IF EXISTS groups;
