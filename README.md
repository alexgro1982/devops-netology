# Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Terraform."

## Задача 1

С Yandex.Cloud знакомились на предыдущих домашках.
Для аторизации я облаке прописал переменную   YC_SERVICE_ACCOUNT_KEY_FILE=/home/alexgro/key.json

## Задача 2

1. Для сборки своего образа ami используется инструмент Packer.
2. https://github.com/alexgro1982/devops-netology.git

```shell
alexgro@alex-book:~/Документы/netology/devops-netology/terraform$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_image.ubuntu will be created
  + resource "yandex_compute_image" "ubuntu" {
      + created_at      = (known after apply)
      + folder_id       = (known after apply)
      + id              = (known after apply)
      + min_disk_size   = (known after apply)
      + name            = "ubuntu"
      + os_type         = (known after apply)
      + pooled          = (known after apply)
      + product_ids     = (known after apply)
      + size            = (known after apply)
      + source_disk     = (known after apply)
      + source_family   = "ubuntu-1804-lts"
      + source_image    = (known after apply)
      + source_snapshot = (known after apply)
      + source_url      = (known after apply)
      + status          = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_compute_image.ubuntu: Creating...
yandex_compute_image.ubuntu: Creation complete after 7s [id=fd8fc9vg67agfh9q5qbu]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```


