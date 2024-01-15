# main.tf

module "db" {
  source = "../../"

  network_id  = var.network_id
  name        = "one-two-tree"
  description = "Multi-node PostgreSQL cluster for test purposes"

  maintenance_window = {
    type = "WEEKLY"
    day  = "SUN"
    hour = "02"
  }

  access_policy = {
    web_sql = true
  }

  performance_diagnostics = {
    enabled = true
  }

  hosts_definition = [
    {
      name             = "one"
      priority         = 0
      zone             = "eu-north1-c"
      assign_public_ip = true
      subnet_id        = nebius_vpc_subnet.foo.id
    },
    {
      name             = "two"
      priority         = 10
      zone             = "eu-north1-c"
      assign_public_ip = true
      subnet_id        = nebius_vpc_subnet.bar.id
    },
    {
      name                    = "suntree"
      zone                    = "eu-north1-c"
      assign_public_ip        = true
      subnet_id               = nebius_vpc_subnet.bar.id
      replication_source_name = "two"
    }
  ]

  postgresql_config = {
    max_connections                = 395
    enable_parallel_hash           = true
    autovacuum_vacuum_scale_factor = 0.34
    default_transaction_isolation  = "TRANSACTION_ISOLATION_READ_COMMITTED"
    shared_preload_libraries       = "SHARED_PRELOAD_LIBRARIES_AUTO_EXPLAIN,SHARED_PRELOAD_LIBRARIES_PG_HINT_PLAN"
  }

  default_user_settings = {
    default_transaction_isolation = "read committed"
    log_min_duration_statement    = 5000
  }

  databases = [
    {
      name       = "test1"
      owner      = "test1"
      lc_collate = "en_US.UTF-8"
      lc_type    = "en_US.UTF-8"
      extensions = ["uuid-ossp", "xml2"]
    }
  ]

  owners = [
    {
      name       = "test1"
      conn_limit = 15
    }
  ]

  users = [
    {
      name        = "test1-guest"
      conn_limit  = 30
      permissions = ["test1"]
      settings = {
        pool_mode                   = "transaction"
        prepared_statements_pooling = true
      }
    }
  ]
}
