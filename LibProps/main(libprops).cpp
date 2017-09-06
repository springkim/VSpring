/*
*  main.cpp
*  VSpring(LibProps)
*
*  Created by kimbom on 2017. 9. 3...
*  Copyright 2017 kimbom. All rights reserved.
*
*/
#include<iostream>
#include<fstream>
#include<string>
#include<vector>
#include<map>
#include<array>
#include<algorithm>
#include<Windows.h>
#include<minwinbase.h>	//WIN32_FIND_DATAA
#include<minwindef.h>	//HANDLE
#include<fileapi.h>		//FindFirstFileA
#include<set>
#include"tinyxml2.h"
std::vector<std::string> libpath;
std::vector<std::string> GetLibFiles(std::string dir) {
	std::vector<std::string> ret;
	if (dir.back() != '/' && dir.back() != '\\') {
		dir.push_back('\\');
	}
	WIN32_FIND_DATAA fd;
	HANDLE hFind = ::FindFirstFileA(std::string(dir + "*.lib").c_str(), &fd);
	if (hFind == INVALID_HANDLE_VALUE) {
		return ret;
	}
	do {
		if (!(fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)) {
			ret.push_back(fd.cFileName);
		}
	} while (::FindNextFileA(hFind, &fd));
	::FindClose(hFind);
	return ret;
}
std::set<std::string> _GetLibFiles(std::vector<std::string> dirs) {
	std::set<std::string> ret;
	ret.insert("%(AdditionalDependencies)");
	for (auto&dir : dirs) {
		std::vector<std::string> files = GetLibFiles(dir);
		for (auto&file : files) {
			ret.insert(file);
		}
	}
	return ret;
}
std::string replace_all(
	__in const std::string &message,
	__in const std::string &pattern,
	__in const std::string &replace
) {

	std::string result = message;
	std::string::size_type pos = 0;
	std::string::size_type offset = 0;

	while ((pos = result.find(pattern, offset)) != std::string::npos) {
		result.replace(result.begin() + pos, result.begin() + pos + pattern.size(), replace);
		offset = pos + replace.size();
	}

	return result;
}
bool InsertAdditionalLibsToXML(tinyxml2::XMLElement* e,std::string exists, std::string thirdparty,std::string attr) {	
	//return true is update
	//return false is non-update
	std::string token = ";";
	std::set<std::string> before,after;
	std::string::size_type offset = 0;
	while (offset<exists.length()) {
		std::string str = exists.substr(offset, exists.find(token, offset) - offset);
		while (str.front() == ' ')str.erase(0);
		while (str.back() == ' ')str.pop_back();
		before.insert(str);
		offset += str.length() + 1;
	}
	if (attr.find("Win32") != attr.npos) {
		if (attr.find("Debug") != attr.npos) {
			after = _GetLibFiles({thirdparty+"x86/Debug/",thirdparty+"x86/"});
		} else if(attr.find("Release")!=attr.npos){
			after = _GetLibFiles({ thirdparty + "x86/Release/",thirdparty + "x86/" });
		} else {
			return false;
		}
	} else if (attr.find("x64") != attr.npos) {
		if (attr.find("Debug") != attr.npos) {
			after = _GetLibFiles({ thirdparty + "x64/Debug/",thirdparty + "x64/" });
		} else if (attr.find("Release") != attr.npos) {
			after = _GetLibFiles({ thirdparty + "x64/Release/",thirdparty + "x64/" });
		} else {
			return false;
		}
	} else {
		return false;
	}
	if (after.size() <= 1) {
		return false;
	}
	if (before == after) {
		return false;
	}
	if (before > after) {
		return false;
	}
	for (auto&__after : after) {
		before.insert(__after);
	}
	std::string value;
	for (auto& __before : before) {
		value += __before + ";";
	}
	e->SetText(value.c_str());
	return true;
}
int ConfigVCXPROJXML(std::string file,std::string thirdparty) { //-> 0(success), 1(fail), 2(not update)
	if (thirdparty.back() != '/' && thirdparty.back() != '\\') {
		thirdparty.push_back('\\');
	}
	tinyxml2::XMLDocument doc;
	tinyxml2::XMLError xml_error = doc.LoadFile(file.c_str());
	if (xml_error != tinyxml2::XML_SUCCESS) {
		return 1;
	}
	bool changed = false;
	//get lib file list.

	tinyxml2::XMLElement* root = doc.RootElement();
	tinyxml2::XMLElement* idg = doc.RootElement()->FirstChildElement("ItemDefinitionGroup");
	for (tinyxml2::XMLElement* c = idg; c != nullptr; c = c->NextSiblingElement("ItemDefinitionGroup")) {
		tinyxml2::XMLElement* link = c->FirstChildElement("Link");
		std::string attr = c->Attribute("Condition");
		if (link != nullptr) {
			tinyxml2::XMLElement* ads = link->FirstChildElement("AdditionalDependencies");
			if (ads == nullptr) {
				tinyxml2::XMLElement* e = doc.NewElement("AdditionalDependencies");
				if (InsertAdditionalLibsToXML(e, "", thirdparty, attr) == true) {
					changed = true;
				}
				link->LinkEndChild(e);
			} else {
				if (InsertAdditionalLibsToXML(ads, ads->GetText()==nullptr?"":ads->GetText(), thirdparty, attr) == true) {
					changed = true;
				}
			}
		}
	}
	tinyxml2::XMLElement* macros = root->FirstChildElement("PropertyGroup");
	for (tinyxml2::XMLElement* c = macros; c != nullptr; c = c->NextSiblingElement("PropertyGroup")) {
		const char* attr = c->Attribute("Label");
		if (attr != nullptr) {
			if (strcmp(attr, "UserMacros") == 0) {
				if (c->FirstChildElement("ShortPlatform") == nullptr) {
					changed = true;
					tinyxml2::XMLElement* macro = doc.NewElement("ShortPlatform");
					macro->SetAttribute("Condition", "\'$(Platform)\' == \'Win32\'");
					macro->SetText("x86");
					c->LinkEndChild(macro);
					macro = doc.NewElement("ShortPlatform");
					macro->SetAttribute("Condition", "\'$(Platform)\' == \'x64\'");
					macro->SetText("x64");
					c->LinkEndChild(macro);
					std::cout << attr << std::endl;
				}
			}
		}
	}
	if (changed == true) {
		std::string outfile = file;
		doc.SaveFile(outfile.c_str());
		std::ifstream fin;
		fin.open(outfile);
		std::string str;
		str.assign(std::istreambuf_iterator<char>(fin), std::istreambuf_iterator<char>());
		fin.close();
		str = replace_all(str, "&apos;", "\'");
		std::ofstream fout;
		fout.open(outfile);
		fout << str;
		fout.close();
		return 0;
	} else {
		return 2;
	}
}
void VSpringMsg(std::string name, std::string version, std::string msg, std::vector<std::string> args) {
	int line = 78;
	for (auto&e : args) {
		if (e.length() > line) {
			line = e.length();
		}
	}
	std::vector<std::string> out = { name,version,msg };
	out.insert(out.end(), args.begin(), args.end());
	for (int j = 0; j < line + 2; j++)putchar('*'); putchar('\n');
	for (int i = 0; i < out.size(); i++) {
		putchar('*');
		int beg = line / 2 - out[i].length() / 2;
		for (int j = 0; j < beg; j++)putchar(' ');
		std::cout << out[i];
		for (int j = beg + out[i].length(); j < line; j++)putchar(' ');
		putchar('*');
		putchar('\n');
	}
	for (int j = 0; j < line + 2; j++)putchar('*'); putchar('\n');
}
int main(int argc, const char* argv[]) {
	//argv[1] = input filr
	//argv[2] = 3rdparty path
	std::array<std::string, 4> msg = {
		"Success"
		,"Failed"
		,"Already updated"
		,"Argument incorrect"
	};
	int r = 3;
	if (argc == 3) {
		std::string file = argv[1];
		std::string thirdparty = argv[2];
		if (thirdparty.back() == '\"') {
			thirdparty.pop_back();
		}
		r = ConfigVCXPROJXML(file, thirdparty);
		VSpringMsg("VSpring(LibProps)", "0.1.7", msg[r], { argv[1],argv[2] });
	} else {
		VSpringMsg("VSpring(LibProps)", "0.1.7", msg[r], {});
	}
	return EXIT_SUCCESS;
}