#
# Copyright (C) 2022 The Falco Authors.
#
# This file is dual licensed under either the MIT or GPL 2. See
# MIT.txt or GPL.txt for full copies of the license.
#

option(BUILD_BPF "Build the BPF driver on Linux" OFF)

if(BUILD_BPF)
	configure_file(../driver_config.h.in ${CMAKE_CURRENT_SOURCE_DIR}/../driver_config.h)

	add_custom_target(bpf ALL
		COMMAND make
		COMMAND "${CMAKE_COMMAND}" -E copy_if_different probe.o "${CMAKE_CURRENT_BINARY_DIR}"
		WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
		VERBATIM)
endif()

install(FILES
	bpf_helpers.h
	builtins.h
	filler_helpers.h
	fillers.h
	Makefile
	maps.h
	plumbing_helpers.h
	probe.c
	quirks.h
	ring_helpers.h
	types.h
	DESTINATION "src/${DRIVER_PACKAGE_NAME}-${DRIVER_VERSION}/bpf"
	COMPONENT ${DRIVER_COMPONENT_NAME})
