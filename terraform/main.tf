terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

resource "yandex_compute_image" "ubuntu" {
  name = "ubuntu"
  source_family = "ubuntu-1804-lts"
}

