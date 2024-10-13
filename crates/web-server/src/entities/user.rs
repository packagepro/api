use crate::utils::slug::Slug;

#[derive(Clone, Debug)]
pub struct User {
    username: Slug,
    email: String,
    is_super_user: bool,
}
