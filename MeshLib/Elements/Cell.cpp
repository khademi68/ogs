/**
 * \file Cell.cpp
 *
 * Created on 2012-05-02 by Karsten Rink
 */

#include "Cell.h"

namespace MeshLib {
/*
Cell::Cell(Node** nodes, MshElemType::type type, unsigned value)
	: Element(nodes, type, value)
{
}
*/
Cell::Cell(MshElemType::type type, unsigned value)
	: Element(type, value)
{
}

Cell::~Cell()
{
	delete[] this->_neighbors;
}


}

