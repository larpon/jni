// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
module android

// import jni
import os

/*
pub fn env() &jni.Env {
	return jni.default_env()
}
*/

pub fn activity() !&os.NativeActivity {
	actvty := &os.NativeActivity(C.sapp_android_get_native_activity())
	if isnil(actvty) {
		return error(@MOD + '.' + @FN + ': could not get reference to Android native activity')
		// panic(@MOD+'.'+@FN+': could not get reference to Android native activity')
	}
	return actvty
}
