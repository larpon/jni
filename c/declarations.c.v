// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
module c

pub const used_import = 1

///usr/lib/jvm/java-11-openjdk-amd64/include/
$if linux {
	#flag -I $env('JAVA_HOME')/include
	#flag -I $env('JAVA_HOME')/include/linux
}

$if darwin {
	#flag -I $env('JAVA_HOME')/include
	#flag -I $env('JAVA_HOME')/include/darwin
}

#flag -I @VROOT/c

#flag -lc

#include <jni.h>
#include "jni_wrapper.h"
#include "helpers.h"
