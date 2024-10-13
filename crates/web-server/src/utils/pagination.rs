/// Offset pagination uses the traditional "limit + offset" semantics
#[derive(Clone, Debug)]
pub struct OffsetPagination {
    pub limit: u64,
    pub offset: u64,
}

/// Supported types of pagination
#[derive(Clone, Debug)]
pub enum Pagination {
    Offset(OffsetPagination),
}

/// Used as an input to perform a simple string search on a paginated list.
#[derive(Clone, Debug)]
pub struct PaginatedSearchInput {
    pub pagination: Pagination,
    pub search: String,
}

/// Used as an input to filter a paginated list.
#[derive(Clone, Debug)]
pub struct PaginatedFilterInput<T> {
    pub pagination: Pagination,
    pub filter: T,
}

/// The necessary data for a paginated list result.
#[derive(Clone, Debug)]
pub struct PaginatedResult<T> {
    pub data: Vec<T>,
    pub count: u64,
    pub pagination: Pagination,
}
