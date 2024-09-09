mod v1;

use axum::Router;
use std::str::FromStr;

pub async fn serve() {
    let app = Router::new();

    // TODO: Remove unwrap
    let listener = tokio::net::TcpListener::bind("0.0.0.0:8080").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
