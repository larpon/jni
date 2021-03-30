// Copyright(C) 2019-2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
module libvlang

import jni
import jni.auto

const pkg = 'io.vlang.V'

[export: 'JNI_OnLoad']
fn jni_on_load(vm &jni.JavaVM, reserved voidptr) int {
	println(@FN+' called')
	jni.set_java_vm(vm)
	return C.JNI_VERSION_1_6
}

[export: 'JNICALL Java_io_vlang_V_callStaticMethods']
fn call_static_methods(env &jni.Env, thiz jni.JavaObject) {
	// Object call style
	jo := jni.object(env, thiz)
	jor := jo.call(.@static, 'getInt() int').result as int
	println('V: jni.CallResult.int: $jor')

	// flat call style
	r := jni.call_static_method(env, 'io.vlang.V.getInt() int')
	println('V: $r.result')
	r2 := jni.call_static_method(env, 'io.vlang.V.getBool() bool')
	println('V: $r2.result')
	r3 := jni.call_static_method(env, 'io.vlang.V.mixedArguments(bool, int) int', true, 2)
	println('V: $r3.result')

	jprintln('Hello from V - this shows up in Java')

	jffr := java_float_func('Hello',22)
	println('V: java_float_func(\'Hello\',22) -> $jffr')

	println('V: java_void_func(\'Void\',0)')
	java_void_func('Void',0)
}

[export: 'JNICALL Java_io_vlang_V_callObjectMethods']
fn call_object_methods(env &jni.Env, thiz jni.JavaObject) {
	// Call method on the object passed in "thiz" (io.vlang.V.setInt(int))
	jo := jni.object(env, thiz)
	jor := jo.call(.object, 'setInt(int)', 53)
	println('V: jni.Object: $jor')
	//
	jni.call_object_method(env, thiz, 'setInt(int)', 42)

	println('V: Passing io.vlang.V object type from Java to V...')
	// call "public V getInstance()" on "io.vlang.V"
	java_object := jni.call_object_method(env, thiz, 'getInstance() io.vlang.V').result as jni.JavaObject

	clsn := java_object.class_name(env)
	println('V: Class name: "$clsn"')
	println('V: Passing io.vlang.V object type from V to Java...')
	// call "public void passInstance(V v)" on "io.vlang.V" instance
	jni.call_object_method(env, thiz, 'passInstance(io.vlang.V)',java_object)
}

[export: 'JNICALL Java_io_vlang_V_vGetString']
fn get_v_string(env &jni.Env, thiz jni.JavaObject) jni.JavaString {
	r := jni.call_static_method(env, 'io.vlang.V.getInt() int')
	r2 := jni.call_static_method(env, 'io.vlang.V.getBool() bool')

	r3 := jni.call_static_method(env, 'io.vlang.V.getString() string')

	s := 'V: values obtained from Java: ${r.result}, ${r2.result}, ${r3.result}'
	return jni.jstring(env, s)
}

[export: 'JNICALL Java_io_vlang_V_vGetInt']
fn get_v_int(env &jni.Env, thiz jni.JavaObject) int {
	thiz.call(env, .@static, 'jprintln(string)','called get_v_int()')
	i := 42
	return i
}

[export: 'JNICALL Java_io_vlang_V_vAddInt']
fn add_v_int(env &jni.Env, thiz jni.JavaObject, a int, b int) int {
	res := a + b
	return res
}

/*
 * Danger zone: Comfort > obscurity here :|
 * 1. Assemble the FQN automatically: 'io.vlang.V' + '.' + 'vprintln'
 * 2. Get type of the `text` argument: 'string'
 * 3. Use default/main thread JNIEnv to call the Java method.
 * 4. Effectively call: io.vlang.V.vprintln(text) in the JavaVM.
*/
fn jprintln(text string) {
	meth := pkg+'.'+jni.v2j_fn_name(@FN) /*1*/ +'('+typeof(text).name+')' /*2*/
	auto.call_static_method/*3*/(meth,text)/*4*/
}

/*
 * Danger zone
 * automatic "reflection" setup of V function calls in Java
*/
// java_float_func is "reflected" from "public static float javaFloatFunc(String s, int i)" in "io.vlang.V"
fn java_float_func(text string, i int) f32 {
	return auto.call_static_method(jni.sig(pkg,@FN,f32(0),text,i),text,i).result as f32
}

fn java_void_func(text string, i int) {
	auto.call_static_method(jni.sig(pkg,@FN,'void',text,i),text,i)
}
