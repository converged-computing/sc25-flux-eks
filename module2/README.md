# Module 2: Advanced Workload Management with Flux Framework

## Setup

Create the eksctl cluster. Note that this takes about 20 minutes.

```bash
eksctl create cluster --config-file ./eks-config.yaml
aws eks update-kubeconfig --region us-east-1 --name lammps-cluster
```

When the cluster is created, install the Flux Operator. Note that this is an ARM build since we are running on an AWS Graviton (ARM) processor.

```bash
kubectl apply -f https://raw.githubusercontent.com/flux-framework/flux-operator/refs/heads/main/examples/dist/flux-operator-arm.yaml
```

It is easier to have auto-completion for kubectl.

```bash
source <(kubectl completion bash)
```

## Run LAMMPS

We will run lammps in three ways: 🍳

1. With a manual MiniCluster custom resource definition as a Job
2. With a manual MiniCluster custom resource definition via an interactive cluster
3. Using the helm package manager (called a helm chart)

### MiniCluster as a Job

A Flux Framework MiniCluster is akin to running an entire Flux Cluster across some number of physical nodes in 
Kubernetes. We create it with a custom resource definition or CRD.

```bash
kubectl apply -f minicluster.yaml
```

You can watch the progress, either as a one of check or with watch for persistence.

```bash
kubectl get pods
kubectl get pods --watch
```

The `Init:0/1` is running initialization containers to prepare the Flux View. When you see `PodsInitializing` this usually is primarily containers pulling for our main application. The `Running` state indicates our cluster is ready to interact with or the job is running. Since this is running a one-off command, it means the MiniCluster is acting like a job with state. It was start, stop, and complete. When it is running you can monitor it via the lead broker (index 0 of the set, which is launching the job). Note that we can add the `-f` to ensure it keeps running.

```bash
kubectl logs flux-sample-0-dl4dm -f
Defaulted container "flux-sample" out of: flux-sample, flux-view (init)
```

Questions for Evan:

 - which envars are not needed?

<details>

<summary> LAMMPS output </summary>

```console
LAMMPS (17 Apr 2024 - Development - a8687b5372)
OMP_NUM_THREADS environment is not set. Defaulting to 1 thread. (src/comm.cpp:98)
  using 1 OpenMP thread(s) per MPI task
Reading data file ...
  triclinic box = (0 0 0) to (22.326 11.1412 13.778966) with tilt (0 -5.02603 0)
  8 by 4 by 4 MPI processor grid
  reading atoms ...
  304 atoms
  reading velocities ...
  304 velocities
  read_data CPU = 0.075 seconds
Replication is creating a 8x8x8 = 512 times larger system...
  triclinic box = (0 0 0) to (178.608 89.1296 110.23173) with tilt (0 -40.20824 0)
  8 by 4 by 4 MPI processor grid
  bounding box image = (0 -1 -1) to (0 1 1)
  bounding box extra memory = 0.03 MB
  average # of replicas added to proc = 18.46 out of 512 (3.61%)
  155648 atoms
  replicate CPU = 0.010 seconds
Neighbor list info ...
  update: every = 20 steps, delay = 0 steps, check = no
  max neighbors/atom: 2000, page size: 100000
  master list distance cutoff = 11
  ghost atom cutoff = 11
  binsize = 5.5, bins = 40 17 21
  2 neighbor lists, perpetual/occasional/extra = 2 0 0
  (1) pair reaxff, perpetual
      attributes: half, newton off, ghost
      pair build: half/bin/ghost/newtoff
      stencil: full/ghost/bin/3d
      bin: standard
  (2) fix qeq/reax, perpetual, copy from (1)
      attributes: half, newton off
      pair build: copy
      stencil: none
      bin: none
Setting up Verlet run ...
  Unit style    : real
  Current step  : 0
  Time step     : 0.1
Per MPI rank memory allocation (min/avg/max) = 143.9 | 143.9 | 143.9 Mbytes
   Step          Temp          PotEng         Press          E_vdwl         E_coul         Volume    
         0   300           -113.27833      438.99595     -111.57687     -1.7014647      1754807.5    
        10   300.88261     -113.2808       1018.2986     -111.5794      -1.7014015      1754807.5    
        20   302.3388      -113.28501      1897.0286     -111.58375     -1.7012621      1754807.5    
        30   302.11018     -113.28419      4220.8936     -111.58318     -1.7010124      1754807.5    
        40   299.82789     -113.27728      6263.6197     -111.57661     -1.7006693      1754807.5    
        50   296.69384     -113.2679       6399.8054     -111.56761     -1.7002908      1754807.5    
        60   294.39704     -113.26102      6164.4726     -111.56111     -1.6999131      1754807.5    
        70   294.64264     -113.26172      6839.9294     -111.56219     -1.699534       1754807.5    
        80   297.83962     -113.27122      8089.2834     -111.57207     -1.6991567      1754807.5    
        90   301.61126     -113.28247      9266.8765     -111.58365     -1.6988216      1754807.5    
       100   302.44604     -113.2849       10317.601     -111.58632     -1.6985828      1754807.5    
Loop time of 16.9415 on 128 procs for 100 steps with 155648 atoms

Performance: 0.051 ns/day, 470.598 hours/ns, 5.903 timesteps/s, 918.737 katom-step/s
99.3% CPU use with 128 MPI tasks x 1 OpenMP threads

MPI task timing breakdown:
Section |  min time  |  avg time  |  max time  |%varavg| %total
---------------------------------------------------------------
Pair    | 8.2037     | 9.3305     | 10.232     |  13.5 | 55.08
Neigh   | 0.17003    | 0.17238    | 0.1991     |   0.8 |  1.02
Comm    | 0.74964    | 1.6075     | 2.6846     |  32.1 |  9.49
Output  | 0.0052343  | 0.025479   | 0.068773   |  11.0 |  0.15
Modify  | 5.7377     | 5.8048     | 5.8892     |   1.9 | 34.26
Other   |            | 0.0007941  |            |       |  0.00

Nlocal:           1216 ave        1223 max        1211 min
Histogram: 14 9 15 18 19 32 10 5 4 2
Nghost:        7592.34 ave        7607 max        7578 min
Histogram: 2 5 14 20 25 23 22 10 3 4
Neighs:         432973 ave      435336 max      431057 min
Histogram: 4 13 18 18 22 23 15 7 6 2

Total # of neighbors = 55420529
Ave neighs/atom = 356.06323
Neighbor list builds = 5
Dangerous builds not checked
Total wall time: 0:00:17
```

</details>

The pods will be complete. This is a feature of a Kubernetes Job - you can see the logs and state even though it has completed and there isn't a physical pod running in the cluster.
 
```bash
$ kubectl get pods
NAME                  READY   STATUS      RESTARTS   AGE
flux-sample-0-dl4dm   0/1     Completed   0          5m19s
flux-sample-1-447xz   0/1     Completed   0          5m19s
```

When you are done, clean up.

```bash
kubectl delete -f minicluster.yaml
```

### Interactive MiniCluster

We are now going to run the same LAMMPS work, but instead of using the MiniCluster as a job, we are going to add `interactive: true` to the CRD. This will keep the cluster running for us to shell into and interact with Flux.

```bash
kubectl apply -f minicluster-interactive.yaml
```

When the pods are running, shell in:

```bash
kubectl exec -it flux-sample-xxxxx -- bash

# Source variables for flux socket etc.
. /mnt/flux/flux-view.sh
flux proxy $fluxsocket bash
```

You'll then have a full cluster (the resources will match what you are given).

```bash
# flux resource list
     STATE NNODES   NCORES    NGPUS NODELIST
      free      2      128        0 flux-sample-[0-1]
 allocated      0        0        0 
      down      0        0        0 
```

Then run lammps, this time using flux directly (Note, we need to choose and test a container for AWS).

```bash
flux run -N2 -n 128 -o cpu-affinity=per-task lmp -v x 8 -v y 8 -v z 8 -in in.reaxff.hns -nocite
```

You can also `flux submit` the same. When you are done, exit from the interface and:

```bash
kubectl delete -f minicluster-interactive.yaml
```


### Helm Install

We can also install everything via the helm package manager. This is the same LAMMPS.

```bash
# Install the helm chart
helm install \
  --set minicluster.efa=1 \
  --set minicluster.size=2 \
  --set experiment.nodes=2 \
  --set experiment.tasks=128 \
  --set experiment.iterations=3 \
  --set lammps.x=8 \
  --set lammps.y=8 \
  --set lammps.z=8 \
  --set minicluster.image=ghcr.io/converged-computing/lammps-reax-efa:ubuntu2404-efa \
  --set flux.image=ghcr.io/converged-computing/flux-view-rocky:arm-9 \
lammps oci://ghcr.io/converged-computing/flux-apps-helm-lammps-reax/chart --version 0.1.0
```

Note that you can also clone this entire repository of apps to install from the command line:

```bash
git clone https://github.com/converged-computing/flux-apps-helm
cd ./flux-apps-helm
helm show values ./lammps-reax

helm install \
  --set minicluster.efa=1 \
  --set minicluster.size=2 \
  --set experiment.nodes=2 \
  --set experiment.tasks=128 \
  --set experiment.iterations=3 \
  --set lammps.x=8 \
  --set lammps.y=8 \
  --set lammps.z=8 \
  --set minicluster.image=ghcr.io/converged-computing/lammps-reax-efa:ubuntu2404-efa \
  --set flux.image=ghcr.io/converged-computing/flux-view-rocky:arm-9 \
lammps ./lammps-reax
```

See the experiment output:

```bash
kubectl logs lammps-0-g2ggm -f
```

When you are done:

```bash
helm uninstall lammps
```

## Cleanup

If you created the cluster:

```bash
eksctl delete cluster --config-file ./eks-config.yaml --wait
```
