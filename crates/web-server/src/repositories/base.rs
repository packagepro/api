use crate::entities::organization::{
    CreateOrganizationRequest, Organization, UpdateOrganizationRequest,
};
use crate::error::PackageProError;
use crate::utils::pagination::PaginatedSearchInput;
use crate::utils::slug::Slug;
use std::future::Future;

pub trait PackageProRepository: Clone + Send + Sync + 'static {
    /// Gets an organization based on the name.
    fn get_organization(
        &self,
        name: &Slug,
    ) -> impl Future<Output = Result<Organization, PackageProError>> + Send;

    /// Gets a paginated list of organizations for the specified parameters.
    fn list_organizations(
        &self,
        params: &PaginatedSearchInput,
    ) -> impl Future<Output = Result<Vec<Organization>, PackageProError>> + Send;

    /// Gets the total number of organizations for the specified parameters.
    fn count_organizations(
        &self,
        params: &PaginatedSearchInput,
    ) -> impl Future<Output = Result<u64, PackageProError>> + Send;

    /// Creates an organization
    fn create_organization(
        &self,
        req: &CreateOrganizationRequest,
    ) -> impl Future<Output = Result<Organization, PackageProError>> + Send;

    /// Updates an organization based on the name.
    fn update_organization(
        &self,
        name: &Slug,
        req: &UpdateOrganizationRequest,
    ) -> impl Future<Output = Result<Organization, PackageProError>> + Send;

    /// Deletes an organization based on the name.
    fn delete_organization(
        &self,
        name: &Slug,
    ) -> impl Future<Output = Result<Organization, PackageProError>> + Send;
}
