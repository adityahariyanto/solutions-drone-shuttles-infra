resource "google_sql_database_instance" "mysql_db" {
  name = "my-db"
  database_version = "MYSQL_5_7"
  region = "europe-west6"

  settings {
    tier = "db-f1-micro"

    database_flags {
        name = "cloudsql.iam_authentication"
        value = "on"
    }
  }
}

resource "google_sql_user" "iam_user" {
    name = "aditya.hariyanto@nordcloud.com"
    instance = google_sql_database_instance.mysql_db.name
    type = "CLOUD_IAM_USER"
  
}

resource "google_project_iam_member" "iam_user_cloudsql_instance_user" {
  role = "roles/cloudsql.instanceUser"
  member = format("user:%s", google_sql_user.iam_user.name)
}

resource "google_project_iam_member" "iam_user_cloudsql_client" {
  role = "roles/cloudsql.client"
  member = format("user:%s", google_sql_user.iam_user.name)
}