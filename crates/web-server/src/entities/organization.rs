use crate::entities::user::User;

#[derive(Clone, Debug)]
pub struct Organization {
    name: String,
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
