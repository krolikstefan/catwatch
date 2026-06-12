# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "backend/CMakeFiles/kotekwatch-backend_autogen.dir/AutogenUsed.txt"
  "backend/CMakeFiles/kotekwatch-backend_autogen.dir/ParseCache.txt"
  "backend/kotekwatch-backend_autogen"
  "frontend/CMakeFiles/kotekwatch-frontend_autogen.dir/AutogenUsed.txt"
  "frontend/CMakeFiles/kotekwatch-frontend_autogen.dir/ParseCache.txt"
  "frontend/kotekwatch-frontend_autogen"
  )
endif()
