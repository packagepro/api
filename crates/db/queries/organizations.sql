--: Organization(display_name?)

--! get_organization_by_id : Organization
SELECT id, name_slug, display_name
FROM organizations
WHERE organizations.id = :org_id;

--! get_organization_by_name : Organization
SELECT id, name_slug, display_name
FROM organizations
WHERE organizations.name_slug = :org_slug;