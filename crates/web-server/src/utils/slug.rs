use crate::error::PackageProError;

#[derive(Clone, Debug)]
pub struct Slug(String);

impl Into<String> for Slug {
    fn into(self) -> String {
        self.0
    }
}

impl TryFrom<String> for Slug {
    type Error = PackageProError;

    fn try_from(value: String) -> Result<Self, Self::Error> {
        let all_chars_valid = value.chars().all(|c| match c {
            'a'..'z' | '0'..'9' | '-' => true,
            _ => false,
        });

        if all_chars_valid && value.len() > 0 {
            Ok(Self(value))
        } else {
            Err(PackageProError::InvalidSlug(value))
        }
    }
}
