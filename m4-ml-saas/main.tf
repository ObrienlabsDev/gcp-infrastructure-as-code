// stub


// Create a secret containing the personal access token and grant permissions to the Service Agent
resource "google_secret_manager_secret" "github_token_secret" {
    project = var.project_id
    secret_id = var.secret_id

    replication {
        auto {}
    }
}
