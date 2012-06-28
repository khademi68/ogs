/**
 * \file BiCGStab.h
 *
 *  Created on 2011-10-04 by Thomas Fischer
 */

#ifndef BICGSTAB_H_
#define BICGSTAB_H_

#include "blas.h"
#include "../Sparse/CRSMatrix.h"
#include "../Sparse/CRSMatrixDiagPrecond.h"

namespace MathLib {

unsigned BiCGStab(CRSMatrix<double, unsigned> const& A, double* const b, double* const x,
                  double& eps, unsigned& nsteps);

} // end namespace MathLib

#endif /* BICGSTAB_H_ */
