# VSpring
Visual studio setup project

### What is this

This is **Visual Studio** setting project.

It apply automatically **Additional library path** and copy  **dll** files to location of **exe** file. And set working directory as **$(OutDir)**.

### Support platform
* `Windows 10 x64`
* `Visual Studio 2015`
* `x86/Debug`, `x86/Release`, `x64/Debug`, `x64/Release`

### How to use

##### 1. Install vspring
Download [install_vspring.exe](https://www.dropbox.com/s/9s3f6lhrxiib2cy/install_vspring.exe?dl=1) and run as administrator follow this command.
```
git clone https://github.com/springkim/VSpring
cd VSpring
install_vspring.exe
```

##### 2.Apply to project
There is a **VSpring32.props** and **VSpring64.props** is in the same directory, When you finished install.

Make project whatever you want.
![](https://i.imgur.com/DkMLJhT.png)

Copy **VSpring32.props** and **VSpring64.props** into **Solution directory**.
![](https://i.imgur.com/Bw1nimK.png)

Open **Property Manager** and append **VSpring??.props** according to your project platform.
![](https://i.imgur.com/kWvEPHf.png)

Put include `#include<VSpring>` on your source file. And build.

Then **VSpring** is change your project property. So the visual studio will show message about reload.

It shows only once. Click **Reload All**.
![](https://i.imgur.com/vhw6PsM.png)

Follow this rule if you want use 3rdparty library.

```
Solution Directory
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
│  └ include
│  
├ Solution.sln
├ VSpring32.props
└ VSpring64.props
```
There is a sample project with opencv library in git reposotory.



