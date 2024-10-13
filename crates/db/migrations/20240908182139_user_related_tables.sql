-- migrate:up
CREATE TABLE users
(
    username      varchar(255) PRIMARY KEY,
    email         varchar(254) UNIQUE NOT NULL,
    password_hash varchar(256)        NOT NULL,
    is_super_user boolean             NOT NULL DEFAULT false,
    created_at    date                NOT NULL DEFAULT now(),
    updated_at    date                NOT NULL DEFAULT now(),
    CONSTRAINT well_formatted_username CHECK (username ~* '^[a-z0-9-]+$'),
    CONSTRAINT well_formatted_email CHECK (email ~*
                                           '^[a-zA-Z0-9.!#$%&''''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$')
);

CREATE TRIGGER users_update_modtime
    BEFORE UPDATE
    ON users
    FOR EACH ROW
EXECUTE PROCEDURE package_pro_update_modtime();


-- Allow users to belong to organizations
CREATE TYPE organization_role AS ENUM ('owner', 'admin', 'contributor', 'reader', 'no-access');
CREATE TABLE users_organizations
(
    username          varchar(255)      NOT NULL REFERENCES users ON DELETE CASCADE ON UPDATE CASCADE,
    organization_name varchar(255)      NOT NULL REFERENCES organizations ON DELETE CASCADE ON UPDATE CASCADE,
    role              organization_role NOT NULL,
    created_at        date              NOT NULL DEFAULT now(),
    updated_at        date              NOT NULL DEFAULT now(),
    CONSTRAINT users_organizations_pkey PRIMARY KEY (username, organization_name)
);

CREATE TRIGGER users_organizations_update_modtime
    BEFORE UPDATE
    ON users_organizations
    FOR EACH ROW
EXECUTE PROCEDURE package_pro_update_modtime();


CREATE INDEX idx__users_organizations__organization_name ON users_organizations (organization_name);

-- migrate:down
DROP TABLE IF EXISTS users_organizations;
DROP TYPE IF EXISTS organization_role;
DROP TABLE IF EXISTS users;
