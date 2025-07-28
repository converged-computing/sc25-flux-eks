# Docker Images

These images were originally derived from the state machine operator work. These should be done on the arm builder.

## MLRunner

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 633731392008.dkr.ecr.us-east-1.amazonaws.com
docker pull 633731392008.dkr.ecr.us-east-1.amazonaws.com/mini-mummi:mlrunner-arm

docker build -f ./mlrunner/Dockerfile -t ghcr.io/converged-computing/sc25-flux-eks:mlrunner-arm ./mlrunner
docker push ghcr.io/converged-computing/sc25-flux-eks:mlrunner-arm
```

## Createsims

Initial Dockerfile [is here](https://github.com/converged-computing/mummi-experiments/blob/main/experiments/aws-march-2025/cpu-node-selector/Dockerfile.arm).
It has a sample built into it from mlrunner. Let's retagged for this repository.

```bash
docker build -f ./mlrunner/Dockerfile -t ghcr.io/converged-computing/sc25-flux-eks:createsims-arm ./createsims
docker push ghcr.io/converged-computing/sc25-flux-eks:createsims-arm
```
