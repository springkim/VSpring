# VSpring
Visual studio setup project

### What is this

This is the **Visual Studio** setting project.

It apply **Additional library path** and copy  **dll** files to location of **exe** file  automatically. And set working directory as **$(OutDir)**.

### Support platform
* `Windows 10 x64`
* `Visual Studio 2015`
* `x86/Debug`, `x86/Release`, `x64/Debug`, `x64/Release`

### How to use

##### 1. Install vspring
Download [install_vspring.exe](https://www.dropbox.com/s/9s3f6lhrxiib2cy/install_vspring.exe?dl=1) and run as administrator or follow this command.
```
git clone https://github.com/springkim/VSpring
cd VSpring
install_vspring.exe
```

##### 2.Apply to project
Both **VSpring32.props** and **VSpring64.props** are in the same directory, When All the installation are finished.

First, Make any project whatever you want.
![](https://i.imgur.com/DkMLJhT.png)

Second, Copy both **VSpring32.props** and **VSpring64.props** into **Solution directory**.
![](https://i.imgur.com/Bw1nimK.png)

Third, Open **Property Manager** and append the **VSpring??.props** according to your project platform.
![](https://i.imgur.com/kWvEPHf.png)

Finally, Put `#include<VSpring>` on your source file. And build.

Then **VSpring** changes your project property. So, Visual studio will show message about reload.

It shows only once. Click **Reload All**.
![](https://i.imgur.com/vhw6PsM.png)

If you want use 3rdparty library, Follow this rule.

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



