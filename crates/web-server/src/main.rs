use db::create_pool;
use db::queries::organizations::get_organization_by_id;
use uuid::uuid;

#[tokio::main]
async fn main() {
    let db_url = std::env::var("DATABASE_URL").unwrap();
    let pool = create_pool(&db_url);

    let client = pool.get().await.unwrap();
    let organization = get_organization_by_id()
        .bind(&client, &uuid!("00000000-0000-0000-0000-000000000000"))
        .opt()
        .await
        .unwrap();

    dbg!(organization);
}
