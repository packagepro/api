-- migrate:up
CREATE EXTENSION "pgcrypto";
CREATE TABLE organizations
(
    id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name_slug    varchar(256) NOT NULL UNIQUE,
    display_name varchar(256),
    CONSTRAINT well_formatted_name_slug CHECK (name_slug ~* '/^[a-z0-9-]+$/')
);

-- migrate:down
DROP TABLE IF EXISTS organizations;
DROP EXTENSION "pgcrypto";
