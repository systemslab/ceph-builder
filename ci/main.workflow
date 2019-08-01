workflow "build image" {
  resolves = "push"
}

action "build" {
  uses = "actions/docker/cli@master"
  args = [
    "build",
    "--build-arg", "UBUNTU_VERSION=$UBUNTU_VERSION",
    "--build-arg", "GIT_URL=$GIT_URL",
    "--build-arg", "GIT_REF=$GIT_REF",
    "--tag", "$IMG_NAME",
    "."
  ]
  secrets = ["UBUNTU_VERSION", "GIT_URL", "GIT_REF", "IMG_NAME"]
}

action "login" {
  needs = "build"
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "push" {
  needs = "login"
  uses = "actions/docker/cli@master"
  args = "push $IMG_NAME"
  secrets = ["IMG_NAME"]
}
