// Copyright(C) 2019-2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
//
// export JAVA_HOME="/path/to/jdk/root"
// export LD_LIBRARY_PATH="$(pwd)":$LD_LIBRARY_PATH
// v -prod -shared libv.v && javac io/v/V.java && java io.v.V
//
import os

pub fn vexe() string {
	mut exe := os.getenv('VEXE')
	if os.is_executable(exe) {
		return os.real_path(exe)
	}
	possible_symlink := os.find_abs_path_of_executable('v') or { '' }
	if os.is_executable(possible_symlink) {
		exe = os.real_path(possible_symlink)
	}
	return exe
}

fn java_home() string {
	mut java_home := os.getenv('JAVA_HOME')
	if java_home != '' {
		return java_home.trim_right(os.path_separator)
	}
	possible_symlink := os.find_abs_path_of_executable('javac') or { return '' }
	java_home = os.real_path(os.join_path(os.dir(possible_symlink), '..'))
	return java_home.trim_right(os.path_separator)
}

javahome := java_home()
javac := os.find_abs_path_of_executable('javac') or { '' }
java := os.find_abs_path_of_executable('java') or { '' }

if javahome == '' || javac == '' {
	eprintln('could not detect Java install. Please set JAVA_HOME')
	exit(1)
}

os.setenv('JAVA_HOME', javahome, false)
os.setenv('LD_LIBRARY_PATH', os.getenv('LD_LIBRARY_PATH') + os.path_delimiter + os.getwd(),
	true)

lib_name := 'libv.so'
if os.is_file('$lib_name') {
	eprintln('Removing previous $lib_name')
	os.rm('$lib_name') or {}
}
eprintln('Compiling shared $lib_name')
os.system(vexe()+' -cg -prod -shared libv.v')
eprintln('Compiling Java sources')
os.system(javac + ' io/v/V.java')
if !os.is_file('$lib_name') {
	eprintln('No shared library $lib_name')
	exit(1)
}
eprintln('Running Java application')
os.system(java + ' io.v.V')
