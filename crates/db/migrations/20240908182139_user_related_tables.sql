-- migrate:up
CREATE TABLE users
(
    username      varchar(255) PRIMARY KEY,
    email         varchar(255) UNIQUE NOT NULL,
    is_super_user boolean DEFAULT false,
    CONSTRAINT well_formatted_username CHECK (username ~* '^[a-z0-9-]+$'),
    CONSTRAINT well_formatted_email CHECK (email ~*
                                           '^[a-zA-Z0-9.!#$%&''''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$')
);

-- Allow users to belong to organizations
CREATE TYPE organization_role AS ENUM ('owner', 'admin', 'contributor', 'reader', 'no-access');
CREATE TABLE users_organizations
(
    username          varchar(255)      NOT NULL REFERENCES users ON DELETE CASCADE ON UPDATE CASCADE,
    organization_name varchar(255)      NOT NULL REFERENCES organizations ON DELETE CASCADE ON UPDATE CASCADE,
    role              organization_role NOT NULL,
    CONSTRAINT users_organizations_pkey PRIMARY KEY (username, organization_name)
);

CREATE INDEX idx__users_organizations__organization_name ON users_organizations (organization_name);

-- Set up methods for password authentication
CREATE TYPE basic_auth_method AS ENUM ('environment', 'basic');
CREATE TABLE user_basic_auth_methods
(
    -- NOTE: Primary Key is intentional here (enforces only one basic auth method per user)
    username varchar(255) PRIMARY KEY REFERENCES users ON DELETE CASCADE ON UPDATE CASCADE,
    method   basic_auth_method NOT NULL,
    value    varchar(255)
);

-- Insert the superuser
INSERT INTO users (username, email, is_super_user)
VALUES ('superuser', 'superuser@example.com', true);

-- Let the PACKAGE_PRO_SUPER_USER_PASSWORD environment variable determine the superuser's password
INSERT INTO user_basic_auth_methods (username, method, value)
VALUES ('superuser', 'environment', 'PACKAGE_PRO_SUPER_USER_PASSWORD');

-- migrate:down
DROP TABLE IF EXISTS user_basic_auth_methods;
DROP TYPE IF EXISTS basic_auth_method;
DROP TABLE IF EXISTS users_organizations;
DROP TYPE IF EXISTS organization_role;
DROP TABLE IF EXISTS users;
