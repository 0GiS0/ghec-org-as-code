use axum::{
    extract::{Path, State},
    http::StatusCode,
    response::Json,
    routing::{delete, get, post, put},
    Router,
};
use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::{FromRow, SqlitePool};
use std::sync::Arc;
use tower_http::cors::CorsLayer;
use tracing::{info, instrument};
use uuid::Uuid;

#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct Trip {
    pub id: String,
    pub name: String,
    pub description: Option<String>,
    pub location: String,
    pub price: f64,
    pub duration: i32, // in hours
    pub max_guests: i32,
    pub available: bool,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Deserialize)]
pub struct CreateTrip {
    pub name: String,
    pub description: Option<String>,
    pub location: String,
    pub price: f64,
    pub duration: i32,
    pub max_guests: i32,
    pub available: Option<bool>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateTrip {
    pub name: Option<String>,
    pub description: Option<String>,
    pub location: Option<String>,
    pub price: Option<f64>,
    pub duration: Option<i32>,
    pub max_guests: Option<i32>,
    pub available: Option<bool>,
}

type AppState = Arc<SqlitePool>;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    // Initialize tracing
    tracing_subscriber::fmt::init();

    // Load environment variables
    dotenv::dotenv().ok();

    // Database setup
    let database_url = std::env::var("DATABASE_URL")
        .unwrap_or_else(|_| "sqlite:///workspace/db/$${parameters.name}.db".to_string());
    
    // Ensure the database directory exists
    if let Some(parent) = std::path::Path::new(&database_url.trim_start_matches("sqlite://")).parent() {
        std::fs::create_dir_all(parent)?;
    }

    let pool = SqlitePool::connect(&database_url).await?;
    sqlx::migrate!("./migrations").run(&pool).await?;

    let app_state = Arc::new(pool);

    // Build our application with routes
    let app = Router::new()
        .route("/health", get(health_check))
        .route("/api/v1/trips", get(get_trips).post(create_trip))
        .route("/api/v1/trips/:id", get(get_trip).put(update_trip).delete(delete_trip))
        .layer(CorsLayer::permissive())
        .with_state(app_state);

    // Run the server
    let port = std::env::var("PORT").unwrap_or_else(|_| "8080".to_string());
    let addr = format!("0.0.0.0:{}", port);
    
    info!("Starting server on {}", addr);
    let listener = tokio::net::TcpListener::bind(&addr).await?;
    axum::serve(listener, app).await?;

    Ok(())
}

#[instrument]
async fn health_check() -> Json<serde_json::Value> {
    Json(serde_json::json!({
        "status": "healthy",
        "timestamp": Utc::now().to_rfc3339(),
        "service": "$${parameters.name}"
    }))
}

#[instrument(skip(state))]
async fn get_trips(State(state): State<AppState>) -> Result<Json<Vec<Trip>>, StatusCode> {
    let trips = sqlx::query_as::<_, Trip>("SELECT * FROM trips ORDER BY created_at DESC")
        .fetch_all(&*state)
        .await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    Ok(Json(trips))
}

#[instrument(skip(state))]
async fn create_trip(
    State(state): State<AppState>,
    Json(payload): Json<CreateTrip>,
) -> Result<Json<Trip>, StatusCode> {
    let trip_id = Uuid::new_v4().to_string();
    let now = Utc::now();

    let trip = sqlx::query_as::<_, Trip>(
        r#"
        INSERT INTO trips (id, name, description, location, price, duration, max_guests, available, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        RETURNING *
        "#,
    )
    .bind(&trip_id)
    .bind(&payload.name)
    .bind(&payload.description)
    .bind(&payload.location)
    .bind(payload.price)
    .bind(payload.duration)
    .bind(payload.max_guests)
    .bind(payload.available.unwrap_or(true))
    .bind(now)
    .bind(now)
    .fetch_one(&*state)
    .await
    .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    Ok(Json(trip))
}

#[instrument(skip(state))]
async fn get_trip(
    State(state): State<AppState>,
    Path(id): Path<String>,
) -> Result<Json<Trip>, StatusCode> {
    let trip = sqlx::query_as::<_, Trip>("SELECT * FROM trips WHERE id = ?")
        .bind(&id)
        .fetch_one(&*state)
        .await
        .map_err(|err| match err {
            sqlx::Error::RowNotFound => StatusCode::NOT_FOUND,
            _ => StatusCode::INTERNAL_SERVER_ERROR,
        })?;

    Ok(Json(trip))
}

#[instrument(skip(state))]
async fn update_trip(
    State(state): State<AppState>,
    Path(id): Path<String>,
    Json(payload): Json<UpdateTrip>,
) -> Result<Json<Trip>, StatusCode> {
    let now = Utc::now();

    let trip = sqlx::query_as::<_, Trip>(
        r#"
        UPDATE trips 
        SET name = COALESCE(?, name),
            description = COALESCE(?, description),
            location = COALESCE(?, location),
            price = COALESCE(?, price),
            duration = COALESCE(?, duration),
            max_guests = COALESCE(?, max_guests),
            available = COALESCE(?, available),
            updated_at = ?
        WHERE id = ?
        RETURNING *
        "#,
    )
    .bind(&payload.name)
    .bind(&payload.description)
    .bind(&payload.location)
    .bind(payload.price)
    .bind(payload.duration)
    .bind(payload.max_guests)
    .bind(payload.available)
    .bind(now)
    .bind(&id)
    .fetch_one(&*state)
    .await
    .map_err(|err| match err {
        sqlx::Error::RowNotFound => StatusCode::NOT_FOUND,
        _ => StatusCode::INTERNAL_SERVER_ERROR,
    })?;

    Ok(Json(trip))
}

#[instrument(skip(state))]
async fn delete_trip(
    State(state): State<AppState>,
    Path(id): Path<String>,
) -> Result<StatusCode, StatusCode> {
    let result = sqlx::query("DELETE FROM trips WHERE id = ?")
        .bind(&id)
        .execute(&*state)
        .await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    if result.rows_affected() == 0 {
        return Err(StatusCode::NOT_FOUND);
    }

    Ok(StatusCode::NO_CONTENT)
}