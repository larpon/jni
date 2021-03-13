// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
module jni

pub fn default_vm() &JavaVM {
	return C.jniGetJavaVM()
}

pub fn default_env() &Env {
	return C.jniGetEnv()
}

pub fn set_java_vm(vm &JavaVM) {
	C.jniSetJavaVM(vm)
}

pub fn setup_android(fq_activity_name string) {
	$if android {
		activity_name := fq_activity_name.replace('.', '/')
		C.jniSetupAndroid(activity_name.str)
	}
}
