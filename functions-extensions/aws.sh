
function aws:switch-account(){
  echo "export AWS_PROFILE=${1}"
}

function cdk:bootstrap() {
  # https://docs.aws.amazon.com/cdk/latest/guide/getting_started.html#getting_started_bootstrap
  cdk bootstrap aws://${AWS_ACCOUNT}/${AWS_REGION}
}

function cdk:init-app() {
  # https://docs.aws.amazon.com/cdk/latest/guide/hello_world.html#hello_world_tutorial_create_app
  cdk init app --language typescript
}
