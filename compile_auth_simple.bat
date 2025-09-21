@echo off
echo ========================================
echo    COMPILACION AZEROTHCORE AUTHSERVER
echo ========================================
echo.

:: Verificar que estamos en el directorio correcto
if not exist "CMakeLists.txt" (
    echo ERROR: No se encontro CMakeLists.txt
    echo Ejecuta este script desde el directorio raiz de AzerothCore
    pause
    exit /b 1
)

:: Crear directorio de build si no existe
if not exist "var\build" mkdir "var\build"
if not exist "bin" mkdir "bin"

:: Ir al directorio de build
cd var\build

:: Verificar si ya existe una compilacion
if exist "CMakeCache.txt" (
    echo Configuracion de CMake encontrada, verificando...
    cmake "..\.." -G "Visual Studio 17 2022" -A x64
    if errorlevel 1 (
        echo ERROR: Fallo en verificacion de CMake
        pause
        exit /b 1
    )
) else (
    echo [1/3] Configurando CMake por primera vez...
    cmake "..\.." -G "Visual Studio 17 2022" -A x64
    if errorlevel 1 (
        echo ERROR: Fallo en configuracion basica de CMake
        pause
        exit /b 1
    )
)

echo [2/3] Configurando opciones de compilacion...
:: Configurar todas las opciones en un solo comando para evitar reconfiguraciones
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX="..\..\bin" -DAPPS_BUILD=auth-only -DTOOLS_BUILD=none -DSCRIPTS=none -DMODULES=none -DBUILD_TESTING=OFF -DUSE_SCRIPTPCH=OFF -DUSE_COREPCH=ON -DWITH_WARNINGS=OFF -DWITH_COREDEBUG=OFF -DWITH_PERFTOOLS=OFF -DWITHOUT_GIT=OFF -DENABLE_VMAP_CHECKS=OFF -DWITH_DYNAMIC_LINKING=OFF -DWITH_STRICT_DATABASE_TYPE_CHECKS=OFF -DWITHOUT_METRICS=ON -DWITH_DETAILED_METRICS=OFF -DBOOST_ROOT="C:\local\boost_1_82_0" -DBoost_INCLUDE_DIR="C:\local\boost_1_82_0" -DBoost_LIBRARY_DIR="C:\local\boost_1_82_0\lib64-msvc-14.0" -DMYSQL_INCLUDE_DIR="C:\Program Files\MySQL\MySQL Server 8.4\include" -DMYSQL_LIBRARY="C:\Program Files\MySQL\MySQL Server 8.4\lib\mysqlclient.lib" -DMYSQL_LIBRARIES="C:\Program Files\MySQL\MySQL Server 8.4\lib\mysqlclient.lib" -C "force_boost.cmake" .

if errorlevel 1 (
    echo ERROR: Fallo en configuracion de opciones
    pause
    exit /b 1
)

:: Copiar librerias de Boost al directorio de build para el linker
echo Copiando librerias de Boost al directorio de build...
if exist "C:\local\boost_1_82_0\lib64-msvc-14.0\libboost_program_options-vc143-mt-x64-1_82.lib" (
    copy "C:\local\boost_1_82_0\lib64-msvc-14.0\libboost_program_options-vc143-mt-x64-1_82.lib" "."
    copy "C:\local\boost_1_82_0\lib64-msvc-14.0\libboost_program_options-vc143-mt-x64-1_82.lib" "src\server\apps\"
    echo ✓ Libreria Boost program_options copiada al directorio de build
)

if exist "C:\local\boost_1_82_0\lib64-msvc-14.0\libboost_system-vc143-mt-x64-1_82.lib" (
    copy "C:\local\boost_1_82_0\lib64-msvc-14.0\libboost_system-vc143-mt-x64-1_82.lib" "."
    copy "C:\local\boost_1_82_0\lib64-msvc-14.0\libboost_system-vc143-mt-x64-1_82.lib" "src\server\apps\"
    echo ✓ Libreria Boost system copiada al directorio de build
)

if exist "C:\local\boost_1_82_0\lib64-msvc-14.0\libboost_filesystem-vc143-mt-x64-1_82.lib" (
    copy "C:\local\boost_1_82_0\lib64-msvc-14.0\libboost_filesystem-vc143-mt-x64-1_82.lib" "."
    copy "C:\local\boost_1_82_0\lib64-msvc-14.0\libboost_filesystem-vc143-mt-x64-1_82.lib" "src\server\apps\"
    echo ✓ Libreria Boost filesystem copiada al directorio de build
)

:: Verificar si ya existe el ejecutable compilado
if exist "..\..\bin\authserver.exe" (
    echo AuthServer ya existe, verificando si necesita recompilacion...
    cmake --build . --config RelWithDebInfo --target authserver --parallel
    if errorlevel 1 (
        echo ERROR: Fallo en la verificacion de compilacion
        pause
        exit /b 1
    )
) else (
    echo [3/3] Compilando AuthServer...
    cmake --build . --config RelWithDebInfo --target authserver --parallel
    if errorlevel 1 (
        echo ERROR: Fallo en la compilacion
        pause
        exit /b 1
    )
)

:: Verificar si la compilacion fallo por librerias de Boost
if not exist "C:\local\boost_1_82_0\lib64-msvc-14.0" (
    echo.
    echo ERROR: No se encontraron librerias de Boost compiladas
    echo Boost debe estar compilado en: C:\local\boost_1_82_0\lib64-msvc-14.0
    echo.
    echo Para compilar Boost:
    echo 1. Abre Developer Command Prompt for VS 2022
    echo 2. cd C:\local\boost_1_82_0
    echo 3. bootstrap.bat
    echo 4. b2 --toolset=msvc-14.3 --architecture=x64 --build-type=complete stage
    echo.
    pause
    exit /b 1
)

:: Verificar librerias especificas de Boost necesarias
if not exist "C:\local\boost_1_82_0\lib64-msvc-14.0\libboost_program_options-vc143-mt-x64-1_82.lib" (
    echo.
    echo ERROR: No se encontro la libreria libboost_program_options-vc143-mt-x64-1_82.lib
    echo.
    echo Librerias disponibles en Boost:
    dir "C:\local\boost_1_82_0\lib64-msvc-14.0\*program_options*" /b 2>nul
    echo.
    echo Asegurate de que Boost este compilado con:
    echo - Toolset: msvc-14.3 (Visual Studio 2022)
    echo - Architecture: x64
    echo - Build type: complete
    echo.
    pause
    exit /b 1
)

:: Verificar que el ejecutable se genero correctamente
if exist "..\..\bin\authserver.exe" (
    echo.
    echo ========================================
    echo    COMPILACION COMPLETADA EXITOSAMENTE
    echo ========================================
    echo.
    echo ✓ AuthServer compilado exitosamente: ..\..\bin\authserver.exe
    
    :: Mostrar informacion del ejecutable
    echo.
    echo Informacion del ejecutable:
    dir "..\..\bin\authserver.exe"
    
    :: Verificar que el ejecutable no este corrupto (tamaño > 0)
    for %%A in ("..\..\bin\authserver.exe") do (
        if %%~zA LSS 1000000 (
            echo ADVERTENCIA: El ejecutable parece muy pequeno, podria estar corrupto
        ) else (
            echo ✓ Ejecutable generado correctamente (%%~zA bytes)
        )
    )
    
    echo.
    echo Archivos generados:
    dir "..\..\bin\*.exe" /b 2>nul
    
) else (
    echo.
    echo ERROR: No se encontro authserver.exe en el directorio de salida
    echo Revisa los logs de compilacion para mas detalles
    pause
    exit /b 1
)

:: Copiar librerias necesarias
echo.
echo Copiando librerias necesarias...

:: Copiar librerias de MySQL
if exist "C:\Program Files\MySQL\MySQL Server 8.4\lib\libmysql.dll" (
    copy "C:\Program Files\MySQL\MySQL Server 8.4\lib\libmysql.dll" "..\..\bin\"
    echo ✓ Libreria MySQL copiada
) else if exist "C:\Program Files\MySQL\MySQL Server 8.4\lib\mysqlclient.dll" (
    copy "C:\Program Files\MySQL\MySQL Server 8.4\lib\mysqlclient.dll" "..\..\bin\"
    echo ✓ Libreria MySQL copiada
) else (
    echo ADVERTENCIA: No se encontro libmysql.dll o mysqlclient.dll
    echo Es posible que necesites copiarla manualmente
)

:: Copiar librerias de Boost necesarias
echo Copiando librerias de Boost...
if exist "C:\local\boost_1_82_0\lib64-msvc-14.0\libboost_program_options-vc143-mt-x64-1_82.lib" (
    copy "C:\local\boost_1_82_0\lib64-msvc-14.0\libboost_program_options-vc143-mt-x64-1_82.lib" "..\..\bin\"
    echo ✓ Libreria Boost program_options copiada
) else (
    echo ADVERTENCIA: No se encontro libboost_program_options-vc143-mt-x64-1_82.lib
)

if exist "C:\local\boost_1_82_0\lib64-msvc-14.0\libboost_system-vc143-mt-x64-1_82.lib" (
    copy "C:\local\boost_1_82_0\lib64-msvc-14.0\libboost_system-vc143-mt-x64-1_82.lib" "..\..\bin\"
    echo ✓ Libreria Boost system copiada
)

if exist "C:\local\boost_1_82_0\lib64-msvc-14.0\libboost_filesystem-vc143-mt-x64-1_82.lib" (
    copy "C:\local\boost_1_82_0\lib64-msvc-14.0\libboost_filesystem-vc143-mt-x64-1_82.lib" "..\..\bin\"
    echo ✓ Libreria Boost filesystem copiada
)

:: Verificar librerias copiadas
echo.
echo Librerias en el directorio bin:
dir "..\..\bin\*.dll" /b 2>nul

echo.
echo Presiona cualquier tecla para salir...
pause >nul
