resource "nebius_vpc_subnet" "foo" {
  zone           = "eu-north1-c"
  network_id     = var.network_id
  v4_cidr_blocks = ["10.1.0.0/24"]
}

resource "nebius_vpc_subnet" "bar" {
  zone           = "eu-north1-c"
  network_id     = var.network_id
  v4_cidr_blocks = ["10.2.0.0/24"]
}
