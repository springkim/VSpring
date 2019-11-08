# VSpring
This project will help you add libraries to Visual C++ more easily.

### Files

1. **3rdparty.bat** file creates a 3rdparty structure. The details are listed below.

2. **3rdparty.props** is a file to be added in Visual Studio's Properties Manager.

3. **libdownload.bat** file installs a library that has already been built for use in the current project.

4. **vspring.bat** creates **vspring.h**. Please enter only `#include<vspring.h>` without linking the library from IDE.

### Usage

1. Copy all files from this store to the location where the sln file is located.

2. Run **3rdparty.bat** if you are using the library directly.
If you are using a other library, run **local_install.bat** to install the library.
Running the **3rdparty.bat** file creates the following directory:

3. Add **3rdparty.props** in the Properties Manager of Visual Studio.

4. Run the **vspring.bat** file and specify `#include<vspring.h>` in the project file.

```
┌ 3rdparty
│  ├ bin
│  │  ├ x64         (x64 Debug/Release dll)
│  │  │  ├ Debug    (x64 Debug only dll)
│  │  │  └ Release  (x64 Release only dll)
│  │  └ x86         (x86 Debug/Release dll)
│  │     ├ Debug    (x86 Debug only dll)
│  │     └ Release  (x86 Release only dll)
│  ├ lib
│  │  ├ x64         (x64 Debug/Release lib)
│  │  │  ├ Debug    (x64 Debug only lib)
│  │  │  └ Release  (x64 Release only lib)
│  │  └ x86         (x86 Debug/Release lib)
│  │     ├ Debug    (x86 Debug only lib)
│  │     └ Release  (x86 Release only lib)
│  ├ include
│  └ staticlib$(PlatformToolsetVersion)
│     ├ x64         (x64 Debug/Release static lib)
│     │  ├ Debug    (x64 Debug only static lib)
│     │  └ Release  (x64 Release only static lib)
│     └ x86         (x86 Debug/Release static lib)
│        ├ Debug    (x86 Debug only static lib)
│        └ Release  (x86 Release only static lib)
│  
├ Solution.sln
└ 3rdparty.props
```

### Comments

`$(PlatformToolsetVersion)` 120,140,141

https://github.com/cisco/openh264

 
