use crate::entities::organization::{
    CreateOrganizationRequest, Organization, UpdateOrganizationRequest,
};
use crate::error::PackageProError;
use crate::repositories::base::PackageProRepository;
use crate::services::base::PackageProService;
use crate::utils::pagination::{PaginatedResult, PaginatedSearchInput};
use crate::utils::slug::Slug;
use std::future::Future;

pub struct WebService<R>
where
    R: PackageProRepository,
{
    repo: R,
}

impl<R> PackageProService for WebService<R>
where
    R: PackageProRepository,
{
    fn get_organization(
        &self,
        name: &Slug,
    ) -> impl Future<Output = Result<Organization, PackageProError>> + Send {
        todo!()
    }

    fn list_organizations(
        &self,
        params: &PaginatedSearchInput,
    ) -> impl Future<Output = Result<PaginatedResult<Organization>, PackageProError>> + Send {
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
