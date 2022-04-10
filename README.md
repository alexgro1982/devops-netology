### Курсовая работа
1. Установка и настройка ufw
```shell
root@vagrant:~# ufw status
Status: inactive
root@vagrant:~# ufw default deny incoming
Default incoming policy changed to 'deny'
(be sure to update your rules accordingly)
root@vagrant:~# ufw default allow outgoing
Default outgoing policy changed to 'allow'
(be sure to update your rules accordingly)
root@vagrant:~# ufw allow 22/tcp
Rules updated
Rules updated (v6)
root@vagrant:~# ufw allow 443/tcp
Rules updated
Rules updated (v6)
root@vagrant:~# ufw allow in on lo
Rule added
Rule added (v6)
root@vagrant:~# ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
root@vagrant:~# ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere                  
443/tcp                    ALLOW IN    Anywhere                  
Anywhere on lo             ALLOW IN    Anywhere                  
22/tcp (v6)                ALLOW IN    Anywhere (v6)             
443/tcp (v6)               ALLOW IN    Anywhere (v6)             
Anywhere (v6) on lo        ALLOW IN    Anywhere (v6)             

root@vagrant:~# 
```
2. Установка Vault
```shell
root@vagrant:~# proxychains curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
|DNS-request| apt.releases.hashicorp.com 
|S-chain|-<>-127.0.0.1:9050-<><>-4.2.2.2:53-<><>-OK
|DNS-response| apt.releases.hashicorp.com is 151.101.14.49
|S-chain|-<>-127.0.0.1:9050-<><>-151.101.14.49:443-<><>-OK
OK
root@vagrant:~# proxychains apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
ProxyChains-3.1 (http://proxychains.sf.net)
0% [Working]|DNS-request| banjo.canonical.com 
|DNS-request| apt.releases.hashicorp.com 
|S-chain|-<>-127.0.0.1:9050-|S-chain|-<>-127.0.0.1:9050-<><>-4.2.2.2:53-<><>-4.2.2.2:53-<><>-OK
<><>-OK
0% [Connecting to banjo.canonical.com] [Connecting to apt.releases.hashicorp.com]|DNS-response| banjo.canonical.com is 91.189.91.38
|S-chain|-<>-127.0.0.1:9050-<><>-91.189.91.38:80-<><>-OK
Hit:1 http://us.archive.ubuntu.com/ubuntu focal InRelease                        
Hit:2 http://us.archive.ubuntu.com/ubuntu focal-updates InRelease  
Hit:3 http://us.archive.ubuntu.com/ubuntu focal-backports InRelease
Hit:4 http://us.archive.ubuntu.com/ubuntu focal-security InRelease 
0% [Connecting to apt.releases.hashicorp.com]|DNS-response| apt.releases.hashicorp.com is 151.101.114.49
0% [Connecting to apt.releases.hashicorp.com (151.101.114.49)]<><>-OK
Get:5 https://apt.releases.hashicorp.com focal InRelease [16.3 kB]
Get:6 https://apt.releases.hashicorp.com focal/main amd64 Packages [51.1 kB]                                 
Fetched 67.4 kB in 7s (9,736 B/s)                                                                            
Reading package lists... Done
root@vagrant:~# proxychains apt-get install vault
ProxyChains-3.1 (http://proxychains.sf.net)
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following NEW packages will be installed:
  vault
0 upgraded, 1 newly installed, 0 to remove and 89 not upgraded.
Need to get 70.4 MB of archives.
After this operation, 191 MB of additional disk space will be used.
0% [Working]|DNS-request| apt.releases.hashicorp.com 
|S-chain|-<>-127.0.0.1:9050-<><>-4.2.2.2:53-<><>-OK
0% [Connecting to apt.releases.hashicorp.com]<><>-OKn|-<>-127.0.0.1:9050-<><>-4.2.2.2:53-
|DNS-response| apt.releases.hashicorp.com is 151.101.114.49
0% [Connecting to apt.releases.hashicorp.com (151.101.114.49)]<><>-OK
Get:1 https://apt.releases.hashicorp.com focal/main amd64 vault amd64 1.10.0 [70.4 MB]
Fetched 70.4 MB in 1min 10s (1,003 kB/s)                                                                     
Selecting previously unselected package vault.
(Reading database ... 40746 files and directories currently installed.)
Preparing to unpack .../vault_1.10.0_amd64.deb ...
Unpacking vault (1.10.0) ...
Setting up vault (1.10.0) ...
Generating Vault TLS key and self-signed certificate...
Generating a RSA private key
.........................................................................................................................++++
..................................................................................................................................................................................................................++++
writing new private key to 'tls.key'
-----
Vault TLS key and self-signed certificate have been generated in '/opt/vault/tls'.
root@vagrant:~# 
```
3. Выпуск сертификата
```shell
root@vagrant:~# vault secrets enable pki
Success! Enabled the pki secrets engine at: pki/
root@vagrant:~# vault secrets tune -max-lease-ttl=87600h pki
Success! Tuned the secrets engine at: pki/
root@vagrant:~# vault write -field=certificate pki/root/generate/internal common_name="mysite.ru" ttl=87600h > CA_cert.crt
root@vagrant:~# vault write pki/config/urls issuing_certificates="$VAULT_ADDR/v1/pki/ca" crl_distribution_points="$VAULT_ADDR/v1/pki/crl"
Success! Data written to: pki/config/urls
root@vagrant:~# vault secrets enable -path=pki_int pki
Success! Enabled the pki secrets engine at: pki_int/
root@vagrant:~# vault secrets tune -max-lease-ttl=43800h pki_int
Success! Tuned the secrets engine at: pki_int/
root@vagrant:~# vault write -format=json pki_int/intermediate/generate/internal common_name="mysite.ru Intermediate Authority" | jq -r '.data.csr' > pki_intermediate.csr
root@vagrant:~# vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr format=pem_bundle ttl="43800h" | jq -r '.data.certificate' > intermediate.cert.pem
root@vagrant:~# vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem
Success! Data written to: pki_int/intermediate/set-signed
root@vagrant:~# vault write pki_int/roles/mysite-dot-ru allowed_domains="mysite.ru" allow_subdomains=true max_ttl="8765h"
Success! Data written to: pki_int/roles/mysite-dot-ru
root@vagrant:~# vault write pki_int/issue/mysite-dot-ru common_name="test.mysite.ru" ttl="730h"
Key                 Value
---                 -----
ca_chain            [-----BEGIN CERTIFICATE-----
MIIDojCCAoqgAwIBAgIUc/XuV7D95kpPUxL3D8Ox+rCNqNswDQYJKoZIhvcNAQEL
BQAwFDESMBAGA1UEAxMJbXlzaXRlLnJ1MB4XDTIyMDQwOTE5NDI1NloXDTI3MDQw
ODE5NDMyNlowKzEpMCcGA1UEAxMgbXlzaXRlLnJ1IEludGVybWVkaWF0ZSBBdXRo
b3JpdHkwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDU24xkc5UCsU22
2z6A9TGgyFCwXOiUSgjmofPDPHisuKYIxx4U5c7muve5khq7ivTFnQZlRu0xKyIJ
VaaARVH8nOIkxWKHmErgJUjlmGT5U8ciq+9TpQmz39/eSSWwFJ9p3nz05HLgM3xf
MIL5frolVNUxJyqCKzAJvSJxFeC0VxGLHgxQMcfh9WzC+LS4r9wFPfKstcY39pXx
UhmSYKd8ZTE9H2ZNIOms+MtMwz4T93nx9zicTzlGCkxTN/9jvK05pv7LL0xu9sah
+kJto09wJ+7IWWBBIyAIvoGfYNqUFnxGcQg2laOUCO8WxWmZIffNsBavVfegy1OH
LTNdQw/pAgMBAAGjgdQwgdEwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMB
Af8wHQYDVR0OBBYEFAPWcH+DZ7EjEtlcPxlJCcapALgsMB8GA1UdIwQYMBaAFOMT
7x3V6FeTVYK3dwOm3bVGssDYMDsGCCsGAQUFBwEBBC8wLTArBggrBgEFBQcwAoYf
aHR0cDovLzEyNy4wLjAuMTo4MjAwL3YxL3BraS9jYTAxBgNVHR8EKjAoMCagJKAi
hiBodHRwOi8vMTI3LjAuMC4xOjgyMDAvdjEvcGtpL2NybDANBgkqhkiG9w0BAQsF
AAOCAQEABRXtfp8EWXGs4cO2TAmqgycmIvnJjcOk00GN/Fw7gOD8I9EFWe/KiZB/
d61XIrb49fSfYWQYzigAsuN3eIJq/C/cnFRZns1yh3PbIoHBUfBb1odiScdRiqWV
FL0LgODl2VL3/baSPJTqltH49JsQNusCWSn2o5bDNVXKhjCMM5hE8IimbfXcA+B3
HYyBrXwIAhjpEjNlwUKDGfI3NVVaIoU0NbVUwqZ3ZWhN/MsQQSChJY1txKpXSKSO
yuH+2UBvjKyPmweMwhKSLbHmkX8ww7ewxwm6IDdhyhpNf3t+X9Z9bqYGD6R7foiS
50pxdBzw9l6V4L09g4gXhdbjtMu2ZA==
-----END CERTIFICATE-----]
certificate         -----BEGIN CERTIFICATE-----
MIIDYDCCAkigAwIBAgIUaZrbPfhjnhJvtF7nMddfEHlrdQkwDQYJKoZIhvcNAQEL
BQAwKzEpMCcGA1UEAxMgbXlzaXRlLnJ1IEludGVybWVkaWF0ZSBBdXRob3JpdHkw
HhcNMjIwNDA5MTk1MDIxWhcNMjIwNTEwMDU1MDUxWjAZMRcwFQYDVQQDEw50ZXN0
Lm15c2l0ZS5ydTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALC1Nq0t
HO/SAQtRjGT0kHeuusbZ16ANuuJV1W5w9lEk7mMR/dTSVYflXS8lVOvWOAalfKJR
H1LGv5MnLxvFg1YqgiVhGJ5CYskdWYrxuPU3y70yKIeswuKMg9pqv69+UoGNQK7t
SKj4S2td/5Aq6kd88IQYCseokiqHW/VW0UvryyiqTh6P1RydEh+H/lvihnFNUbfS
9md+LZ4PL1YEaocH80j9VA4ZhsAvTMfMPXcUIJKxR3DdPFalobgUvNrePprxwmji
okKsQWl9r2TqfhgTwHaT68XV4QAvYWR984Kt5TOORA5JBRZCNV9pQDRVeosD6ubb
t0FU/fr7NfaTE3MCAwEAAaOBjTCBijAOBgNVHQ8BAf8EBAMCA6gwHQYDVR0lBBYw
FAYIKwYBBQUHAwEGCCsGAQUFBwMCMB0GA1UdDgQWBBTAlFIXOuK0zDQ2OXaFmzwo
FcfmeTAfBgNVHSMEGDAWgBQD1nB/g2exIxLZXD8ZSQnGqQC4LDAZBgNVHREEEjAQ
gg50ZXN0Lm15c2l0ZS5ydTANBgkqhkiG9w0BAQsFAAOCAQEANEwitE6gKuUq01lR
gaqihy1vdymQY26rhXcBM7F7Esp026GYMONmBjPiHKURXu9AessxaB2eERt4ixHP
JqdLaitQWAgqP8y+h+FbZmlsud3UVw0oWkxmQp4GNkqf3GgVf5i8GY3A7+vu/pkz
52lVf1EJIz2wUSPnVp6JGeTEEzoS+9ayiQ23wQCNV1lW2ZNfoxVaYENudm/extFY
l/W8737jz+3BUSRZCZpiBKtyE2scvD25yy9P63fA8dbCFj9RQfUq9m9noWLgkfzQ
NoPlNrz0vYpomskZQK8bPytBmhkHJy38IikD/azfIxl4vSg02V0HYZSE5RGIpV/c
uLAClQ==
-----END CERTIFICATE-----
expiration          1652161851
issuing_ca          -----BEGIN CERTIFICATE-----
MIIDojCCAoqgAwIBAgIUc/XuV7D95kpPUxL3D8Ox+rCNqNswDQYJKoZIhvcNAQEL
BQAwFDESMBAGA1UEAxMJbXlzaXRlLnJ1MB4XDTIyMDQwOTE5NDI1NloXDTI3MDQw
ODE5NDMyNlowKzEpMCcGA1UEAxMgbXlzaXRlLnJ1IEludGVybWVkaWF0ZSBBdXRo
b3JpdHkwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDU24xkc5UCsU22
2z6A9TGgyFCwXOiUSgjmofPDPHisuKYIxx4U5c7muve5khq7ivTFnQZlRu0xKyIJ
VaaARVH8nOIkxWKHmErgJUjlmGT5U8ciq+9TpQmz39/eSSWwFJ9p3nz05HLgM3xf
MIL5frolVNUxJyqCKzAJvSJxFeC0VxGLHgxQMcfh9WzC+LS4r9wFPfKstcY39pXx
UhmSYKd8ZTE9H2ZNIOms+MtMwz4T93nx9zicTzlGCkxTN/9jvK05pv7LL0xu9sah
+kJto09wJ+7IWWBBIyAIvoGfYNqUFnxGcQg2laOUCO8WxWmZIffNsBavVfegy1OH
LTNdQw/pAgMBAAGjgdQwgdEwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMB
Af8wHQYDVR0OBBYEFAPWcH+DZ7EjEtlcPxlJCcapALgsMB8GA1UdIwQYMBaAFOMT
7x3V6FeTVYK3dwOm3bVGssDYMDsGCCsGAQUFBwEBBC8wLTArBggrBgEFBQcwAoYf
aHR0cDovLzEyNy4wLjAuMTo4MjAwL3YxL3BraS9jYTAxBgNVHR8EKjAoMCagJKAi
hiBodHRwOi8vMTI3LjAuMC4xOjgyMDAvdjEvcGtpL2NybDANBgkqhkiG9w0BAQsF
AAOCAQEABRXtfp8EWXGs4cO2TAmqgycmIvnJjcOk00GN/Fw7gOD8I9EFWe/KiZB/
d61XIrb49fSfYWQYzigAsuN3eIJq/C/cnFRZns1yh3PbIoHBUfBb1odiScdRiqWV
FL0LgODl2VL3/baSPJTqltH49JsQNusCWSn2o5bDNVXKhjCMM5hE8IimbfXcA+B3
HYyBrXwIAhjpEjNlwUKDGfI3NVVaIoU0NbVUwqZ3ZWhN/MsQQSChJY1txKpXSKSO
yuH+2UBvjKyPmweMwhKSLbHmkX8ww7ewxwm6IDdhyhpNf3t+X9Z9bqYGD6R7foiS
50pxdBzw9l6V4L09g4gXhdbjtMu2ZA==
-----END CERTIFICATE-----
private_key         -----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAsLU2rS0c79IBC1GMZPSQd666xtnXoA264lXVbnD2USTuYxH9
1NJVh+VdLyVU69Y4BqV8olEfUsa/kycvG8WDViqCJWEYnkJiyR1ZivG49TfLvTIo
h6zC4oyD2mq/r35SgY1Aru1IqPhLa13/kCrqR3zwhBgKx6iSKodb9VbRS+vLKKpO
Ho/VHJ0SH4f+W+KGcU1Rt9L2Z34tng8vVgRqhwfzSP1UDhmGwC9Mx8w9dxQgkrFH
cN08VqWhuBS82t4+mvHCaOKiQqxBaX2vZOp+GBPAdpPrxdXhAC9hZH3zgq3lM45E
DkkFFkI1X2lANFV6iwPq5tu3QVT9+vs19pMTcwIDAQABAoIBAQCta8sTPhkOC+3W
a9v7IEHAE41epmCFxbPJeS+Tye0TScljFT8l5J7oVeOT53FmWsB1VWfx7Odu13sg
Me57tOXmZKWBhb8hYkmM0u8T+5LnpjCfp2A7dwN0Ty7/5o/k7XaPik8W3ezXV4a9
Am1T0apHKojpOqcpt3hroJhROTkC5e7rtZZaxoBAuCcXs3mFHbifdYrDdg99KbvP
5ciXF++s/gJlcm8cvkJSdKyHLNcXqcR6nJ7ZD+xe0akQfgGJfSg/UuJKysoDeVD+
A7+Bc933j1hiSw9MxMQx4EXe5V7mnmBQCNyCClHebNUJRE9hk9jWwj4Wx+69PLsk
V3pJX8zRAoGBANWGZoF37B3xIIx1lTpJ2XsNtOMLEBN5zexjCE0cFyvUUnwQxTCb
MKSK56VqLAAvvaRiaEwC6eyLOlRIG9bw0fcSfBrfiZQwAS5Kl4mCX8BtIdz/fczt
657L1hxN6TBTm34sCe6PQq1C7DWgNzeQSCts/ZreAfJDDu8S+P28l1c3AoGBANPb
7aSsEKyLt/iza0IhNgGRsZgrLYdcz7wHptrZ9iI4SVFIQ6WlLrNReMopVAyCzpFg
uFO6YCg6bW2rK3qJrRDJggK1c9CV2+0UlE785sgpcnMxRoeSXUiBsMey1O6yGozd
HWtN4bOVJ3LOh6VRm9TLbkPFezecbxW5X7h1O4ulAoGAPmVC6QxxLCK9Py5RCDJy
YfoUZNBjxz0txqj90QKnZsBpxiVkahq/cSXCIV1QNFG/Gh1Dmwqy7tOUnPJhaEMB
KDD3oSa3Xl1UywEzHRTDBEkfvyPN0CeqVcH89FJ0FRIpewpFcLfeZSEMQ3NpD0yT
OlVkGnBLo06jO4uQxRzqIKsCgYBe5RTV/MhfMRoPiPYTIeMZ4tOEkFqNVjIqS9ce
EiEghMu6X78FNC7t3SFYlBh0nia+kW8e+c1WV41qYRBRi9d8PHZCllow5N8km2Iu
2zLYF1CPblPkJ9gmwQiY+m5MGHSyAdzKkpD1KmsIDqBNmXdOYmyaaJtfdm9/cJAC
hGhOjQKBgD40pXt5eX//+3YOQRZacIhJJ0ieUEAQWafY20IszkLkgmocxp8CX9AQ
HcogMZsgxtKaeqtBAbkQNFwVj5O7A6mTeMJ33j+eCgHek7NFC3Bm3qR0+aTltAzu
OHMC/7hlgJyW40E1kuHepeM+QzgN+bnxpekjZ4yy0wXSB0ireEUD
-----END RSA PRIVATE KEY-----
private_key_type    rsa
serial_number       69:9a:db:3d:f8:63:9e:12:6f:b4:5e:e7:31:d7:5f:10:79:6b:75:09
root@vagrant:~# 
```
4. Установка и настройка Nginx

Копируем сертифика и закрытый ключ для сайта test.mysite.ru в файлы: /etc/ssl/nginx/cert/test_mysite_ru.crt и /etc/ssl/nginx/key/test_mysite_ru.key

```shell
root@vagrant:~# apt-get install nginx
root@vagrant:~# vi /etc/nginx/sites-available/test_mysite_ru.conf
root@vagrant:~# cat /etc/nginx/sites-available/test_mysite_ru.conf 
server {
    listen              443 ssl;
    server_name         test.mysite.ru;
    ssl_certificate     /etc/ssl/nginx/cert/test_mysite_ru.crt;
    ssl_certificate_key /etc/ssl/nginx/key/test_mysite_ru.key;
    ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers         HIGH:!aNULL:!MD5;
    root /var/www/test.mysite.ru/;
    index index.html index.htm;
}
root@vagrant:~# ln -s /etc/nginx/sites-available/test_mysite_ru.conf /etc/nginx/sites-enabled/test_mysite_ru.conf
```
![img_5.png](img/img_5.png)

5. Скрипт перевыпуска сертификата
```python
#!/usr/bin/env python3

import json
import requests
import os


VAULT_TOKEN = {"X-Vault-Token": "hvs.LpjjjJ2YAp8Y6DK2MCYIM1NT"}
VAULT_ADDR = "http://127.0.0.1:8200"
DATA_REQ = {"common_name": "test.mysite.ru", "ttl": "730h"}

r = requests.post(f"{VAULT_ADDR}/v1/pki_int/issue/mysite-dot-ru", data=DATA_REQ, headers=VAULT_TOKEN)
resp = r.json()
if resp.get("errors"):
    print(f"Запрос сертификата выполнен с ошибкой: {resp}")
    exit(1)
else:
    cert = resp.get("data").get("certificate")
    key = resp.get("data").get("private_key")
    f = open("/etc/ssl/nginx/cert/test_mysite_ru.crt", "w")
    f.write(cert)
    f.close()
    f = open("/etc/ssl/nginx/key/test_mysite_ru.key", "w")
    f.write(key)
    f.close()
    print ("Сертификат выпущен")
    bash_command = "nginx -s reload"
    os.popen(bash_command)
     
```
6. Вывод crontab -e
```shell
0 0 1 * *       /root/renew_cert.py
```
