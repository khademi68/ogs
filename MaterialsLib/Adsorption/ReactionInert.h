/**
 * \copyright
 * Copyright (c) 2012-2016, OpenGeoSys Community (http://www.opengeosys.org)
 *            Distributed under a Modified BSD License.
 *              See accompanying file LICENSE.txt or
 *              http://www.opengeosys.org/project/license
 *
 */

#ifndef MATERIALSLIB_ADSORPTION_REACTIONINERT_H
#define MATERIALSLIB_ADSORPTION_REACTIONINERT_H

#include "Reaction.h"

namespace Adsorption
{

class ReactionInert final : public Reaction
{
public:
    double getEnthalpy(const double /*p_Ads*/, const double /*T_Ads*/,
                        const double /*M_Ads*/) const override
    {
        return 0.0;
    }

    double getReactionRate(const double /*p_Ads*/, const double /*T_Ads*/, const double /*M_Ads*/,
                             const double /*loading*/) const override
    {
        ERR("Method getReactionRate() should never be called directly");
        std::abort();
        return 0.0;
    }
};

}
#endif // MATERIALSLIB_ADSORPTION_REACTIONINERT_H
