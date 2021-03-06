# GTKMM 
# GTKMM3_BUNDLE_INCLUDE_DIR_SEARCH
# GTKMM3_BUNDLE_LIBRARIES_SEARCH
# TODO: based on the file structure, these should be able to be combined and then the specific subdirectory can be used as hint (or not!)
# TODO: This could also be setup to be like two lists, of h files and lib/dll files, and then make it a little more procedural


if(WIN32)
	message("--- Looking for gtkmm dependencies in ${GTKMM3_BUNDLE_INCLUDE_DIR_SEARCH} and ${GTKMM3_BUNDLE_LIBRARIES_SEARCH}")
	
	find_path(GLIBMM_INCLUDE_DIR NAMES glibmm.h
				HINTS ${GTKMM3_BUNDLE_INCLUDE_DIR_SEARCH}
				PATH_SUFFIXES glibmm-2.4
				DOC "GLIB includes directory (contains glib.h)"
				)
	find_library(GLIBMM_LIBRARIES NAMES glibmm-2.4.lib
				HINTS ${GTKMM3_BUNDLE_LIBRARIES_SEARCH}
				DOC "GLIB libraries directory (contains gtkmm-3.0.lib)")
	find_file(GLIBMM_RUNTIMES NAMES glibmm-2.4.dll
				HINTS "${GTKMM3_BUNDLE_LIBRARIES_SEARCH}/../bin"
				)

	find_path(ATKMM_INCLUDE_DIR NAMES atkmm.h
				HINTS ${GTKMM3_BUNDLE_INCLUDE_DIR_SEARCH}
				PATH_SUFFIXES atkmm-1.6
				DOC "ATK includes directory (contains atk.h)"
				)
	find_library(ATKMM_LIBRARIES NAMES atkmm-1.6.lib
				HINTS ${GTKMM3_BUNDLE_LIBRARIES_SEARCH}
				DOC "ATK libraries directory (contains gtkmm-3.0.lib)")
	find_file(ATKMM_RUNTIMES NAMES atkmm-1.6.dll
				HINTS "${GTKMM3_BUNDLE_LIBRARIES_SEARCH}/../bin"
				)

	find_path(PANGOMM_INCLUDE_DIR NAMES pangomm.h
				HINTS ${GTKMM3_BUNDLE_INCLUDE_DIR_SEARCH}
				PATH_SUFFIXES pangomm-1.4
				DOC "PANGO includes directory (contains pango.h)"
				)
	find_library(PANGOMM_LIBRARIES NAMES pangomm-1.4.lib
				HINTS ${GTKMM3_BUNDLE_LIBRARIES_SEARCH}
				DOC "PANGO libraries directory (contains gtkmm-3.0.lib)")
	find_file(PANGOMM_RUNTIMES NAMES pangomm-1.4.dll
				HINTS "${GTKMM3_BUNDLE_LIBRARIES_SEARCH}/../bin"
				)

	find_path(GIOMM_INCLUDE_DIR NAMES giomm.h
				HINTS ${GTKMM3_BUNDLE_INCLUDE_DIR_SEARCH}
				PATH_SUFFIXES giomm-2.4
				DOC "GIO includes directory (contains gwin32inputstream.h)"
				)
	find_library(GIOMM_LIBRARIES NAMES giomm-2.4.lib
				HINTS ${GTKMM3_BUNDLE_LIBRARIES_SEARCH}
				DOC "GIO libraries directory (contains gtkmm-3.0.lib)")
	find_file(GIOMM_RUNTIMES NAMES giomm-2.4.dll
				HINTS "${GTKMM3_BUNDLE_LIBRARIES_SEARCH}/../bin"
				)

	find_path(CAIROMM_INCLUDE_DIR NAMES cairomm.h
				PATH_SUFFIXES cairomm-1.0
				HINTS ${GTKMM3_BUNDLE_INCLUDE_DIR_SEARCH}
				DOC "CAIRO includes directory (contains cairo.h)"
				)
	find_library(CAIROMM_LIBRARIES NAMES cairomm-1.0.lib
				HINTS ${GTKMM3_BUNDLE_LIBRARIES_SEARCH}
				DOC "CAIRO libraries directory (contains gtkmm-3.0.lib)")
	find_file(CAIROMM_RUNTIMES NAMES cairomm-1.0.dll
				HINTS "${GTKMM3_BUNDLE_LIBRARIES_SEARCH}/../bin"
				)

	find_path(SIGCPP_INCLUDE_DIR NAMES sigc++/sigc++.h
				HINTS ${GTKMM3_BUNDLE_INCLUDE_DIR_SEARCH}
				PATH_SUFFIXES sigc++-2.0
				DOC "GTK includes directory (contains gtk.h)"
				)
	find_library(SIGCPP_LIBRARIES NAMES sigc-2.0.lib
				HINTS ${GTKMM3_BUNDLE_LIBRARIES_SEARCH}
				DOC "GTK libraries directory (contains gtk-3.0.lib)")
	find_file(SIGCPP_RUNTIMES NAMES sigc-2.0.dll
				HINTS "${GTKMM3_BUNDLE_LIBRARIES_SEARCH}/../bin"
				)

	find_path(GDKMM_INCLUDE_DIR NAMES gdkmm.h
				HINTS ${GTKMM3_BUNDLE_INCLUDE_DIR_SEARCH}
				PATH_SUFFIXES gdkmm-3.0
				DOC "GDKPIXBUF includes directory (contains gdk-pixbuf.h)"
				)
	find_library(GDKMM_LIBRARIES NAMES gdkmm-3.0.lib
				HINTS ${GTKMM3_BUNDLE_LIBRARIES_SEARCH}
				DOC "GDKPIXBUF libraries directory (contains gtkmm-3.0.lib)")
	find_file(GDKMM_RUNTIMES NAMES gdkmm-3.0.dll
				HINTS "${GTKMM3_BUNDLE_LIBRARIES_SEARCH}/../bin"
				)
	
	find_path(GTKMM_INCLUDE_DIR NAMES gtkmm.h
				HINTS ${GTKMM3_BUNDLE_INCLUDE_DIR_SEARCH}
				PATH_SUFFIXES gtkmm-3.0
				DOC "GTK includes directory (contains gtk.h)"
				)
	find_library(GTKMM_LIBRARIES NAMES gtkmm-3.0.lib
				HINTS ${GTKMM3_BUNDLE_LIBRARIES_SEARCH}
				DOC "GTK libraries directory (contains gtk-3.0.lib)")
	find_file(GTKMM_RUNTIMES NAMES gtkmm-3.0.dll
				HINTS "${GTKMM3_BUNDLE_LIBRARIES_SEARCH}/../bin"
				)
				
	set(GTKMM3_INCLUDE_DIR "${CAIROMM_INCLUDE_DIR};${GIOMM_INCLUDE_DIR};${PANGOMM_INCLUDE_DIR};${ATKMM_INCLUDE_DIR};${GLIBMM_INCLUDE_DIR};${SIGCPP_INCLUDE_DIR};${GDKMM_INCLUDE_DIR};${GTKMM_INCLUDE_DIR}")

	set(GTKMM3_LIBRARIES "${CAIROMM_LIBRARIES};${GIOMM_LIBRARIES};${PANGOMM_LIBRARIES};${ATKMM_LIBRARIES};${GLIBMM_LIBRARIES};${SIGCPP_LIBRARIES};${GDKMM_LIBRARIES};${GTKMM_LIBRARIES}")
	
	set(GTKMM3_RUNTIMES "${CAIROMM_RUNTIMES};${GIOMM_RUNTIMES};${PANGOMM_RUNTIMES};${ATKMM_RUNTIMES};${GLIBMM_RUNTIMES};${SIGCPP_RUNTIMES};${GDKMM_RUNTIMES};${GTKMM_RUNTIMES}")

else()	
	find_package(PkgConfig REQUIRED)
	pkg_check_modules(GTKMM3 gtkmm-3.0)
endif()

find_package_handle_standard_args(GTKMM3 DEFAULT_MSG GTKMM3_INCLUDE_DIR GTKMM3_LIBRARIES GTKMM3_RUNTIMES)

if(GTKMM3_FOUND)
	message("--- Found GTKMM3 so we have includes:${GTKMM3_INCLUDE_DIR} and libs:${GTKMM3_LIBRARIES} and runtimes:${GTKMM3_RUNTIMES}")
else()
	message("--- Missing GTKMM3!!  we have includes:${GTKMM3_INCLUDE_DIR} and libs:${GTKMM3_LIBRARIES} and runtimes:${GTKMM3_RUNTIMES}")
endif()
