-- migrate:up
CREATE FUNCTION package_pro_update_modtime()
    RETURNS TRIGGER
    LANGUAGE plpgsql AS
$$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;

CREATE TABLE organizations
(
    name_slug    varchar(255) PRIMARY KEY,
    display_name varchar(255),
    created_at   date NOT NULL DEFAULT now(),
    updated_at   date NOT NULL DEFAULT now(),
    CONSTRAINT well_formatted_name_slug CHECK (name_slug ~* '^[a-z0-9-]+$')
);

CREATE INDEX idx__organizations__display_name ON organizations (display_name);

CREATE TRIGGER organizations_update_modtime
    BEFORE UPDATE
    ON organizations
    FOR EACH ROW
EXECUTE PROCEDURE package_pro_update_modtime();

-- migrate:down
DROP TABLE IF EXISTS organizations;
DROP FUNCTION package_pro_update_modtime();