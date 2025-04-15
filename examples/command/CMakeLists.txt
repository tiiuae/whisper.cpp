if (WHISPER_SDL2)
    set(TARGET whisper-command)
    add_executable(${TARGET} command.cpp)

    include(DefaultTargetOptions)

    find_library(NATS_LIB
        NAMES nats libnats
        PATHS /usr/local/lib
              /usr/lib
              /usr/lib/x86_64-linux-gnu
        REQUIRED
    )

    find_path(NATS_INCLUDE_DIR
        NAMES nats/nats.h
        PATHS /usr/local/include
              /usr/include
        REQUIRED
    )

    message(STATUS "Found NATS library: ${NATS_LIB}")
    message(STATUS "Found NATS include: ${NATS_INCLUDE_DIR}")

    target_link_libraries(${TARGET} PRIVATE 
        common 
        common-sdl 
        whisper 
        ${CMAKE_THREAD_LIBS_INIT}
        ${NATS_LIB}
    )

    target_include_directories(${TARGET} PRIVATE 
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${NATS_INCLUDE_DIR}
    )

    install(TARGETS ${TARGET} RUNTIME)
endif ()
