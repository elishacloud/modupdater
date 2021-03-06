-- modupdater
workspace "modupdater"
   configurations { "Release", "Debug" }
   location "build"
   
   defines { "rsc_CompanyName=\"ThirteenAG\"" }
   defines { "rsc_LegalCopyright=\"MIT License\""} 
   defines { "rsc_FileVersion=\"1.0.0.0\"", "rsc_ProductVersion=\"1.0.0.0\"" }
   defines { "rsc_InternalName=\"%{prj.name}\"", "rsc_ProductName=\"%{prj.name}\"", "rsc_OriginalFilename=\"%{prj.name}.asi\"" }
   defines { "rsc_FileDescription=\"https://thirteenag.github.io/wfp\"" }
   defines { "rsc_UpdateUrl=\"https://github.com/ThirteenAG/modupdater\"" }
   
   files { "source/Header Files/*.h" }
   files { "source/Source Files/*.cpp", "source/Source Files/*.c" }
   
   files { "source/Includes/Resources/*.rc" }
   
   files { "external/cpr/cpr/*.cpp" }
   files { "external/jsoncpp/src/lib_json/*.cpp" }
   files { "external/zipper/zipper/*.cpp" }
   files { "external/minizip/*.cpp" }
   
   includedirs { "source/Header Files/" }
   includedirs { "external/inireader" }
   includedirs { "external/curl/builds/libcurl-vc-x86-release-static-ipv6-sspi-winssl/include" }
   includedirs { "external/cpr/include" }
   includedirs { "external/date/include/date" }
   includedirs { "external/jsoncpp/include" }
   includedirs { "external/zipper/zipper" }
   includedirs { "external/minizip" }
   includedirs { "external/zlib" }
   
   libdirs { "source/Includes/Libs" }
   libdirs { "external/curl/builds/libcurl-vc-x86-release-static-ipv6-sspi-winssl/lib" }
   
   links { "version.lib" }
   links { "zlibstat.lib" }
   links { "libZipper-static.lib" }
   links { "libcurl_a.lib" }
   defines { "CURL_STATICLIB", "WIN32" }
   
    prebuildcommands {
        "msbuild ../build/libZipper.sln /t:zlibstat /p:Configuration=ReleaseWithoutAsm /p:Platform=Win32",
        "msbuild ../build/libZipper.sln /t:libZipper-static /p:Configuration=ReleaseWithoutAsm /p:Platform=Win32",
        "cd ../external/curl/winbuild/",
        "nmake /f Makefile.vc mode=static RTLIBCFG=static ENABLE_IDN=no"
    }

project "UpdaterApp"
   kind "ConsoleApp"
   language "C++"
   targetdir "bin/%{cfg.buildcfg}"
   targetname "modupdater"
   targetextension ".exe"

   filter "configurations:Debug"
      defines { "DEBUG" }
      symbols "On"
      flags { "StaticRuntime" }
      characterset ("MBCS")

   filter "configurations:Release"
      defines { "NDEBUG" }
      optimize "On"
      flags { "StaticRuntime" }
      characterset ("MBCS")
      
      
project "UpdaterPlugin"
   kind "SharedLib"
   language "C++"
   targetdir "bin/%{cfg.buildcfg}"
   targetname "modupdater"
   targetextension ".asi"

   filter "configurations:Debug"
      defines { "DEBUG" }
      symbols "On"
      flags { "StaticRuntime" }
      characterset ("MBCS")

   filter "configurations:Release"
      defines { "NDEBUG" }
      optimize "On"
      flags { "StaticRuntime" }
      characterset ("MBCS")
      
      
      
-- libZipper
workspace "libZipper"
   configurations { "ReleaseWithoutAsm", "Debug" }
   location "build"
   ignoredefaultlibraries { "MSVCRT" }
   
project "zlibstat"
   kind "StaticLib"
   language "C++"
   targetdir "source/Includes/Libs"
   targetextension ".lib"
   
   files { "external/zlib/*.h", "external/zlib/*.c" }
   files { "external/zlib/contrib/vstudio/vc14/zlib.rc" }
   files { "external/zlib/contrib/vstudio/vc14/zlibvc.def" }
   removefiles { "inffas8664.c" }
      
   defines { "WIN32;_CRT_NONSTDC_NO_DEPRECATE;_CRT_SECURE_NO_DEPRECATE;_CRT_NONSTDC_NO_WARNINGS;" }

   filter "configurations:Debug"
      defines { "DEBUG" }
      symbols "On"
      characterset ("MBCS")

   filter "configurations:ReleaseWithoutAsm"
      defines { "NDEBUG" }
      optimize "On"
      flags { "StaticRuntime" }
      characterset ("MBCS")
      
project "libZipper-static"
   kind "StaticLib"
   language "C++"
   targetdir "source/Includes/Libs"
   targetextension ".lib"
   
   files { "external/zipper/zipper/*.h", "external/zipper/zipper/*.cpp" }
   files { "external/minizip/crypt.h" }
   files { "external/minizip/ioapi.h" }
   files { "external/minizip/ioapi_buf.h" }
   files { "external/minizip/ioapi_mem.h" }
   files { "external/minizip/iowin32.h" }
   files { "external/minizip/unzip.h" }
   files { "external/minizip/zip.h" }
   files { "external/minizip/ioapi.c" }
   files { "external/minizip/ioapi_buf.c" }
   files { "external/minizip/ioapi_mem.c" }
   files { "external/minizip/iowin32.c" }
   files { "external/minizip/unzip.c" }
   files { "external/minizip/zip.c" }
   includedirs { "external/minizip" }
   includedirs { "external/zlib/" }
   includedirs { "external/zipper/zipper" }
      
   defines { "WIN32;_WINDOWS;NDEBUG;USE_ZLIB;_CRT_SECURE_NO_WARNINGS;_CRT_NONSTDC_NO_DEPRECATE;" }

   filter "configurations:Debug"
      defines { "DEBUG" }
      symbols "On"
      characterset ("MBCS")

   filter "configurations:ReleaseWithoutAsm"
      defines { "NDEBUG" }
      optimize "On"
      flags { "StaticRuntime" }
      characterset ("MBCS")