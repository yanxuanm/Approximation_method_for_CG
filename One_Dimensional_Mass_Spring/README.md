# One Dimensional Mass Spring System

Apply asymptotic expansion, we can solve spring mass damper system, which is a second order ODE. 

## Regular Perturbation 

Spring mass damper with small damping. 

> In contrast to singular perturbation problems, which spring mass damper with small mass/inertia, this will be a highly damped system which will oscillate when the mass is not equal to zero. 

Let's cast the problem in terms of the mathematical model with initial condition:
$$\begin{array}{c}
m \frac{d^{2}u}{dt^{2}} + c\frac{du}{dt} + ku = 0, \quad u(0) = u_{0} \quad and \quad \frac{du(0)}{dt} = 0
\end{array}$$
Where $m$ is mass, $c$ is damping coefficient, and $k$ is the stiffness of the spring. 
First, we need to nondimensionalize this problem which removes all units from this equation involving physical quantities:
$$\begin{array}{c}
v = \frac{u}{u_{0}}  \\ \tau = \frac{t}{T}
\end{array}$$
By introducing dimensionless variables, the differential operators becomes:
$$\begin{array}{c}
\frac{d}{dt} = \frac{d\tau}{dt}\frac{d}{d\tau} = \frac{1}{T}\frac{d}{d\tau}
\end{array}$$
> Multiple physical time scales: 
> Oscillation time scale $T_{o} = \sqrt{\frac{m}{k}}$
> Decay time scale $T_{d} = \frac{c}{k}$

After non-dimensionalizing, equation becomes:
$$\begin{array}{c}
m\frac{1}{T^{2}}u_{0}\frac{d^{2}v}{d\tau^{2}} + c\frac{1}{T}u_{0}\frac{dv}{d\tau} + ku_{0}v = 0
\end{array}$$
Since we are dealing with small damping, which means the inertia term and spring force almost in balance, and in perturbation theory, we first set the small perturbe term to be zero. If the magnitude of these two terms coefficients are equal, we can have $\frac{m}{T^{2}} = k$ and $T = \sqrt{\frac{m}{k}}. 
Furthermore, by dividing this equation with coefficient of mass, coefficient of damping term will be: $\frac{c}{\sqrt{mk}} = \gamma$, cleaning up: 
$$\begin{array}{c}
\frac{d^{2}v}{d\tau^{2}} + \gamma\frac{dv}{d\tau} + v = 0
\end{array}$$
For future computational convenience, let $\gamma = 2\epsilon$, $\epsilon = \frac{c}{2\sqrt{mk}} \ll 1$. 