resource "google_sql_database_instance" "mysql_db" {
  name             = "my-db3"
  database_version = "MYSQL_5_7"
  region           = "europe-west6"

  settings {
    tier = "db-f1-micro"
  }
}

# resource "google_sql_database" "database" {
#   name     = "ghost"
#   instance = google_sql_database_instance.mysql_db.name
# }
