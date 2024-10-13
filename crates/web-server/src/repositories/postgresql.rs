use crate::entities::organization::{
    CreateOrganizationRequest, Organization, UpdateOrganizationRequest,
};
use crate::error::PackageProError;
use crate::repositories::base::PackageProRepository;
use crate::utils::pagination::PaginatedSearchInput;
use crate::utils::slug::Slug;
use db::Pool;
use std::future::Future;

pub struct PostgresRepository {
    db: Pool,
}

impl PackageProRepository for PostgresRepository {
    fn get_organization(
        &self,
        name: &Slug,
    ) -> impl Future<Output = Result<Organization, PackageProError>> + Send {
        todo!()
    }

    fn list_organizations(
        &self,
        params: &PaginatedSearchInput,
    ) -> impl Future<Output = Result<Vec<Organization>, PackageProError>> + Send {
        todo!()
    }

    fn count_organizations(
        &self,
        params: &PaginatedSearchInput,
    ) -> impl Future<Output = Result<u64, PackageProError>> + Send {
        todo!()
    }

    fn create_organization(
        &self,
        req: &CreateOrganizationRequest,
    ) -> impl Future<Output = Result<Organization, PackageProError>> + Send {
        todo!()
    }

    fn update_organization(
        &self,
        name: &Slug,
        req: &UpdateOrganizationRequest,
    ) -> impl Future<Output = Result<Organization, PackageProError>> + Send {
        todo!()
    }

    fn delete_organization(
        &self,
        name: &Slug,
    ) -> impl Future<Output = Result<Organization, PackageProError>> + Send {
        todo!()
    }
}
