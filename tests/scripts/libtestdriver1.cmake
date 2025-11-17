execute_process(
    COMMAND ${TF_PSA_CRYPTO_PYTHON_EXECUTABLE}
            ./tests/scripts/generate_test_driver.py
            ${CMAKE_CURRENT_BINARY_DIR}
            --list-vars-for-cmake
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    RESULT_VARIABLE result)
if(result)
    message(FATAL_ERROR "Generation of list-vars.cmake failed: ${result}")
endif()

include(${CMAKE_CURRENT_BINARY_DIR}/libtestdriver1-list-vars.cmake)

set(input_files "")
foreach(relpath IN LISTS libtestdriver1_input_files)
    list(APPEND input_files ${PROJECT_SOURCE_DIR}/${relpath})
endforeach()

add_custom_command(
    OUTPUT ${libtestdriver1_files}
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    COMMAND
        ${TF_PSA_CRYPTO_PYTHON_EXECUTABLE}
            ./tests/scripts/generate_test_driver.py ${CMAKE_CURRENT_BINARY_DIR}
    DEPENDS ${PROJECT_SOURCE_DIR}/tests/scripts/generate_test_driver.py
            ${input_files}
    COMMENT "Generating test driver libtestdriver1 tree"
)

add_custom_target(tf_psa_crypto_test_driver_src
    DEPENDS ${libtestdriver1_files})

set(tf_psa_crypto_driver "libtestdriver1")
include(${PROJECT_SOURCE_DIR}/drivers/driver.cmake)
