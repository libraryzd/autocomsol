# Infrastructure acceptance benchmark

Purpose: test official MCP -> existing MATLAB -> LiveLink -> COMSOL solve -> save/reload -> numeric export -> independent MATLAB plotting. This is a setup test authorized by the setup request, not an application simulation.

Model: 2D rectangular solid, length L=0.1 m and height H=0.02 m. Constant conductivity k=10 W/(m K); left T=400 K, right T=300 K; upper/lower boundaries insulated. No heat source. Stationary heat transfer. Density 1000 kg/m^3 and heat capacity 1000 J/(kg K) are synthetic constants irrelevant to the stationary analytic result. No experimental material claim.

Analytic solution: T(x)=400-100*x/L K, qx=10000 W/m^2. Integrated outward flux is -200 W/m on the left and +200 W/m on the right (per unit out-of-plane thickness).

Run two automatic mesh settings (5 and 3). Both should reproduce the linear exact solution; agreement is a plumbing/regression check, NOT evidence of general mesh convergence for nonlinear or singular models.

Acceptance: maximum profile error <1e-3 K; relative boundary flux error <1e-5; relative energy imbalance <1e-6; mesh-to-mesh profile difference <1e-3 K; reloaded solution profile difference <1e-8 K. All sampled data must be finite and real. Values saved with explicit dataset/solution/units.

Budget: small stationary model, sequential execution; 180-second transport budget initially. Timeout means unknown execution state; inspect outputs before retrying. Up to three targeted fixes for the same error without new evidence. No existing user model is modified; unique tags identify only this test's models.

Inputs, exact solution and all figures are synthetic validation data. The installed COMSOL/MATLAB pair must be recorded even if outside the official support matrix. Passing does not imply vendor support or validate arbitrary future models.
