// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
module jni

pub fn default_vm() &JavaVM {
	return C.gGetJavaVM()
}

pub fn default_env() &Env {
	return C.gGetEnv()
}

pub fn set_java_vm(vm &JavaVM) {
	C.gSetJavaVM(vm)
}

pub fn setup_android(fq_activity_name string) {
	$if android {
		activity_name := fq_activity_name.replace('.', '/')
		C.gSetupAndroid(activity_name.str)
	}
}
