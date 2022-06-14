workspace "MarchingCubesShader"
	architecture "x64"
	startproject "MarchingCubesShader"
	
		configurations
	{
		"Debug",
		"Release",
		"Dist"
	}
outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

IncludeDir = {}
IncludeDir["GLFW"] = "MarchingCubesShader/vendor/GLFW/include"
IncludeDir["Glad"] = "MarchingCubesShader/vendor/Glad/include"
IncludeDir["glm"] = "MarchingCubesShader/vendor/glm"

group "Dependencies"
		include "MarchingCubesShader/vendor/GLFW"
		include "MarchingCubesShader/vendor/Glad"
group ""

project "MarchingCubesShader"
	location "MarchingCubesShader"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++17"
	staticruntime "on"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")
	
		files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
		"%{prj.name}/*.h",
		"%{prj.name}/*.hpp",
		"%{prj.name}/*.cpp",
		"%{prj.name}/*.fs",
		"%{prj.name}/*.gs",
		"%{prj.name}/*.vs",
		"%{prj.name}/vendor/glm/glm/**.hpp",
		"%{prj.name}/vendor/glm/glm/**.h",
		"%{prj.name}/vendor/glm/glm/**.inl"
	}
	
	includedirs
	{
		"%{prj.name}/src",
		"%{prj.name}/vendor/spdlog/include",
		"%{IncludeDir.GLFW}",
		"%{IncludeDir.Glad}",
		"%{IncludeDir.glm}"
	}
	
		links
	{
		"GLFW",
		"Glad",
		"opengl32.lib",
	}
	
	
	filter "system:windows"
		systemversion "latest"
		
		defines{
			"GLFW_INCLUDE_NONE"
		}
		
	filter "configurations:Debug"
		defines "SU_DEBUG"
		buildoptions "/MDd"
		symbols "on"
	filter "configurations:Release"
		defines "SU_RELEASE"
		buildoptions "/MD"
		optimize "on"
	filter "configurations:Dist"
		defines "SU_DIST"
		buildoptions "/MD"
		optimize "on"