# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/KotekWatch_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/KotekWatch_autogen.dir/ParseCache.txt"
  "KotekWatch_autogen"
  )
endif()
