use crate::entities::organization::{Organization, OrganizationRole};
use crate::entities::user::User;
use crate::utils::slug::Slug;

#[derive(Clone, Debug)]
pub struct Group {
    name: Slug,
    display_name: String,
}

#[derive(Clone, Debug)]
pub struct GroupOrganizationAgg {
    group: Group,
    organization: Organization,
    role: OrganizationRole,
}

#[derive(Clone, Debug)]
pub enum GroupRole {
    Owner,
    Member,
}

#[derive(Clone, Debug)]
pub struct GroupRoleGroupOrganizationAgg {
    organization: Organization,
    group: Group,
    role: GroupRole,
}

#[derive(Clone, Debug)]
pub struct OrganizationRoleGroupAgg {
    group: Group,
    role: OrganizationRole,
}

#[derive(Clone, Debug)]
pub struct UserGroupsAgg {
    user: User,
    groups: Vec<GroupRoleGroupOrganizationAgg>,
}

#[derive(Clone, Debug)]
pub struct OrganizationGroupsAgg {
    organization: Organization,
    groups: Vec<OrganizationRoleGroupAgg>,
}
