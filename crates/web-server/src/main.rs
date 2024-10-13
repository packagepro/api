use package_pro_api_server::apps::axum_server::{AxumServer, AxumServerConfig};
use package_pro_api_server::config::Config;
use package_pro_api_server::repositories::postgresql::PostgresRepository;
use package_pro_api_server::services::web::WebService;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let config = Config::from_env()?;

    let pool = db::create_pool(&config.database_url);
    let repo = PostgresRepository::new(pool);
    let service = WebService::new(repo);

    let server_config = AxumServerConfig { port: &config.port };
    let server = AxumServer::new(service, server_config).await?;
    server.run().await
}
