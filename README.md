# Base Alpine Docker image for CI

Alpine based image including AWS CLI and Docker. It installs:

- Docker to allow image building and pushing.
- AWS CLI to interact with AWS.
- JQ to read JSON from command line.
- Terraform to manage infrastructure.

Pay attention to create and set a CI user able to manage all the operations done inside the CI (access to the correct AWS resources).

New releases can be published by creating a new tag using this format: i.e. `1.0.0`.
New builds are automatically created on [Docker Hub](https://hub.docker.com/r/sncegroup/alpine-aws-docker).

## To build a new version

Launch the `publish.sh {NEW_VERSION}` script. Or manually do the below actions. You can target a stage `terraform` to include the terraform binary or `base` to skip it and lower the final image size.

```bash
BASE=sncegroup/alpine-aws-docker
VERSION=1.x

docker build . -t ${BASE}:{VERSION} --target {base|terraform}
docker tag ${BASE}:{VERSION} ${BASE}:latest
docker push ${BASE}:{VERSION}
docker push ${BASE}:latest
```