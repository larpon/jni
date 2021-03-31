// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
module jni

import jni.c

// TODO
pub const used_import = c.used_import

pub const void_arg = []JavaValue{}

struct CallResult {
pub:
	call        string
//	method_type MethodType
	result      Type // TODO = Void ??
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
		panic(@MOD + '.' + @FN + ' an exception occured in jni.Env (${ptr_str(env)})')
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
	mut return_type := sig.all_after_last(')').trim_space()
	if return_type == '' {
		return_type = 'void'
	}
	$if debug {
		args_str := sig.all_after('(').all_before(')')
		args := '('+args_str+')'
		println(@MOD + '.' + @FN + ' ' + '"$sig" -> "$fqn$args $return_type"')
	}

	return fqn, return_type
}

//
pub fn call_static_method(env &Env, signature string, args ...Type) CallResult {
	fqn, return_type := parse_signature(signature)

	mut jv_args := []JavaValue{}
	mut jargs := ''

	for vt in args {
		jargs += v2j_signature_type(env, vt)
		jv_args << v2j_value(env, vt)
	}
	jdef := fqn + '(' + jargs + ')' + v2j_string_signature_type(return_type)
	$if debug {
		println(@MOD + '.' + @FN + ' Java call style definition: "$fqn -> $jdef"')
	}
	class, mid := get_class_static_method_id(env, jdef)

	mut call_result := CallResult{}
	//
	if return_type.contains('/') || return_type.contains('.') {
		call_result = CallResult{
			call: signature
			result: call_static_boolean_method_a(env, class, mid, jv_args.data)
		}
	} else {
		call_result = match return_type {
			'bool' {
				CallResult{
					call: signature
					result: call_static_boolean_method_a(env, class, mid, jv_args.data)
				}
			}
			'byte' {
				CallResult{
					call: signature
					result: call_static_byte_method_a(env, class, mid, jv_args.data)
				}
			}
			'rune' {
				CallResult{
					call: signature
					result: call_static_char_method_a(env, class, mid, jv_args.data)
				}
			}
			'i16' {
				CallResult{
					call: signature
					result: call_static_short_method_a(env, class, mid, jv_args.data)
				}
			}
			'int' {
				CallResult{
					call: signature
					result: call_static_int_method_a(env, class, mid, jv_args.data)
				}
			}
			'i64' {
				CallResult{
					call: signature
					result: call_static_long_method_a(env, class, mid, jv_args.data)
				}
			}
			'f32' {
				CallResult{
					call: signature
					result: call_static_float_method_a(env, class, mid, jv_args.data)
				}
			}
			'f64' {
				CallResult{
					call: signature
					result: call_static_double_method_a(env, class, mid, jv_args.data)
				}
			}
			'string' {
				CallResult{
					call: signature
					result: call_static_string_method_a(env, class, mid, jv_args.data)
				}
			}
			'object' {
				CallResult{
					call: signature
					result: call_static_object_method_a(env, class, mid, jv_args.data)
				}
			}
			'void' {
				call_static_void_method_a(env, class, mid, jv_args.data)
				CallResult{
					call: signature
					//result: Void{}
				}
			}
			else {
				CallResult{}
			}
		}
	}
	// Check for any exceptions
	$if debug {
		if exception_check(env) {
			exception_describe(env)
			excp := 'An exception occured while executing "$signature" in JNIEnv (${ptr_str(env)})'
			$if debug {
				println(excp)
			}
			// throw_exception(env, excp)
			panic(excp)
		}
	}
	return call_result
}

pub fn call_object_method(env &Env, obj JavaObject, signature string, args ...Type) CallResult {
	fqn, return_type := parse_signature(signature)

	mut jv_args := []JavaValue{}
	mut jargs := ''

	for vt in args {
		jargs += v2j_signature_type(env, vt)
		jv_args << v2j_value(env, vt)
	}
	jdef := fqn + '(' + jargs + ')' + v2j_string_signature_type(return_type)
	$if debug {
		println(@MOD + '.' + @FN + ' Java call style definition: "$fqn -> $jdef"')
	}
	_, mid := get_object_class_and_method_id(env, obj, jdef)

	mut call_result := CallResult{}
	//
	if return_type.contains('/') || return_type.contains('.') {
		call_result = CallResult{
			call: signature
			result: call_object_method_a(env, obj, mid, jv_args.data)
		}
	} else {
		call_result = match return_type {
			'bool' {
				CallResult{
					call: signature
					result: call_boolean_method_a(env, obj, mid, jv_args.data)
				}
			}
			'byte' {
				CallResult{
					call: signature
					result: call_byte_method_a(env, obj, mid, jv_args.data)
				}
			}
			'rune' {
				CallResult{
					call: signature
					result: call_char_method_a(env, obj, mid, jv_args.data)
				}
			}
			'i16' {
				CallResult{
					call: signature
					result: call_short_method_a(env, obj, mid, jv_args.data)
				}
			}
			'int' {
				CallResult{
					call: signature
					result: call_int_method_a(env, obj, mid, jv_args.data)
				}
			}
			'i64' {
				CallResult{
					call: signature
					result: call_long_method_a(env, obj, mid, jv_args.data)
				}
			}
			'f32' {
				CallResult{
					call: signature
					result: call_float_method_a(env, obj, mid, jv_args.data)
				}
			}
			'f64' {
				CallResult{
					call: signature
					result: call_double_method_a(env, obj, mid, jv_args.data)
				}
			}
			'string' {
				CallResult{
					call: signature
					result: call_string_method_a(env, obj, mid, jv_args.data)
				}
			}
			'object' {
				CallResult{
					call: signature
					result: call_object_method_a(env, obj, mid, jv_args.data)
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
	}
	// Check for any exceptions
	$if debug {
		if exception_check(env) {
			exception_describe(env)
			excp := @MOD + '.' + @FN + ' an exception occured while executing "$signature" in JNIEnv (${ptr_str(env)})'
			// throw_exception(env, excp)
			panic(excp)
		}
	}
	return call_result
}

fn get_class_static_method_id(env &Env, fqn_sig string) (JavaClass, JavaMethodID) {
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

fn get_object_class_and_method_id(env &Env, obj JavaObject, fqn_sig string) (JavaClass, JavaMethodID) {
	_, f_name, f_sig := v2j_signature(fqn_sig)
	// Find the class of the object
	jclazz := get_object_class(env, obj)
	// Find the method on the class
	mid := get_method_id(env, jclazz, f_name, f_sig)
	return jclazz, mid
}

[inline]
pub fn (jo JavaObject) class_name(env &Env) string {
	obj := jo
	mut cls := get_object_class(env, obj)
	// First get the class object
	mut mid := get_method_id(env, cls, "getClass", "()Ljava/lang/Class;")
	cls_obj := call_object_method_a(env, obj, mid, void_arg.data)
	// Get the class object's class descriptor
	cls = get_object_class(env, cls_obj)
	// Find the getName() method on the class object
	mid = get_method_id(env, cls, "getName", "()Ljava/lang/String;")
	// Call the getName() to get a jstring object back
	str_obj := call_object_method_a(env, cls_obj, mid, void_arg.data)
	// TODO NOTE current way of casting
	jstr := &JavaString(voidptr(&str_obj))
	return j2v_string(env, jstr)
}

[inline]
pub fn (jo JavaObject) call(env &Env, typ MethodType, signature string, args ...Type) CallResult {
	pkg := jo.class_name(env)
	return match typ {
		.@static { call_static_method(env, pkg + '.' + signature, ...args) }
		.object { call_object_method(env, jo, pkg + '.' + signature, ...args) }
	}
}

[inline]
pub fn (jc JavaClass) get_name(env &Env) string {
	o := &JavaObject(voidptr(&jc))
	return o.class_name(env)
}
