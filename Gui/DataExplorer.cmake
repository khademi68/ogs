# Source files
SET( SOURCES
	mainwindow.cpp
)

# Moc Header files
SET( MOC_HEADERS
	mainwindow.h
)

# Header files
SET( HEADERS

)

# UI files
SET( UIS
	mainwindow.ui
)


# Run Qts user interface compiler uic on .ui files
QT4_WRAP_UI( UI_HEADERS ${UIS} )

# Run Qts meta object compiler moc on header files
QT4_WRAP_CPP( MOC_SOURCES ${MOC_HEADERS} )

INCLUDE( ${VTK_USE_FILE} )

# Include the headers which are generated by uic and moc
# and include additional header
INCLUDE_DIRECTORIES(
	${CMAKE_BINARY_DIR}/BaseLib
	${CMAKE_BINARY_DIR}/Gui/
	${CMAKE_BINARY_DIR}/Gui/Base
	${CMAKE_BINARY_DIR}/Gui/DataView
	${CMAKE_BINARY_DIR}/Gui/DataView/StratView
	${CMAKE_BINARY_DIR}/Gui/DataView/DiagramView
	${CMAKE_BINARY_DIR}/Gui/VtkVis
	${CMAKE_BINARY_DIR}/Gui/VtkAct
	${CMAKE_SOURCE_DIR}/BaseLib
	${CMAKE_SOURCE_DIR}/MathLib
	${CMAKE_SOURCE_DIR}/GeoLib
	${CMAKE_SOURCE_DIR}/FileIO
	${CMAKE_SOURCE_DIR}/MeshLib
	${CMAKE_SOURCE_DIR}/MeshLibGEOTOOLS
	${CMAKE_SOURCE_DIR}/FemLib
	${CMAKE_SOURCE_DIR}/OGS
	${CMAKE_SOURCE_DIR}/Gui/Base
	${CMAKE_SOURCE_DIR}/Gui/DataView
	${CMAKE_SOURCE_DIR}/Gui/DataView/StratView
	${CMAKE_SOURCE_DIR}/Gui/DataView/DiagramView
	${CMAKE_SOURCE_DIR}/Gui/VtkVis
	${CMAKE_SOURCE_DIR}/Gui/VtkAct
)

IF (Shapelib_FOUND)
	INCLUDE_DIRECTORIES( ${Shapelib_INCLUDE_DIR} )
ENDIF () # Shapelib_FOUND

# Put moc files in a project folder
SOURCE_GROUP("UI Files" REGULAR_EXPRESSION "\\w*\\.ui")
SOURCE_GROUP("Moc Files" REGULAR_EXPRESSION "moc_.*")

# Create the library
ADD_EXECUTABLE( ogs-gui
	main.cpp
	${SOURCES}
	${HEADERS}
	${MOC_HEADERS}
	${MOC_SOURCES}
	${UIS}
)

TARGET_LINK_LIBRARIES( ogs-gui
	${QT_LIBRARIES}
	BaseLib
	GeoLib
	FileIO
	MeshLib
	#MSHGEOTOOLS
	FemLib
	OgsLib
	QtBase
	QtDataView
	StratView
	VtkVis
	VtkAct
	vtkRendering
	vtkWidgets
	QVTK
)

IF(VTK_NETCDF_FOUND)
	TARGET_LINK_LIBRARIES( ogs-gui vtkNetCDF vtkNetCDF_cxx )
ELSE()
	TARGET_LINK_LIBRARIES( ogs-gui ${NETCDF_LIBRARIES} )
ENDIF()

IF (Shapelib_FOUND)
	TARGET_LINK_LIBRARIES( ogs-gui ${Shapelib_LIBRARIES} )
ENDIF () # Shapelib_FOUND

IF (libgeotiff_FOUND)
	TARGET_LINK_LIBRARIES( ogs-gui ${libgeotiff_LIBRARIES} )
ENDIF () # libgeotiff_FOUND

ADD_DEPENDENCIES ( ogs-gui VtkVis OGSProject )

IF(MSVC)
	# Set linker flags
	SET(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} /NODEFAULTLIB:MSVCRT")
ENDIF(MSVC)

IF(OGS_BUILD_INFO)
	ADD_DEFINITIONS(-DOGS_BUILD_INFO)
ENDIF() # OGS_BUILD_INFO

### OpenSG support ###
IF (OGS_USE_OPENSG)
	USE_OPENSG(ogs-gui)
	INCLUDE_DIRECTORIES( ${CMAKE_SOURCE_DIR}/Gui/OpenSG )
	TARGET_LINK_LIBRARIES( ogs-gui OgsOpenSG )
ENDIF (OGS_USE_OPENSG)

IF(OGS_USE_VRPN)
	INCLUDE_DIRECTORIES( ${CMAKE_SOURCE_DIR}/Gui/Vrpn ${CMAKE_BINARY_DIR}/Gui/Vrpn )
	TARGET_LINK_LIBRARIES( ogs-gui ${VRPN_LIBRARIES} OgsVrpn )
ENDIF()

set_property(TARGET ogs-gui PROPERTY FOLDER "DataExplorer")

###################
### VRED plugin ###
###################

IF (OGS_VRED_PLUGIN)

	ADD_DEFINITIONS(
		-DBOOST_PYTHON_DYNAMIC_LIB
	)

	INCLUDE_DIRECTORIES(
		#${VRED_DIR}/include/vred
    ${VRED_DIR}/include/boost-1.34-vc8.0
    ${VRED_DIR}/include/python-2.52-vc8.0
    #${VRED_DIR}/include/zlib-1.23
    #${VRED_DIR}/include/OpenSG
    #${VRED_DIR}/include/OpenSG/OpenSG
	)
	LINK_DIRECTORIES( ${VRED_DIR}/bin/WIN32 )

	ADD_LIBRARY( ogs-gui-vred SHARED
		${SOURCES}
		${HEADERS}
		${MOC_HEADERS}
		${MOC_SOURCES}
		${UIS}
		pymainwindow.cpp
	)
	TARGET_LINK_LIBRARIES( ogs-gui-vred
		${QT_LIBRARIES}
		GEO
		FileIO
		MSH
		FEM
		OGSProject
		QtBase
		QtDataView
		StratView
		${Shapelib_LIBRARIES}
		${libgeotiff_LIBRARIES}
		VtkVis
		VtkAct
		#boost_python-vc80-mt-1_34_1
	)

	ADD_DEPENDENCIES ( ogs-gui-vred VtkVis OGSProject )
ENDIF (OGS_VRED_PLUGIN)

####################
### Installation ###
####################

IF (OGS_PACKAGING)
	INSTALL (TARGETS ogs-gui RUNTIME DESTINATION bin COMPONENT ogs_gui)

	IF(MSVC)
		SET(OGS_GUI_EXE ${EXECUTABLE_OUTPUT_PATH}/Release/ogs-gui.exe)
	ELSE(MSVC)
		SET(OGS_GUI_EXE ${EXECUTABLE_OUTPUT_PATH}/ogs-gui)
	ENDIF(MSVC)

	INCLUDE(GetPrerequisites)
	if (EXISTS ${OGS_GUI_EXE})
		GET_PREREQUISITES(${OGS_GUI_EXE} OGS_GUI_DEPENDENCIES 1 1 "/usr/local/lib;/;${VTK_DIR};${OpenSG_LIBRARY_DIRS}" "")
		MESSAGE (STATUS "ogs-gui depends on:")
		FOREACH(DEPENDENCY ${OGS_GUI_DEPENDENCIES})
			IF(NOT ${DEPENDENCY} STREQUAL "not") # Some bug on Linux?
				message("${DEPENDENCY}")
				GP_RESOLVE_ITEM ("/" "${DEPENDENCY}" ${OGS_GUI_EXE} "/usr/local/lib;/;${VTK_DIR}" DEPENDENCY_PATH)
				SET (DEPENDENCY_PATHS ${DEPENDENCY_PATHS} ${DEPENDENCY_PATH})
			ENDIF()
		ENDFOREACH (DEPENDENCY IN ${OGS_GUI_DEPENDENCIES})
		INSTALL (FILES ${DEPENDENCY_PATHS} DESTINATION bin COMPONENT ogs_gui)
	ENDIF (EXISTS ${OGS_GUI_EXE})
ENDIF (OGS_PACKAGING)