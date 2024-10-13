use crate::entities::organization::{
    CreateOrganizationRequest, Organization, UpdateOrganizationRequest,
};
use crate::error::PackageProError;
use std::future::Future;

pub trait PackageProRepository: Send + Sync + 'static {
    fn get_organization(
        &self,
        name: &str,
    ) -> impl Future<Output = Result<Organization, PackageProError>> + Send;

    fn list_organizations(
        &self,
        name: &str,
    ) -> impl Future<Output = Result<Vec<Organization>, PackageProError>> + Send;

    fn create_organization(
        &self,
        req: &CreateOrganizationRequest,
    ) -> impl Future<Output = Result<Organization, PackageProError>> + Send;

    fn update_organization(
        &self,
        req: &UpdateOrganizationRequest,
    ) -> impl Future<Output = Result<Organization, PackageProError>> + Send;

    fn delete_organization(
        &self,
        name: &str,
    ) -> impl Future<Output = Result<Organization, PackageProError>> + Send;
}
