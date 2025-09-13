# Boost configuration for Visual Studio 2022 with Boost 1.82.0
set(BOOST_ROOT "C:/local/boost_1_82_0")
set(Boost_NO_BOOST_CMAKE ON)
set(Boost_USE_STATIC_LIBS ON)
set(Boost_USE_MULTITHREADED ON)
set(Boost_USE_STATIC_RUNTIME ON)

# Force use of vc140 libraries (compatible with vc143)
set(Boost_COMPILER "-vc140")
set(Boost_ARCHITECTURE "-x64")
set(Boost_THREADAPI "win32")

# Set library suffix
set(Boost_LIB_PREFIX "lib")
set(Boost_LIB_SUFFIX "-mt-x64-1_82")

# Add the library directory
set(Boost_LIBRARY_DIRS "${BOOST_ROOT}/lib64-msvc-14.0")
set(Boost_INCLUDE_DIRS "${BOOST_ROOT}")

# Force specific library paths for Visual Studio 2022
set(Boost_FILESYSTEM_LIBRARY_RELEASE "${BOOST_ROOT}/lib64-msvc-14.0/libboost_filesystem-vc143-mt-x64-1_82.lib")
set(Boost_SYSTEM_LIBRARY_RELEASE "${BOOST_ROOT}/lib64-msvc-14.0/libboost_system-vc143-mt-x64-1_82.lib")
set(Boost_PROGRAM_OPTIONS_LIBRARY_RELEASE "${BOOST_ROOT}/lib64-msvc-14.0/libboost_program_options-vc143-mt-x64-1_82.lib")
set(Boost_THREAD_LIBRARY_RELEASE "${BOOST_ROOT}/lib64-msvc-14.0/libboost_thread-vc143-mt-x64-1_82.lib")

# Also set the general library variables
set(Boost_FILESYSTEM_LIBRARY "${BOOST_ROOT}/lib64-msvc-14.0/libboost_filesystem-vc143-mt-x64-1_82.lib")
set(Boost_SYSTEM_LIBRARY "${BOOST_ROOT}/lib64-msvc-14.0/libboost_system-vc143-mt-x64-1_82.lib")
set(Boost_PROGRAM_OPTIONS_LIBRARY "${BOOST_ROOT}/lib64-msvc-14.0/libboost_program_options-vc143-mt-x64-1_82.lib")
set(Boost_THREAD_LIBRARY "${BOOST_ROOT}/lib64-msvc-14.0/libboost_thread-vc143-mt-x64-1_82.lib")
