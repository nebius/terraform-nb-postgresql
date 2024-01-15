resource "local_file" "pgpass_file" {
  count           = var.pgpass_path == null ? 0 : 1
  content         = <<-EOT
%{for db in nebius_mdb_postgresql_database.database~}
c-${nebius_mdb_postgresql_cluster.this.id}.rw.mdb.nebiuscloud.net:6432:${db.name}:${db.owner}:${nebius_mdb_postgresql_user.owner[db.owner].password}
%{endfor~}
  EOT
  filename        = pathexpand(var.pgpass_path)
  file_permission = "0600"
}
