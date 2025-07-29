# Initial Notes

In the actual MuMMI workflow, 

> MuMMI

Mini MuMMI is a smaller sized version of the production MuMMI workflow. For this tutorial, we will run components using the Flux Operator, and then move into orchestrating MuMMI as a state machine. All runs will use Kubernetes.

- For tutorial, explain we are going to run just components using the Flux Operator
  - Start with single component "manual" approach
    - This could be slides instead of doing.
  - Then show running MuMMI with state machine operator - does not require Flux
  - If we want to add AA we need MPI (multiple nodes) so we use Flux Operator. fuxfuxfux
    - If you want MPI, MPI Operator "HOT GARBAGE" - Dan (and we agree)
    
##### What we need to do:

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
