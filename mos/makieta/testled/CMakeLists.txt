cmake_minimum_required(VERSION 3.13)
include(pico_sdk_import.cmake)
project(ws2812_project C CXX ASM)
pico_sdk_init()

add_executable(ws2812_led main.c)

# Ta linia magicznie kompiluje plik PIO:
pico_generate_pio_header(ws2812_led ${CMAKE_CURRENT_SOURCE_DIR}/ws2812.pio)

target_link_libraries(ws2812_led pico_stdlib hardware_pio)
pico_add_extra_outputs(ws2812_led)
