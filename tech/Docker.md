### Docker Stuff

## General

format json logs: `docker image inspect hello-world | jq '.[].Config.Env'`
build images: `docker build -t <image-name> --file <path-to-Dockerfile> ./`
