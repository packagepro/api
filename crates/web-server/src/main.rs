use package_pro_api_server::config::Config;
use package_pro_api_server::http;

#[tokio::main]
async fn main() {
    let config = Config::new();
    http::serve(config).await;
}
