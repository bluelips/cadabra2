
cmake_minimum_required(VERSION 2.8)

project(Cadabra)


# Set path to additional cmake files
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/../cmake/modules")

message("-- CMake version = ${CMAKE_VERSION}")

if (POLICY CMP0042)
  cmake_policy(SET CMP0042 NEW)
endif(POLICY CMP0042)

if(WIN32)
	set(INSTALL_BIN_DIR     "."					 CACHE PATH "Installation directory for binary products.")
else()
	set(INSTALL_BIN_DIR     bin					 CACHE PATH "Installation directory for binary products.")
endif()

# Locate python. On Apple the standard CMake PythonLibs.cmake does not
# work correctly, because it will always give some paths which point
# to the Apple-supplied Python libraries. We need the Homebrew
# installed ones. In order to achieve this, we use CMake scripts which
# were taken from Nikolaus Dremmel's repo at github.com/NikolausDemmel/CMake.


if(USE_PYTHON_3)
  set(Python_ADDITIONAL_VERSIONS 3.4 3.5 3.6)
  set(PythonInterp_ADDITIONAL_VERSIONS 3.4 3.5 3.6)
  find_package(PythonInterp 3.4 REQUIRED)
  if(APPLE)
     find_package(PythonLibsOSX 3.4 REQUIRED)
  else()
     find_package(PythonLibs 3.4 REQUIRED)
  endif()
else()
  set(Python_ADDITIONAL_VERSIONS 2.7)
  set(PythonInterp_ADDITIONAL_VERSIONS 2.7)
  find_package(PythonInterp 2.7 REQUIRED)
  if(APPLE)
     find_package(PythonLibsOSX 2.7 REQUIRED)
  else()
     find_package(PythonLibs 2.7 REQUIRED)
  endif()
endif()
message("-- Python version = ${PYTHONLIBS_VERSION_STRING}")

# Locate Boost and Boost.Python.
add_definitions("-DBOOST_ALL_NO_LIB")
set(Boost_USE_STATIC_LIBS OFF)
set(Boost_USE_MULTITHREADED ON)
set(Boost_USE_STATIC_RUNTIME OFF)
if(USE_PYTHON_3)
  find_package(Boost 1.53.0 COMPONENTS python3 regex)
  if(NOT Boost_PYTHON3_FOUND)
    if("${PYTHONLIBS_VERSION_STRING}" MATCHES "^3.4")
      find_package(Boost 1.53.0 COMPONENTS python-py34 regex REQUIRED)
    else()
	  if("${PYTHONLIBS_VERSION_STRING}" MATCHES "^3.5")    
	    find_package(Boost 1.53.0 COMPONENTS python-py35 regex REQUIRED)
	  else()
	    find_package(Boost 1.53.0 COMPONENTS python-py36 regex REQUIRED)
	  endif()
    endif()
  endif()
else()
  find_package(Boost 1.53.0 COMPONENTS python regex)
endif()

if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    if (CMAKE_CXX_COMPILER_VERSION VERSION_LESS 3.5)
        message(FATAL_ERROR "Clang version must be at least 3.5 to avoid known bugs.")
    endif()
#	 add_definitions("-Wno-potentially-evaluated-expression")
endif()



# Locate gmpxx. On Homebrew there seems to be constantly something wrong with
# the pkgconfig for gmpxx. So we just add the include path by hand.
if(APPLE)
	add_definitions("-I/usr/local/include -I/opt/local/include")
    find_library(GMP_LIB gmp REQUIRED)
	find_library(GMPXX_LIB gmpxx REQUIRED)
elseif(WIN32)
	# by default in windows the gmp library puts results directly on the drive here
    add_definitions("-I/msvc/include/ -I/msvc/lib/x86")
    message("--- Adding '-I/msvc/include -I/msvc/lib/x86' for WIN32 for GMP")
	
	find_library(GMP_LIB NAMES gmp HINTS /msvc/lib/x86/ /msvc/include/)
	find_library(GMPXX_LIB NAMES gmpxx HINTS /msvc/lib/x86/ /msvc/include/)
else()
	find_library(GMP_LIB gmp REQUIRED)
	find_library(GMPXX_LIB gmpxx REQUIRED)
endif()
message("-- Found gmp ${GMP_LIB}")
message("-- Found gmpxx ${GMPXX_LIB}")
message("-- Found python ${PYTHON_LIBRARIES}")
include_directories("${Boost_INCLUDE_DIRS}" ${PYTHON_INCLUDE_DIRS})
message("-- Python include dirs: ${PYTHON_INCLUDE_DIRS}")

# Locate pcre
find_package(PCRE REQUIRED)

if(CMAKE_COMPILER_IS_GNUCXX)
  add_definitions("-Wall -g -Wno-unused-but-set-variable")
endif()

set(LOCAL_SRC_FILES
  PythonCdb.cc
  ProgressMonitor.cc
  Bridge.cc
  Algorithm.cc
  Cleanup.cc
  Combinatorics.cc
  Compare.cc
  DisplayBase.cc
  DisplayTeX.cc
  DisplaySympy.cc
  DisplayTerminal.cc
  TerminalStream.cc
  Exceptions.cc
  Exchange.cc
  Functional.cc
  IndexIterator.cc
  Kernel.cc
  Parser.cc
  PreClean.cc
  PreProcessor.cc
  Props.cc
  PythonException.cc
  Stopwatch.cc
  Storage.cc
  Symbols.cc
  SympyCdb.cc
  YoungTab.cc
  properties/Accent.cc
  properties/AntiCommuting.cc
  properties/AntiSymmetric.cc
  properties/Commuting.cc
  properties/CommutingAsProduct.cc
  properties/CommutingAsSum.cc
  properties/CommutingBehaviour.cc
  properties/Coordinate.cc
  properties/DAntiSymmetric.cc
  properties/Depends.cc
  properties/DependsInherit.cc
  properties/Derivative.cc
  properties/Diagonal.cc
  properties/DifferentialForm.cc
  properties/DiracBar.cc
  properties/Distributable.cc
  properties/EpsilonTensor.cc
  properties/ExteriorDerivative.cc
  properties/FilledTableau.cc
  properties/GammaMatrix.cc
  properties/GammaTraceless.cc
  properties/ImaginaryI.cc
  properties/ImplicitIndex.cc
  properties/Indices.cc
  properties/Integer.cc
  properties/InverseMetric.cc
  properties/KroneckerDelta.cc
  properties/LaTeXForm.cc
  properties/Matrix.cc
  properties/Metric.cc
  properties/NonCommuting.cc
  properties/NumericalFlat.cc
  properties/PartialDerivative.cc
  properties/RiemannTensor.cc
  properties/SatisfiesBianchi.cc
  properties/SelfAntiCommuting.cc
  properties/SelfCommuting.cc
  properties/SelfNonCommuting.cc
  properties/SortOrder.cc
  properties/Spinor.cc
  properties/Symbol.cc
  properties/Symmetric.cc
  properties/Tableau.cc
  properties/TableauBase.cc
  properties/TableauSymmetry.cc
  properties/Traceless.cc
  properties/Weight.cc
  properties/WeightInherit.cc
  properties/WeylTensor.cc
  modules/xperm_new.cc
  algorithms/canonicalise.cc
  algorithms/collect_components.cc
  algorithms/collect_factors.cc
  algorithms/collect_terms.cc
  algorithms/combine.cc
  algorithms/complete.cc
  algorithms/decompose_product.cc
  algorithms/distribute.cc
  algorithms/drop_weight.cc
  algorithms/einsteinify.cc
  algorithms/eliminate_kronecker.cc
  algorithms/eliminate_metric.cc
  algorithms/epsilon_to_delta.cc
  algorithms/evaluate.cc
  algorithms/expand.cc
  algorithms/expand_delta.cc
  algorithms/expand_diracbar.cc
  algorithms/expand_power.cc
  algorithms/factor_in.cc
  algorithms/factor_out.cc
  algorithms/fierz.cc
  algorithms/flatten_product.cc
  algorithms/flatten_sum.cc
  algorithms/indexsort.cc
  algorithms/integrate_by_parts.cc
  algorithms/join_gamma.cc
  algorithms/keep_terms.cc
  algorithms/lr_tensor.cc
  algorithms/map_sympy.cc
  algorithms/order.cc
  algorithms/product_rule.cc
  algorithms/reduce_delta.cc
  algorithms/rename_dummies.cc
  algorithms/rewrite_indices.cc
  algorithms/sort_product.cc
  algorithms/sort_spinors.cc
  algorithms/sort_sum.cc
  algorithms/split_gamma.cc
  algorithms/split_index.cc
  algorithms/substitute.cc
  algorithms/sym.cc
  algorithms/tab_basics.cc
  algorithms/take_match.cc
  algorithms/replace_match.cc
  algorithms/unwrap.cc
  algorithms/vary.cc
  algorithms/young_project.cc
  algorithms/young_project_product.cc
  algorithms/young_project_tensor.cc
)
set(PUBLIC_HEADER_FILES
  Parser.hh
  Storage.hh
)
set(IMAGES
  ../images/cadabra.png
)

if("${PYTHON_SITE_PATH}" STREQUAL "")
  execute_process(COMMAND ${PYTHON_EXECUTABLE} -c "import site; print (site.getsitepackages()[0]);"
                  OUTPUT_VARIABLE PYTHON_SITE_PATH OUTPUT_STRIP_TRAILING_WHITESPACE)
endif()

# On windows, this comes up as C:\python2.7 often, but then cmake seems to only sometimes automatically convert that into C:/python2.7 so do it manually to avoid errors. Double escape is needed, once to get from here to the internal regex engine, once for the regex engine.
string(REGEX REPLACE "\\\\" "/" SAFE_PYTHON_SITE_PATH ${PYTHON_SITE_PATH})
message("-- Python site path at ${SAFE_PYTHON_SITE_PATH}")
if(WIN32)
	set(PROJECT_BINARY_BUILD_TYPE "/\${CMAKE_INSTALL_CONFIG_NAME}")
	set(PROJECT_BINARY_RESULT_EXT ".dll")
	set(PYTHON_INSTALL_LOCATION "${INSTALL_BIN_DIR}")
	install(
		FILES "${PROJECT_SOURCE_DIR}/cmdstart.py" 
		DESTINATION "${INSTALL_BIN_DIR}")
else()
	set(PROJECT_BINARY_BUILD_TYPE "")
	set(PROJECT_BINARY_RESULT_EXT ".so")
	set(PYTHON_INSTALL_LOCATION "${SAFE_PYTHON_SITE_PATH}")
endif()

install(FILES
  "${PROJECT_BINARY_DIR}${PROJECT_BINARY_BUILD_TYPE}/cadabra2${PROJECT_BINARY_RESULT_EXT}"
  "${PROJECT_SOURCE_DIR}/cadabra2_defaults.py" DESTINATION "${PYTHON_INSTALL_LOCATION}")
  
# Create the 'variable-substituted' cadabra2 inside the source tree so that we can
# run the tests and pick up cadabra2_defaults.py from there.

configure_file("${PROJECT_SOURCE_DIR}/cadabra2.in"             "${PROJECT_SOURCE_DIR}/cadabra2")

install(PROGRAMS "${PROJECT_SOURCE_DIR}/cadabra2" DESTINATION ${INSTALL_BIN_DIR})

# Create Python dynamic library 'cadabra' without lib prefix.
include_directories(".")
add_library(cadabra2 SHARED ${LOCAL_SRC_FILES})
set_target_properties(cadabra2 PROPERTIES PREFIX "" SUFFIX "${PROJECT_BINARY_RESULT_EXT}" IMPORT_SUFFIX "${PROJECT_BINARY_RESULT_EXT}")
set_target_properties(cadabra2 PROPERTIES PUBLIC_HEADER "${PUBLIC_HEADER_FILES}")
set_target_properties(cadabra2 PROPERTIES IMPORT_SUFFIX ".lib")

if(WIN32)
	# This seems wrong in principle as it should be part of the install target, however it was suggested the install target doesn't support renames
	add_custom_command(TARGET cadabra2
		POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E copy "${PROJECT_BINARY_DIR}/\$(ConfigurationName)/cadabra2${PROJECT_BINARY_RESULT_EXT}" "${CMAKE_INSTALL_PREFIX}/cadabra2.pyd" )
endif()


add_executable(test_preprocessor test_preprocessor.cc PreProcessor.cc)
add_executable(test_multiindex   test_multiindex.cc)
add_executable(cadabra2python cadabra2python.cc CdbPython.cc)
target_link_libraries(cadabra2python ${Boost_LIBRARIES} ${PYTHON_LIBRARIES})

target_link_libraries(cadabra2 ${PCRE_LIBRARIES} ${GMPXX_LIB} ${GMP_LIB} ${Boost_LIBRARIES} ${PYTHON_LIBRARIES})
	
install(DIRECTORY DESTINATION ${INSTALL_BIN_DIR} DIRECTORY_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
                                                        GROUP_READ GROUP_EXECUTE
                                                        WORLD_READ WORLD_EXECUTE)


install(DIRECTORY DESTINATION ${SAFE_PYTHON_SITE_PATH} DIRECTORY_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
                                                        GROUP_READ GROUP_EXECUTE
                                                        WORLD_READ WORLD_EXECUTE)


# Convert packages from cdb to python.
set(PACKAGES
  relativity/__init__
  relativity/schwarzschild
  gauge_theory/__init__
  gauge_theory/instantons
  )
set(PDIRS
  relativity
  gauge_theory
  )
set(PACKAGEDIR  ${CMAKE_BINARY_DIR}/core/packages/cdb)
message("-- Packages built in ${PACKAGEDIR}")
file(MAKE_DIRECTORY ${PACKAGEDIR})
foreach(PDIR ${PDIRS})
   add_custom_target("${PDIR}" ALL
	             COMMAND ${CMAKE_COMMAND} -E make_directory ${PACKAGEDIR}/${PDIR}
                     COMMENT "Creating package ${PDIR}...")
endforeach()

foreach(LIBARRAY ${Boost_LIBRARIES})
	get_filename_component(BOOST_ANOTHER_PATH_DIR ${LIBARRAY} DIRECTORY)
	list(APPEND BOOST_EXTRA_PATH ${BOOST_ANOTHER_PATH_DIR})
endforeach()
list(REMOVE_DUPLICATES BOOST_EXTRA_PATH)
message(" ---- boostextrapath was ${BOOST_EXTRA_PATH}")

foreach(PACKAGE ${PACKAGES})
	string(REGEX REPLACE "/" "_" PACKAGETARGET ${PACKAGE})
	message("--    ${PACKAGETARGET}")				
    if(WIN32)
        # on windows, the path needs to include boost dlls
        add_custom_target("${PACKAGETARGET}" ALL
					  COMMAND set PATH=${BOOST_EXTRA_PATH}\;%PATH%
	                  COMMAND cadabra2python ${CMAKE_SOURCE_DIR}/core/packages/cdb/${PACKAGE}.cdb ${PACKAGEDIR}/${PACKAGE}.py
                     COMMENT "Creating ${PACKAGE}.py...")	  
    else()
        add_custom_target("${PACKAGETARGET}" ALL
			            COMMAND cadabra2python ${CMAKE_SOURCE_DIR}/core/packages/cdb/${PACKAGE}.cdb ${PACKAGEDIR}/${PACKAGE}.py
                     COMMENT "Creating ${PACKAGE}.py...")
    endif()
endforeach()
																		
# Install packages.
set(PYTHON_CDB_PACKAGE_PATH ${SAFE_PYTHON_SITE_PATH}/cdb)
foreach(PACKAGE ${PACKAGES})
  get_filename_component(PINSTALL ${PACKAGE} DIRECTORY)
  install(FILES "${PACKAGEDIR}/${PACKAGE}.py" DESTINATION ${PYTHON_CDB_PACKAGE_PATH}/${PINSTALL})
endforeach()

install(DIRECTORY DESTINATION ${PYTHON_CDB_PACKAGE_PATH} DIRECTORY_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
                                                        GROUP_READ GROUP_EXECUTE
                                                        WORLD_READ WORLD_EXECUTE)

# Install conversion program.
install(TARGETS cadabra2python DESTINATION ${INSTALL_BIN_DIR})

if(WIN32)
	install(FILES ${PCRE_RUNTIMES} DESTINATION ${INSTALL_BIN_DIR})
	install(DIRECTORY ${CMAKE_SOURCE_DIR}/examples DESTINATION ${INSTALL_BIN_DIR})
endif()

