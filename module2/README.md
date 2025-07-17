# Module 2: Advanced Workload Management with Flux Framework

## Setup

Create the eksctl cluster. Note that this takes about 20 minutes.

```bash
eksctl create cluster --config-file ./eks-config.yaml
aws eks update-kubeconfig --region us-east-2 --name lammps-cluster
```

When the cluster is created, install the Flux Operator.

```bash
kubectl apply -f https://raw.githubusercontent.com/flux-framework/flux-operator/refs/heads/main/examples/dist/flux-operator.yaml
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

<details>

<summary> LAMMPS output </summary>

```console
LAMMPS (29 Sep 2021 - Update 2)
OMP_NUM_THREADS environment is not set. Defaulting to 1 thread. (src/comm.cpp:98)
  using 1 OpenMP thread(s) per MPI task
Reading data file ...
  triclinic box = (0.0000000 0.0000000 0.0000000) to (22.326000 11.141200 13.778966) with tilt (0.0000000 -5.0260300 0.0000000)
  2 by 1 by 1 MPI processor grid
  reading atoms ...
  304 atoms
  reading velocities ...
  304 velocities
  read_data CPU = 0.001 seconds
Replicating atoms ...
  triclinic box = (0.0000000 0.0000000 0.0000000) to (44.652000 22.282400 27.557932) with tilt (0.0000000 -10.052060 0.0000000)
  2 by 1 by 1 MPI processor grid
  bounding box image = (0 -1 -1) to (0 1 1)
  bounding box extra memory = 0.03 MB
  average # of replicas added to proc = 5.00 out of 8 (62.50%)
  2432 atoms
  replicate CPU = 0.000 seconds
Neighbor list info ...
  update every 20 steps, delay 0 steps, check no
  max neighbors/atom: 2000, page size: 100000
  master list distance cutoff = 11
  ghost atom cutoff = 11
  binsize = 5.5, bins = 10 5 6
  2 neighbor lists, perpetual/occasional/extra = 2 0 0
  (1) pair reax/c, perpetual
      attributes: half, newton off, ghost
      pair build: half/bin/newtoff/ghost
      stencil: full/ghost/bin/3d
      bin: standard
  (2) fix qeq/reax, perpetual, copy from (1)
      attributes: half, newton off, ghost
      pair build: copy
      stencil: none
      bin: none
Setting up Verlet run ...
  Unit style    : real
  Current step  : 0
  Time step     : 0.1
Per MPI rank memory allocation (min/avg/max) = 143.9 | 143.9 | 143.9 Mbytes
Step Temp PotEng Press E_vdwl E_coul Volume 
       0          300   -113.27833    437.52118   -111.57687   -1.7014647    27418.867 
      10    299.38517   -113.27631    1439.2824   -111.57492   -1.7013813    27418.867 
      20    300.27107   -113.27884     3764.342   -111.57762   -1.7012247    27418.867 
      30    302.21063   -113.28428    7007.6629   -111.58335   -1.7009363    27418.867 
      40    303.52265   -113.28799    9844.8245   -111.58747   -1.7005186    27418.867 
      50    301.87059   -113.28324    9663.0973   -111.58318   -1.7000523    27418.867 
      60    296.67807   -113.26777    7273.8119   -111.56815   -1.6996137    27418.867 
      70    292.19999   -113.25435    5533.5522   -111.55514   -1.6992158    27418.867 
      80    293.58677   -113.25831    5993.4438   -111.55946   -1.6988533    27418.867 
      90    300.62635   -113.27925    7202.8369   -111.58069   -1.6985592    27418.867 
     100    305.38276   -113.29357    10085.805   -111.59518   -1.6983874    27418.867 
Loop time of 8.98892 on 2 procs for 100 steps with 2432 atoms

Performance: 0.096 ns/day, 249.692 hours/ns, 11.125 timesteps/s
100.0% CPU use with 2 MPI tasks x 1 OpenMP threads

MPI task timing breakdown:
Section |  min time  |  avg time  |  max time  |%varavg| %total
---------------------------------------------------------------
Pair    | 6.3883     | 6.5812     | 6.7741     |   7.5 | 73.21
Neigh   | 0.12049    | 0.12085    | 0.12122    |   0.1 |  1.34
Comm    | 0.0092565  | 0.20229    | 0.39531    |  42.9 |  2.25
Output  | 0.00030531 | 0.00042444 | 0.00054356 |   0.0 |  0.00
Modify  | 2.0833     | 2.0837     | 2.0841     |   0.0 | 23.18
Other   |            | 0.0004745  |            |       |  0.01

Nlocal:        1216.00 ave        1216 max        1216 min
Histogram: 2 0 0 0 0 0 0 0 0 0
Nghost:        7591.50 ave        7597 max        7586 min
Histogram: 1 0 0 0 0 0 0 0 0 1
Neighs:        432912.0 ave      432942 max      432882 min
Histogram: 1 0 0 0 0 0 0 0 0 1

Total # of neighbors = 865824
Ave neighs/atom = 356.01316
Neighbor list builds = 5
Dangerous builds not checked
Total wall time: 0:00:09
```

</details>

The pods will be complete. This is a feature of a Kubernetes Job - you can see the logs and state even though it has completed and there isn't a physical pod running in the cluster.
 
```bash
$ kubectl get pods
NAME                  READY   STATUS      RESTARTS   AGE
flux-sample-0-dl4dm   0/1     Completed   0          5m19s
flux-sample-1-447xz   0/1     Completed   0          5m19s
flux-sample-2-8sfb4   0/1     Completed   0          5m19s
flux-sample-3-q9xqg   0/1     Completed   0          5m19s
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
      free      4       32        0 flux-sample-[0-3]
 allocated      0        0        0 
      down      0        0        0 
```

Then run lammps, this time using flux directly (Note, we need to choose and test a container for AWS).

```bash
flux run -N4 -n 32 lmp -v x 2 -v y 2 -v z 2 -in in.reaxff.hns -nocite
```

You can also `flux submit` the same. When you are done, exit from the interface and:

```bash
kubectl delete -f minicluster-interactive.yaml
```


### Helm Install

We can also install everything via the helm package manager. This is the same LAMMPS.
TODO: optimize this for AWS deployment.

```bash
# Install the helm chart
helm install lammps oci://ghcr.io/converged-computing/flux-apps-helm-lammps-reax/chart --version 0.1.0 \
  --set minicluster.size=4 \
  --set minicluster.efa=true
```

Note that you can also clone this entire repository of apps to install from the command line:

```bash
git clone https://github.com/converged-computing/flux-apps-helm
cd ./flux-apps-helm
helm show values ./lammps

# Put the equivalent --set arguments here
helm install lammps ./lammps
```

## Cleanup

If you created the cluster:

```bash
eksctl delete cluster --config-file ./eks-config.yaml --wait
```

## Original Notes

This is now more of a TODO list.

- [ ] This needs testing on the AWS resources / cluster (we can do hackathon)
- [ ] Slides should introduce Flux and the Flux Operator
