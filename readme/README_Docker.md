# Docker
Use any of the following [docker](https://www.docker.com/) commands.

Build and power up all docker containers for this project.
```
docker-compose build && docker-compose up
```

Shutdown all running docker containers for this project.
```
docker-compose down
```

Restart all of your docker containers for this project (or a single service if required).
```
docker restart php nginx mysql redis
```

Show a list of all containers (running)
```
docker ps
```

Show a list of all running containers (stopped and running)
```
docker ps -a
```

Show the size of all running containers
```
docker ps -s
```

Show a list of the latest running containers
```
docker ps –l
```

Stop all of your docker containers for this project.
```
docker stop php nginx mysql redis
```

Stop all of your docker containers (globally).
```
docker stop $(docker ps –a –q)
```

Connect to a docker container (php, php_api, nginx, mysql, redis)
```
docker exec -it php bash

docker exec -it php_api bash

docker exec -it nginx sh

docker exec -it redis sh
```

List all containers (only IDs)
```
docker ps -aq
```

Stop all running containers
```
docker stop $(docker ps -aq)
```

Remove all containers
```
docker rm $(docker ps -aq)
```

Remove all images
```
docker rmi $(docker images -q) --force
```

[Back to previous](../README.md) 
