use std::str::FromStr;

pub use cornucopia_async::Params;
pub use deadpool_postgres::{Pool, PoolError, Transaction};
pub use tokio_postgres::Error as TokioPostgresError;

pub fn create_pool(database_url: &str) -> Pool {
    // TODO: Remove Unwraps
    let config = tokio_postgres::Config::from_str(database_url).unwrap();
    let manager = deadpool_postgres::Manager::new(config, tokio_postgres::NoTls);
    Pool::builder(manager).build().unwrap()
}

include!(concat!(env!("OUT_DIR"), "/cornucopia.rs"));
