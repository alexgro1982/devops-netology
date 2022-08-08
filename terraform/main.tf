terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
  
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "alexgro-netology"
    region     = "ru-central1-a"
    key        = "netology/terraform.tfstate"
    access_key = "YCAJETtvdJgCv203NmYKBurSv"
    secret_key = "YCNCsV9NUbgwF-XJlilDW0JmbHdYDTzmimpgErxP"

    skip_region_validation      = true
    skip_credentials_validation = true
  }

}

locals {
 web_instance_cpu_count = {
  stage = 1
  prod = 2
 }
 web_instance_memory_count = {
  stage = 1
  prod = 4
 }
 web_instance_count = {
  stage = 1
  prod = 2
 }
 web_instance_for = {
 stage = {"host1" = 1}
 prod = {"host1" = 2, "host2" = 2}
 }
}

resource "yandex_compute_image" "ubuntu" {
  name = "ubuntu"
  source_family = "ubuntu-1804-lts"
}

resource "yandex_compute_instance" "web" {
  name        = "test-${count.index}"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  count       = local.web_instance_count[terraform.workspace]

  resources {
    cores  = local.web_instance_cpu_count[terraform.workspace]
    memory = local.web_instance_memory_count[terraform.workspace]
  }

  boot_disk {
    initialize_params {
      image_id = "ubuntu"
    }
  }
  network_interface {
    subnet_id = "${yandex_vpc_network.default.id}"
  }
}

resource "yandex_compute_instance" "web_for" {
  for_each = local.web_instance_for[terraform.workspace]
  name        = each.key
  platform_id = "standard-v1"
  zone        = "ru-central1-a"


  resources {
    cores  = each.value
    memory = each.value
  }

  boot_disk {
    initialize_params {
      image_id = "ubuntu"
    }
  }
  network_interface {
    subnet_id = "${yandex_vpc_network.default.id}"
  }
}