// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
module jni

import jni.c

// TODO
pub const used_import = c.used_import

pub const no_value_arg = []JavaValue{}

struct CallResult {
pub:
	call        string
	method_type MethodType
	val         Type // TODO = Void ??
}

//
pub fn throw_exception(env &Env, msg string) {
	exception_clear(env)
	cls := find_class(env, 'java/lang/Exception')
	throw_new(env, cls, msg)
}

pub fn panic_on_exception(env &Env) {
	if exception_check(env) {
		exception_describe(env)
		panic('An exception occured in jni.Env (${ptr_str(env)})')
	}
}


// sig builds a V `jni` style signature from the supplied arguments.
pub fn sig(pkg string, f_name string, rt Type, args ...Type) string {
	mut vtypargs := ''
	for arg in args {
		vtypargs += arg.type_name() + ', '
	}

	mut return_type := ' ' + rt.type_name()
	is_void := match rt {
		string {
			rt == 'void'
		}
		else {
			false
		}
	}

	if rt.type_name() == 'string' && is_void {
		return_type = ''
	}
	vtypargs = vtypargs.trim_right(', ')
	jni_sig := pkg + '.' + jni.v2j_fn_name(f_name) + '(' + vtypargs + ')' + return_type
	// println(jni_sig)
	return jni_sig
}

fn parse_signature(fqn_sig string) (string, string) {
	sig := fqn_sig.trim_space()
	fqn := sig.all_before('(')
	// args := '('+sig.all_after('(').all_before_last(')')+')'
	mut return_type := sig.all_after_last(')').trim_space()
	if return_type == '' {
		return_type = 'void'
	}
	// fargs := sig.all_after('(').all_before(')')
	$if debug {
		println(@MOD + '.' + @FN + ' ' + '"$sig" -> fqn: "$fqn", return: "$return_type"')
	}

	return fqn, return_type
}

//
pub fn call_static_method(env &Env, signature string, args ...Type) CallResult {
	fqn, return_type := parse_signature(signature)

	mut jv_args := []C.jvalue{}
	mut jargs := ''

	for vt in args {
		jargs += v2j_signature_type(vt)
		jv_args << v2j_value(vt)
	}
	jdef := fqn + '(' + jargs + ')' + v2j_string_signature_type(return_type)

	class, mid := get_class_static_method_id(env, jdef) or { panic(err) }
	call_result := match return_type {
		'bool' {
			CallResult{
				call: signature
				val: C.CallStaticBooleanMethodA(env, class, mid, jv_args.data) == jboolean(true)
			}
		}
		'f32' {
			CallResult{
				call: signature
				val: f32(C.CallStaticFloatMethodA(env, class, mid, jv_args.data))
			}
		}
		'f64' {
			CallResult{
				call: signature
				val: f64(C.CallStaticDoubleMethodA(env, class, mid, jv_args.data))
			}
		}
		'int' {
			CallResult{
				call: signature
				val: int(C.CallStaticIntMethodA(env, class, mid, jv_args.data))
			}
		}
		'string' {
			jstr := C.ObjectToString(C.CallStaticObjectMethodA(env, class, mid, jv_args.data))
			CallResult{
				call: signature
				val: j2v_string(env, jstr)
			}
		}
		'object' {
			jobj := JavaObject(C.CallStaticObjectMethodA(env, class, mid, jv_args.data))
			CallResult{
				call: signature
				val: jobj
			}
		}
		'void' {
			C.CallStaticVoidMethodA(env, class, mid, jv_args.data)
			CallResult{
				call: signature
			}
		}
		else {
			CallResult{}
		}
	}
	// Check for any exceptions
	if exception_check(env) {
		exception_describe(env)
		excp := 'An exception occured while executing "$signature" in JNIEnv (${ptr_str(env)})'
		$if debug {
			println(excp)
		}
		// throw_exception(env, excp)
		panic(excp)
	}
	return call_result
}

pub fn call_object_method(env &Env, obj JavaObject, signature string, args ...Type) CallResult {
	// println(@FN+': $signature')
	fqn, return_type := parse_signature(signature)

	mut jv_args := []JavaValue{}
	mut jargs := ''

	for vt in args {
		jargs += v2j_signature_type(vt)
		jv_args << v2j_value(vt)
	}
	jdef := fqn + '(' + jargs + ')' + v2j_string_signature_type(return_type)
	_, mid := get_object_class_and_method_id(env, obj, jdef) or { panic(err) }

	call_result := match return_type {
		'bool' {
			CallResult{
				call: signature
				val: call_boolean_method_a(env, obj, mid, jv_args.data)
			}
		}
		'f32' {
			CallResult{
				call: signature
				val: call_float_method_a(env, obj, mid, jv_args.data)
			}
		}
		'f64' {
			CallResult{
				call: signature
				val: call_double_method_a(env, obj, mid, jv_args.data)
			}
		}
		'int' {
			CallResult{
				call: signature
				val: call_int_method_a(env, obj, mid, jv_args.data)
			}
		}
		'string' {
			jstr := C.ObjectToString(C.CallObjectMethodA(env, obj, mid, jv_args.data))
			CallResult{
				call: signature
				val: j2v_string(env, jstr)
			}
		}
		'object' {
			CallResult{
				call: signature
				val: call_object_method_a(env, obj, mid, jv_args.data)
			}
		}
		'void' {
			call_void_method_a(env, obj, mid, jv_args.data)
			CallResult{
				call: signature
			}
		}
		else {
			CallResult{}
		}
	}
	// Check for any exceptions
	if exception_check(env) {
		exception_describe(env)
		excp := 'An exception occured while executing "$signature" in JNIEnv (${ptr_str(env)})'
		// throw_exception(env, excp)
		panic(excp)
	}
	return call_result
}

pub fn get_object_class_name(env &Env, obj JavaObject) string {
	classclass := get_object_class(env, obj)

	mid_get_name := get_method_id(env, classclass, 'getName', '()Ljava/lang/String;')

	jstr_class_name := call_object_method_a(env, obj, mid_get_name, no_value_arg.data)
	$if debug {
		if exception_check(env) {
			exception_describe(env)
			if !isnil(jstr_class_name) {
				delete_local_ref(env, jstr_class_name)
			}
			panic("An exception occured. Couldn't call \"getName\" method on object \"$obj\" in jni.Env (${ptr_str(env)})")
		}
	}
	return j2v_string(env, C.ObjectToString(jstr_class_name))
}

pub fn get_class_name(env &Env, jclazz JavaClass) string {
	o := C.ClassToObject(jclazz)
	return get_object_class_name(env, o)
}

pub fn get_class_static_method_id(env &Env, fqn_sig string) ?(JavaClass, JavaMethodID) {
	clazz, fn_name, fn_sig := v2j_signature(fqn_sig)
	mut jclazz := JavaClass{}
	// Find the Java class
	$if android {
		jclazz = find_class(default_env(), clazz)
	} $else {
		jclazz = find_class(env, clazz)
	}
	mid := get_static_method_id(env, jclazz, fn_name, fn_sig)
	return jclazz, mid
}

pub fn get_object_class_and_method_id(env &Env, obj JavaObject, fqn_sig string) ?(JavaClass, JavaMethodID) {
	_, f_name, f_sig := v2j_signature(fqn_sig)
	// Find the class of the object
	jclazz := get_object_class(env, obj)
	// Find the method on the class
	mid := get_method_id(env, jclazz, f_name, f_sig)
	return jclazz, mid
}
