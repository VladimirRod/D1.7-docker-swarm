terraform {
  required_version = "1.5.7"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.94.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = "modules/service-admin.json"
  cloud_id                 = "<cloud_id>"
  folder_id                = "<folder_id>"
  zone                     = "ru-central1-a"
}

resource "yandex_vpc_network" "network_1" {
  name = "network_1"
}

resource "yandex_vpc_subnet" "subnet_1" {
  name           = "subnet_1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network_1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

module "manager" {
  source                = "./modules"
  name_node             = "manager"  
  vpc_subnet_id         = yandex_vpc_subnet.subnet_1.id
  vpc_ip_address        = "192.168.10.10"
}

module "worker-1" {
  source                = "./modules"
  name_node             = "worker-01"
  vpc_subnet_id         = yandex_vpc_subnet.subnet_1.id
  vpc_ip_address        = "192.168.10.11"
}

module "worker-2" {
  source                = "./modules"
  name_node             = "worker-02"
  vpc_subnet_id         = yandex_vpc_subnet.subnet_1.id
  vpc_ip_address        = "192.168.10.12"
}
