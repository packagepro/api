-- migrate:up
CREATE TABLE organizations
(
    id   uuid,
    name varchar(256)
);

-- migrate:down
DROP TABLE IF EXISTS organizations;
