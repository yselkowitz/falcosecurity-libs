#
# libcurl
#
option(USE_BUNDLED_CURL "Enable building of the bundled curl" ${USE_BUNDLED_DEPS})

include(openssl)
include(zlib)

if(CURL_INCLUDE_DIRS)
	# we already have curl
elseif(NOT USE_BUNDLED_CURL)
	find_package(CURL REQUIRED)
	message(STATUS "Found CURL: include: ${CURL_INCLUDE_DIRS}, lib: ${CURL_LIBRARIES}")
else()
	set(CURL_BUNDLE_DIR "${PROJECT_BINARY_DIR}/curl-prefix/src/curl")
	set(CURL_INCLUDE_DIRS "${CURL_BUNDLE_DIR}/include/")
	set(CURL_LIBRARIES "${CURL_BUNDLE_DIR}/lib/.libs/libcurl.a")

	if(NOT USE_BUNDLED_OPENSSL)
		set(CURL_SSL_OPTION "--with-ssl")
	else()
		set(CURL_SSL_OPTION "--with-ssl=${OPENSSL_INSTALL_DIR}")
		message(STATUS "Using bundled curl in '${CURL_BUNDLE_DIR}'")
		message(STATUS "Using SSL for curl in '${CURL_SSL_OPTION}'")
	endif()

	if(NOT TARGET curl)
		ExternalProject_Add(
			curl
			PREFIX "${PROJECT_BINARY_DIR}/curl-prefix"
			DEPENDS openssl zlib
			URL "https://github.com/curl/curl/releases/download/curl-7_83_1/curl-7.83.1.tar.bz2"
			URL_HASH "SHA256=f539a36fb44a8260ec5d977e4e0dbdd2eee29ed90fcedaa9bc3c9f78a113bff0"
			CONFIGURE_COMMAND
			./configure
			${CURL_SSL_OPTION}
			--disable-shared
			--enable-optimize
			--disable-curldebug
			--disable-rt
			--enable-http
			--disable-ftp
			--disable-file
			--disable-ldap
			--disable-ldaps
			--disable-rtsp
			--disable-telnet
			--disable-tftp
			--disable-pop3
			--disable-imap
			--disable-smb
			--disable-smtp
			--disable-gopher
			--disable-sspi
			--disable-ntlm-wb
			--disable-tls-srp
			--without-winssl
			--without-polarssl
			--without-cyassl
			--without-nss
			--without-axtls
			--without-ca-path
			--without-ca-bundle
			--without-librtmp
			--without-winidn
			--without-libidn2
			--without-libpsl
			--without-nghttp2
			--without-libssh2
			--disable-threaded-resolver
			--without-brotli
			--without-zstd
			BUILD_COMMAND ${CMD_MAKE}
			BUILD_IN_SOURCE 1
			BUILD_BYPRODUCTS ${CURL_LIBRARIES}
			INSTALL_COMMAND "")
		install(FILES "${CURL_LIBRARIES}" DESTINATION "${CMAKE_INSTALL_LIBDIR}/${LIBS_PACKAGE_NAME}")
		install(DIRECTORY "${CURL_INCLUDE_DIRS}curl" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${LIBS_PACKAGE_NAME}"
			FILES_MATCHING PATTERN "*.h")
	endif()
endif()

include_directories("${CURL_INCLUDE_DIRS}")
