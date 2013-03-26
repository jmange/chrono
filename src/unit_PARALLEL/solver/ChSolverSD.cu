#include "ChSolverGPU.h"
using namespace chrono;


uint ChSolverGPU::SolveSD(custom_vector<real> &x, const custom_vector<real> &b, const uint max_iter) {
    custom_vector<real> r;
    r = b - ShurProduct(x);
    real resold = 1, resnew, normb = Norm(b), alpha;
    if (normb == 0.0) {
        normb = 1;
    }
    for (current_iteration = 0; current_iteration < max_iter; current_iteration++) {
        alpha = Dot(r, r) / Dot(r, ShurProduct(r));
        SEAXPY(alpha, r, x, x); //x = x + eps *r;
        r = b - ShurProduct(x);
        resnew = Norm(x);
        residual = abs(resnew - resold);
        if (residual < tolerance) {
            break;
        }
        resold = resnew;
    }
    Project(x);
    return current_iteration;
}
