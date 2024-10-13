#[derive(Clone, Debug)]
pub struct Config {
    pub port: String,
    pub database_url: String,
}

impl Config {
    pub fn from_env() -> anyhow::Result<Self> {
        let port = std::env::var("PORT").unwrap_or("8000".to_string());
        let database_url = std::env::var("DATABASE_URL").expect("DATABASE_URL should be set");

        Ok(Self { port, database_url })
    }
}
