mod v1;

use crate::config::Config;
use axum::{Extension, Router};
use std::net::SocketAddr;
use std::str::FromStr;

pub async fn serve(config: Config) {
    let pool = db::create_pool(&config.database_url);

    let app = Router::new()
        .layer(Extension(config))
        .layer(Extension(pool));

    let bind_address = SocketAddr::from(([0, 0, 0, 0], 8080));
    let listener = tokio::net::TcpListener::bind(bind_address)
        .await
        .expect("bind was unsuccessful");
    axum::serve(listener, app).await.unwrap();
}
