# PostgreSQL databases
resource "nebius_mdb_postgresql_database" "database" {
  for_each = length(var.databases) > 0 ? { for db in var.databases : db.name => db } : {}

  cluster_id          = nebius_mdb_postgresql_cluster.this.id
  name                = each.value.name
  owner               = nebius_mdb_postgresql_user.owner[each.value.owner].name
  lc_collate          = each.value.lc_collate
  lc_type             = each.value.lc_type
  deletion_protection = each.value.deletion_protection
  template_db         = each.value.template_db

  dynamic "extension" {
    for_each = each.value.extensions
    content {
      name = extension.value
    }
  }
}
