set(drivers
    builtin
    everest
    p256-m
)

# Directories containing the headers exposed by drivers
set(TF_PSA_CRYPTO_DRIVERS_INCLUDE_DIRS
        ${CMAKE_CURRENT_SOURCE_DIR}/builtin/include
        ${CMAKE_CURRENT_SOURCE_DIR}/everest/include
        ${CMAKE_CURRENT_SOURCE_DIR}/p256-m
)

set(TF_PSA_CRYPTO_DRIVERS "${drivers}" PARENT_SCOPE)
set(TF_PSA_CRYPTO_DRIVERS_INCLUDE_DIRS "${TF_PSA_CRYPTO_DRIVERS_INCLUDE_DIRS}" PARENT_SCOPE)

if(CMAKE_COMPILER_IS_MSVC)
    if(MSVC_STATIC_RUNTIME)
        foreach(flag_var
            CMAKE_C_FLAGS CMAKE_C_FLAGS_DEBUG CMAKE_C_FLAGS_RELEASE
            CMAKE_C_FLAGS_MINSIZEREL CMAKE_C_FLAGS_RELWITHDEBINFO
            CMAKE_C_FLAGS_CHECK)
            string(REGEX REPLACE "/MD" "/MT" ${flag_var} "${${flag_var}}")
        endforeach(flag_var)
    endif()
endif()

set(driver_targets "")
foreach(driver ${drivers})
    list(APPEND driver_targets "${TF_PSA_CRYPTO_TARGET_PREFIX}${driver}")
endforeach()

if (USE_STATIC_TF_PSA_CRYPTO_LIBRARY)
    if(NOT USE_SHARED_TF_PSA_CRYPTO_LIBRARY)
        set(driver_static_targets ${driver_targets})
    else()
        set(driver_static_targets "")
        foreach(target ${driver_targets})
            list(APPEND driver_static_targets "${target}_static")
        endforeach()
    endif()
endif()
set(TF_PSA_CRYPTO_DRIVER_STATIC_TARGETS "${driver_static_targets}" PARENT_SCOPE)
set(TF_PSA_CRYPTO_DRIVER_TARGETS "${driver_targets}" PARENT_SCOPE)

add_subdirectory(everest)
add_subdirectory(p256-m)
add_subdirectory(builtin)
