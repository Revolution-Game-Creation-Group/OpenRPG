set(CHARACTER_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/include/character/)

set(CHARACTER_SOURCE
    ${CMAKE_CURRENT_SOURCE_DIR}/character.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/races.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/backgrounds.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/classes.cpp
)

add_library(character SHARED ${CHARACTER_SOURCE})
if(MSVC OR WIN32)
    GENERATE_EXPORT_HEADER(character
        EXPORT_FILE_NAME ${CHARACTER_INCLUDE_DIR}/exports/character_exports.h
        STATIC_DEFINE SHARED_EXPORTS_BUILT_AS_STATIC
    )
endif()

target_link_libraries(character core roll-parser names)

# if the character library needs a higher standard than C++14 please update here
set_property(TARGET character PROPERTY CXX_STANDARD 14)
set_property(TARGET character PROPERTY CXX_STANDARD_REQUIRED ON)

install(TARGETS character
    ARCHIVE DESTINATION ${LIB_INSTALL_DIR}
    LIBRARY DESTINATION ${LIB_INSTALL_DIR}
    RUNTIME DESTINATION ${BIN_INSTALL_DIR}
    COMPONENT Modules
)

set(CG_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/character-generator.cpp
)

add_executable(character-generator ${CG_SOURCES})
target_link_libraries(character-generator core character roll-parser names)

# if the character-generator executable needs a higher standard than C++14 please update here
set_property(TARGET character-generator PROPERTY CXX_STANDARD 14)
set_property(TARGET character-generator PROPERTY CXX_STANDARD_REQUIRED ON)

install(TARGETS character-generator
    DESTINATION ${BIN_INSTALL_DIR}
    COMPONENT Programs
)
