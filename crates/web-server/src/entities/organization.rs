use crate::entities::user::User;
use crate::utils::slug::Slug;

#[derive(Clone, Debug)]
pub struct Organization {
    name: Slug,
    display_name: String,
}

#[derive(Clone, Debug)]
pub enum OrganizationRole {
    Owner,
    Admin,
    Contributor,
    Reader,
    NoAccess,
}

#[derive(Clone, Debug)]
pub struct OrganizationRoleOrganizationAgg {
    organization: Organization,
    role: OrganizationRole,
}

#[derive(Clone, Debug)]
pub struct OrganizationRoleUserAgg {
    user: User,
    role: OrganizationRole,
}

#[derive(Clone, Debug)]
pub struct UserOrganizationsAgg {
    user: User,
    organizations: Vec<OrganizationRoleOrganizationAgg>,
}

#[derive(Clone, Debug)]
pub struct OrganizationUsersAgg {
    organization: Organization,
    users: Vec<OrganizationRoleUserAgg>,
}

#[derive(Clone, Debug)]
pub struct CreateOrganizationRequest {
    name: Slug,
    display_name: String,
}

#[derive(Clone, Debug)]
pub struct UpdateOrganizationRequest {
    name: Some(Slug),
    display_name: Some(String),
}
