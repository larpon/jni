// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
module c

pub const (
	used_import = 1
)

#include <jni.h>

#flag linux -I /usr/lib/jvm/java-11-openjdk-amd64/include/linux
#flag linux -I /usr/lib/jvm/java-11-openjdk-amd64/include/
#flag -I @VROOT/c

#flag -lc

#include "jni_wrapper.h"
#include "helpers.h"
