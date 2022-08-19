!# /bin/bash
cd docker_infr && sudo docker-compose build && docker-compose up -d && cd ..
cd playbook && ansible-playbook -i ./inventory/prod.yml site.yml && cd ..
cd docker_infr && sudo docker-compose stop && cd ..
