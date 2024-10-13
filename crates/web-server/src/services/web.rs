use crate::entities::organization::{
    CreateOrganizationRequest, Organization, UpdateOrganizationRequest,
};
use crate::error::PackageProError;
use crate::repositories::base::PackageProRepository;
use crate::services::base::PackageProService;
use crate::utils::pagination::{PaginatedResult, PaginatedSearchInput};
use crate::utils::slug::Slug;

#[derive(Clone, Debug)]
pub struct WebService<R>
where
    R: PackageProRepository,
{
    repo: R,
}

impl<R> WebService<R>
where
    R: PackageProRepository,
{
    pub fn new(repo: R) -> Self {
        Self { repo }
    }
}

impl<R> PackageProService for WebService<R>
where
    R: PackageProRepository,
{
    async fn get_organization(&self, name: &Slug) -> Result<Organization, PackageProError> {
        todo!()
    }

    async fn list_organizations(
        &self,
        params: &PaginatedSearchInput,
    ) -> Result<PaginatedResult<Organization>, PackageProError> {
        todo!()
    }

    async fn create_organization(
        &self,
        req: &CreateOrganizationRequest,
    ) -> Result<Organization, PackageProError> {
        todo!()
    }

    async fn update_organization(
        &self,
        name: &Slug,
        req: &UpdateOrganizationRequest,
    ) -> Result<Organization, PackageProError> {
        todo!()
    }

    async fn delete_organization(&self, name: &Slug) -> Result<Organization, PackageProError> {
        todo!()
    }
}
