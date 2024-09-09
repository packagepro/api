--: Organization(display_name?)

--! get_organization: Organization
SELECT name_slug, display_name
FROM organizations
WHERE organizations.name_slug = :org_slug;

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