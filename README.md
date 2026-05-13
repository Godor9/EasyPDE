# EasyPDE
This repository aims to provide an easy learning curve to understand and use the pseudo-transient method to solve partial differential equations (PDEs). We don't focus on the performance but provide explanations of the PT methods and simple implementations.
The algorithms are featured by:
Finite difference: the most understandable way of solving PDE
Pseudo-transient solver: use Pseudo time marching (iteration) to achieve implicit solution
Matrix-free: no need to assembly large matrix 
Stencil computation: update array elements according to some fixed pattern, called a stencil. suitable for the parallel implementation (Both GPU and CPU).
Staggered grid:velocity nodes and pressure nodes are not the same, which avoid the checkboard phenomenon
2nd convergence: by using Fourier analysis, we aim a 2nd convergence dampening scheme for each equation.

The algorithms allow us to write numerical solver in a way that is similar to the mathmatical equation. Thus it will be simple and readable. Yet, due to it is matrix-free and stencil based, it is also very much scalable. So the learner will be able to implement a high performance code themselve. We will take the diffusion equation and stokes equations to explain and implement the algorithm. Some of the derivation process will be provided with python symbolic file. 

One can cite these literatures if you find this repository is helpful:
Wang, L.H., Yarushina, V.M., Alkhimenkov, Y. & Podladchikov, Y. (2022) Physics-inspired pseudo-transient method and its application in modelling focused fluid flow with geological complexity. Geophys. J. Int., 229, 1–20, Oxford Academic. doi:10.1093/GJI/GGAB426

Räss L., Duretz T., Podladchikov Y.Y., 2019. Resolving hydromechanical coupling in two and three dimensions: spontaneous channelling of porous fluids owing to decompaction weakening, Geophys. J. Int., 218, 1591–1616. 10.1093/gji/ggz239




Todo:
add a title for each lesson.  The name of the file would not be show when one print it the notebook.
