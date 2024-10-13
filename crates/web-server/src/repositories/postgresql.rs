use crate::entities::organization::{
    CreateOrganizationRequest, Organization, UpdateOrganizationRequest,
};
use crate::error::PackageProError;
use crate::repositories::base::PackageProRepository;
use crate::utils::pagination::PaginatedSearchInput;
use crate::utils::slug::Slug;
use db::Pool;

#[derive(Clone, Debug)]
pub struct PostgresRepository {
    db: Pool,
}

impl PostgresRepository {
    pub fn new(db: Pool) -> Self {
        Self { db }
    }
}

impl PackageProRepository for PostgresRepository {
    async fn get_organization(&self, name: &Slug) -> Result<Organization, PackageProError> {
        todo!()
    }

    async fn list_organizations(
        &self,
        params: &PaginatedSearchInput,
    ) -> Result<Vec<Organization>, PackageProError> {
        todo!()
    }

    async fn count_organizations(
        &self,
        params: &PaginatedSearchInput,
    ) -> Result<u64, PackageProError> {
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
