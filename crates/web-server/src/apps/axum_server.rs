use crate::services::base::PackageProService;
use anyhow::Context;
use axum::Router;
use std::sync::Arc;
use tokio::net;

/// Configuration for the Axum server
#[derive(Debug, Clone)]
pub struct AxumServerConfig<'a> {
    pub port: &'a str,
}

/// State shared between all request handlers
#[derive(Debug, Clone)]
struct AppState<S: PackageProService> {
    service: Arc<S>,
}

pub struct AxumServer {
    router: Router,
    listener: net::TcpListener,
}

impl AxumServer {
    pub async fn new(
        service: impl PackageProService,
        config: AxumServerConfig<'_>,
    ) -> anyhow::Result<Self> {
        let app_state = AppState {
            service: Arc::new(service),
        };

        let router = Router::new().with_state(app_state);

        let listener = net::TcpListener::bind(format!("0.0.0.0:{}", config.port))
            .await
            .with_context(|| format!("failed to listen on {}", config.port))?;

        Ok(Self { router, listener })
    }

    pub async fn run(self) -> anyhow::Result<()> {
        axum::serve(self.listener, self.router)
            .await
            .context("received error from running server")?;

        Ok(())
    }
}
