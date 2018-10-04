# VSpring
Visual studio 3rdparty setup project

### Usage

###### 1. Copy `3rdparty.bat` and `3rdparty.props` into your solution directory.
###### 2. Run `3rdparty.bat`. It will generate below directory structure.

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
│  └ staticlib
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

###### 3. Select `3rdparty.props` on each project.



