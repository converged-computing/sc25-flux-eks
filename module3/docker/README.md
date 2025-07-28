# Docker Images

These images were originally derived from the state machine operator work. These should be done on the arm builder.

## MLRunner

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 633731392008.dkr.ecr.us-east-1.amazonaws.com
docker pull 633731392008.dkr.ecr.us-east-1.amazonaws.com/mini-mummi:mlrunner-arm

docker build -f ./mlrunner/Dockerfile -t ghcr.io/converged-computing/sc25-flux-eks:mlrunner-arm ./mlrunner
docker push ghcr.io/converged-computing/sc25-flux-eks:mlrunner-arm
```
