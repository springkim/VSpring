/*
*  install.cpp
*  VSpring
*
*  Created by kimbom on 2017. 9. 3...
*  Copyright 2017 kimbom. All rights reserved.
*
*/
#include<iostream>
#include<Windows.h>
#include<string>
#include<vector>
#include<urlmon.h>            //URLDownloadToFileA
#pragma comment(lib,"urlmon.lib")
#include <Shlwapi.h>
#pragma comment(lib, "Shlwapi.lib")
BOOL IsUserAdmin(void) {
	BOOL b;
	SID_IDENTIFIER_AUTHORITY NtAuthority = SECURITY_NT_AUTHORITY;
	PSID AdministratorsGroup;
	b = AllocateAndInitializeSid(&NtAuthority, 2, SECURITY_BUILTIN_DOMAIN_RID
								 , DOMAIN_ALIAS_RID_ADMINS
								 , 0, 0, 0, 0, 0, 0, &AdministratorsGroup);
	if (b) {
		if (!CheckTokenMembership(NULL, AdministratorsGroup, &b)) {
			b = FALSE;
		}
		FreeSid(AdministratorsGroup);
	}
	return b;
}

BOOL Is64BitWindows() {
#if defined(_WIN64)
	return TRUE;  // 64-bit programs run only on Win64
#elif defined(_WIN32)
	// 32-bit programs run on both 32-bit and 64-bit Windows
	// so must sniff
	BOOL f64 = FALSE;
	return IsWow64Process(GetCurrentProcess(), &f64) && f64;
#else
	return FALSE; // Win64 does not support Win16
#endif
}

bool DownloadToSystem(std::string url, std::string file) {
	std::cout << "Downloading " << file << "..." << std::endl;
	HRESULT r=URLDownloadToFileA(nullptr, url.c_str(), file.c_str(), 0, 0);
	return r == S_OK;
}
int main() {
	std::cout << "Check permission..." << std::endl;
	if (IsUserAdmin() == FALSE) {
		std::cerr << "Please run as administrator." << std::endl;
		system("pause");
		return EXIT_FAILURE;
	} else {
		bool succ = true;
		succ&=DownloadToSystem("https://www.dropbox.com/s/2dln3ogvaa5koy0/VSpringLibProps_x86.exe?dl=1", "C:\\Windows\\syswow64\\VSpringLibProps_x86.exe");
		succ&=DownloadToSystem("https://www.dropbox.com/s/t6uxerlv6lrucp6/VSpring?dl=1", "C:\\Program Files (x86)\\Microsoft Visual Studio 14.0\\VC\\include\\VSpring");
		std::cout << "VSpring32.props download..." << std::endl;
		URLDownloadToFileA(nullptr, "https://www.dropbox.com/s/d8c5aet2n42wdi5/VSpring32.props?dl=1", "VSpring32.props", 0, 0);
		std::cout << "VSpring64.props download..." << std::endl;
		URLDownloadToFileA(nullptr, "https://www.dropbox.com/s/ljus2o67wupnh5p/VSpring64.props?dl=1", "VSpring64.props", 0, 0);
		if (succ) {
			std::cout << "Complete!" << std::endl;
		} else {
			std::cout << "Fail!" << std::endl;
		}
	}
	system("pause");
	return EXIT_SUCCESS;
}