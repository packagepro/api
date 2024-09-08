-- migrate:up
CREATE TABLE users
(
    id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    username      varchar(256) NOT NULL UNIQUE,
    email         varchar(256) NOT NULL,
    is_super_user boolean          DEFAULT false,
    CONSTRAINT well_formatted_email CHECK (email ~*
                                           '^[a-zA-Z0-9.!#$%&''''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$')
);

CREATE TYPE basic_auth_method AS ENUM ('environment', 'basic');

CREATE TABLE user_basic_auth_methods
(
    user_id uuid PRIMARY KEY REFERENCES users ON DELETE CASCADE ON UPDATE CASCADE,
    method  basic_auth_method NOT NULL,
    value   varchar(256)
);

INSERT INTO users (username, email, is_super_user)
VALUES ('superuser', 'superuser@example.com', true);

INSERT INTO user_basic_auth_methods (user_id, method, value) (SELECT id, 'environment', 'PACKAGE_PRO_SUPER_USER_PASSWORD'
                                                              FROM users
                                                              WHERE username = 'admin');

-- migrate:down
DROP TABLE IF EXISTS user_basic_auth_methods;
DROP TYPE IF EXISTS basic_auth_method;
DROP TABLE IF EXISTS users;
