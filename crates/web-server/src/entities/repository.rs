use crate::entities::group::Group;
use crate::entities::organization::Organization;
use crate::entities::user::User;
use crate::utils::slug::Slug;

#[derive(Clone, Debug)]
pub enum RepositoryType {
    Raw,
}

#[derive(Clone, Debug)]
pub struct Repository {
    name: Slug,
    repository_type: RepositoryType,
    description: String,
    scm_repository_url: String,
}

#[derive(Clone, Debug)]
pub struct LabeledRepository {
    repository: Repository,
    labels: Vec<String>,
}

#[derive(Clone, Debug)]
pub enum RepositoryRole {
    Owner,
    Admin,
    Contributor,
    Reader,
    NoAccess,
}

#[derive(Clone, Debug)]
pub struct OrganizationRepositoriesAgg {
    organization: Organization,
    repositories: Vec<Repository>,
}

#[derive(Clone, Debug)]
pub struct RepositoryRoleUserAgg {
    user: User,
    role: RepositoryRole,
}

#[derive(Clone, Debug)]
pub struct RepositoryRoleGroupAgg {
    group: Group,
    role: RepositoryRole,
}
