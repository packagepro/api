--: Organization(display_name?)

--! get_organization: Organization
SELECT name_slug, display_name
FROM organizations
WHERE organizations.name_slug = :org_slug;

--! list_organizations_for_user: Organization
SELECT organizations.name_slug, organizations.display_name
FROM users_organizations
         INNER JOIN organizations ON organizations.name_slug = users_organizations.organization_name
WHERE users_organizations.username = :username;

--! find_organizations: Organization
SELECT name_slug, display_name
FROM organizations
WHERE levenshtein_less_equal(name_slug, :search, 2) <= 2
   OR levenshtein_less_equal(display_name, :search, 2) <= 2
   OR name_slug ILIKE CONCAT(:search, '%')
   OR display_name ILIKE CONCAT(:search, '%');

--! create_organization (display_name?)
INSERT INTO organizations (name_slug, display_name)
VALUES (:name_slug, :display_name);

--! update_organization (display_name?)
UPDATE organizations
SET name_slug    = :new_name_slug,
    display_name = :display_name
WHERE name_slug = :old_name_slug;

--! delete_organization
DELETE
FROM organizations
WHERE name_slug = :name_slug;
