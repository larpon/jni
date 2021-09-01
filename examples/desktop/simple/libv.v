// Copyright(C) 2019-2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
module libv

import jni

// jni_on_load is called by the JavaVM upon setup
[export: 'JNI_OnLoad']
fn jni_on_load(vm &jni.JavaVM, reserved voidptr) int {
	println(@FN+' called')
	jni.set_java_vm(vm)
	return int(jni.Version.v1_6)
}

// get_string_from_v returns a string obtained from Java via a static method call
[export: 'JNICALL Java_io_v_V_getStringFromV']
fn get_string_from_v(env &jni.Env, thiz jni.JavaObject) jni.JavaString {
	// Obtain the string "Hello from Java!" from the Java class...
	call_result := jni.call_static_method(env, 'io.v.V.getStringFromJava() string')
	// Cast the value of the call result to a v 'string'...
	string_from_java := call_result.result as string
	println(@MOD + '.' + @FN + ' string from Java "$string_from_java"')
	// Return a Java 'String' to the caller - replacing 'Java' with 'V'...
	return jni.jstring(env, string_from_java.replace('Java','V'))
}
