# SC25 Flux EKS Tutorial


## Notes

### Module 1: Flux Framework

- Refactor existing slides
- Flux Operator intro should include showing run with lammps
- Should also include run with helm

### Module 2: MuMMI

- Introduce MuMMI as a smaller sized proxy workflow
- Talk about workflows of this type, show how was run with state machine operator
  - Here is an example of a complex workflow - we cannot run ideally due to resources we are given
  - Here is a separate example showing running Flux in Kubernetes using component of MuMMI
- We should talk through ways you *could* run the workflow:
  - Inside of a single MiniCluster (assuming workload manager and applications installed)
  - As separate jobs with some kind of dependency structure
  - Inside of a singule MiniCluster with singularity containers (requires privileged)
  - Flux Operator depends on (does not exist but could)
- For tutorial, explain we are going to run just components using the Flux Operator
  - Start with single component "manual" approach
    - This could be slides instead of doing.
  - Then show running MuMMI with state machine operator - does not require Flux
  - If we want to add AA we need MPI (multiple nodes) so we use Flux Operator. fuxfuxfux
    - If you want MPI, MPI Operator "HOT GARBAGE" - Dan (and we agree)
    
### What we need to do:

 - Slides
   - Flux module - refactor some of previous tutorials
   - MuMMI module - do the same but we probably need new content
   - SC Template for first slide
 - $1400 honorarium for T-shirts, etc.
 - Our tutorial is scheduled for Sunday (I think)
 - Build and test an AA (multi-node) container (Loic is going to ask Helgi if this is feasible)
 - We never got repository to collaborate with AWS
 - We can use our account to test.
 - Write repository / configs for:
    - eks config to create cluster
    - Flux operator install
    - Single lammps run
    - helm install of lammps
    - Single gromacs "component" run
    - State machine operator install
    - Mini MuMMI as a state machine (no Flux)
    - Mini MuMMI as a state machine (with AA and Flux)
    - If not AA, "course grained" with gromacs. If not course grained, then just gromacs.
