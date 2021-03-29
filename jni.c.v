// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
module jni

type JavaVM = C.JavaVM
type Env = C.JNIEnv

// type JavaByte = C.jbyte
type JavaObject = C.jobject
type JavaString = C.jstring
type JavaClass = C.jclass
type JavaMethodID = C.jmethodID
type JavaFieldID = C.jfieldID
type JavaThrowable = C.jthrowable
pub type JavaValue = C.jvalue

// jni.h
[typedef]
struct C.jstring {}

[typedef]
struct C.JNIEnv {}

[typedef]
struct C.JavaVM {}

[typedef]
struct C.jobject {}

[typedef]
struct C.jclass {}

[typedef]
struct C.jmethodID {}

[typedef]
struct C.jfieldID {}

[typedef]
struct C.jthrowable {}

[typedef]
union C.jvalue {
	z C.jboolean
	b C.jbyte
	c C.jchar
	s C.jshort
	i C.jint
	j C.jlong
	f C.jfloat
	d C.jdouble
	l C.jobject
}

// C.jsize int

// helpers.h
// fn C.vc_cast(from voidptr, to voidptr) voidptr

fn C.VoidToLong(vp voidptr) i64
fn C.LongToVoid(l i64) voidptr

fn C.StringToObject(str C.jstring) C.jobject

fn C.ObjectToString(obj C.jobject) C.jstring

fn C.ObjectToClass(obj C.jobject) C.jclass

fn C.ClassToObject(cls C.jclass) C.jobject

fn C.MethodIDToObject(cls C.jmethodID) C.jobject

fn C.jniGetEnv() &C.JNIEnv

fn C.jniGetJavaVM() &C.JavaVM
fn C.jniSetJavaVM(vm &JavaVM)

fn C.jniFindClass(name charptr) C.jclass

fn C.jniSetupAndroid(name charptr)

// TODO
pub fn get_static_field_id(env &Env, clazz JavaClass, name string, signature string) JavaFieldID {
	return C.GetStaticFieldID(env, clazz, name.str, signature.str)
}

// jni.h / jni_wrapper.h

fn C.GetVersion(env &C.JNIEnv) C.jint
pub fn get_version(env &Env) int {
	return int(C.GetVersion(env))
}

fn C.DefineClass(env &C.JNIEnv, name charptr, loader C.jobject, buf &C.jbyte, len int) C.jclass

// NOTE: unsure about `buf` (C.jbyte -> signed char) and `len` (C.jsize -> C.jint) types.
pub fn define_class(env &Env, name string, loader JavaObject, buf byteptr, len int) JavaClass {
	return C.DefineClass(env, name.str, loader, buf, len)
}

fn C.FindClass(env &C.JNIEnv, name charptr) C.jclass
pub fn find_class(env &Env, name string) JavaClass {
	n := name.replace('.', '/')
	$if debug {
		mut cls := C.jclass{}
		$if android {
			cls = C.jniFindClass(n.str)
		} $else {
			cls = C.FindClass(env, n.str)
		}
		if exception_check(env) {
			exception_describe(env)
			if !isnil(cls) {
				o := C.ClassToObject(cls)
				delete_local_ref(env, o)
			}
			panic(@MOD + '.' + @FN + ': an exception occured in the Java VM while trying to find class "$n" in jni.Env(${ptr_str(env)})')
		}
		return cls
	}
	$if android {
		return C.jniFindClass(n.str)
	}
	return C.FindClass(env, n.str)
}

fn C.FromReflectedMethod(env &C.JNIEnv, method C.jobject) C.jmethodID
pub fn from_reflected_method(env &Env, method JavaObject) JavaMethodID {
	return C.FromReflectedMethod(env, method)
}

fn C.FromReflectedField(env &C.JNIEnv, field C.jobject) C.jfieldID
pub fn from_reflected_field(env &Env, field JavaObject) JavaFieldID {
	return C.FromReflectedField(env, field)
}

fn C.ToReflectedMethod(env &C.JNIEnv, cls C.jclass, methodID C.jmethodID, isStatic C.jboolean) C.jobject
pub fn to_reflected_method(env &Env, cls JavaClass, methodID JavaMethodID, isStatic bool) JavaObject {
	return C.ToReflectedMethod(env, cls, methodID, jboolean(isStatic))
}

fn C.GetSuperclass(env &C.JNIEnv, sub C.jclass) C.jclass
pub fn get_superclass(env &Env, sub JavaClass) JavaClass {
	return C.GetSuperclass(env, sub)
}

fn C.IsAssignableFrom(env &C.JNIEnv, sub C.jclass, sup C.jclass) C.jboolean
pub fn is_assignable_from(env &Env, sub JavaClass, sup JavaClass) bool {
	return j2v_boolean(C.IsAssignableFrom(env, sub, sup))
}

fn C.ToReflectedField(env &C.JNIEnv, cls C.jclass, fieldID C.jfieldID, isStatic C.jboolean) C.jobject
pub fn to_reflected_field(env &Env, cls JavaClass, field_id JavaFieldID, is_static bool) JavaObject {
	return C.ToReflectedField(env, cls, field_id, jboolean(is_static))
}

fn C.Throw(env &C.JNIEnv, obj C.jthrowable) C.jint
pub fn throw(env &Env, obj JavaThrowable) int {
	return j2v_int(C.Throw(env, obj))
}

fn C.ThrowNew(env &C.JNIEnv, clazz C.jclass, msg charptr) C.jint
pub fn throw_new(env &Env, clazz JavaClass, msg string) int {
	return j2v_int(C.ThrowNew(env, clazz, msg.str))
}

fn C.ExceptionOccurred(env &Env) C.jthrowable
pub fn exception_occurred(env &Env) JavaThrowable {
	return C.ExceptionOccurred(env)
}

fn C.ExceptionDescribe(env &Env)
pub fn exception_describe(env &Env) {
	C.ExceptionDescribe(env)
}

fn C.ExceptionClear(env &C.JNIEnv)
pub fn exception_clear(env &Env) {
	C.ExceptionClear(env)
}

fn C.FatalError(env &C.JNIEnv, msg charptr)
pub fn fatal_error(env &Env, msg string) {
	C.FatalError(env, msg.str)
}

fn C.PushLocalFrame(env &C.JNIEnv, capacity C.jint) C.jint
pub fn push_local_frame(env &Env, capacity int) int {
	return j2v_int(C.PushLocalFrame(env, jint(capacity)))
}

fn C.PopLocalFrame(env &C.JNIEnv, result C.jobject) C.jobject
pub fn pop_local_frame(env &Env, result JavaObject) JavaObject {
	return C.PopLocalFrame(env, result)
}

fn C.NewGlobalRef(env &C.JNIEnv, lobj C.jobject) C.jobject
pub fn new_global_ref(env &Env, lobj JavaObject) JavaObject {
	return C.NewGlobalRef(env, lobj)
}

fn C.DeleteGlobalRef(env &C.JNIEnv, gref C.jobject)
pub fn delete_global_ref(env &Env, gref JavaObject) {
	C.DeleteGlobalRef(env, gref)
}

fn C.DeleteLocalRef(env &C.JNIEnv, obj C.jobject)
pub fn delete_local_ref(env &Env, obj JavaObject) {
	C.DeleteLocalRef(env, obj)
}

fn C.IsSameObject(env &C.JNIEnv, obj1 C.jobject, obj2 C.jobject) C.jboolean
pub fn is_same_object(env &Env, obj1 JavaObject, obj2 JavaObject) bool {
	return j2v_boolean(C.IsSameObject(env, obj1, obj2))
}

fn C.NewLocalRef(env &C.JNIEnv, ref C.jobject) C.jobject
pub fn new_local_ref(env &Env, ref JavaObject) JavaObject {
	return C.NewLocalRef(env, ref)
}

fn C.EnsureLocalCapacity(env &C.JNIEnv, capacity C.jint) C.jint
pub fn ensure_local_capacity(env &Env, capacity int) int {
	return j2v_int(C.EnsureLocalCapacity(env, jint(capacity)))
}

fn C.AllocObject(env &C.JNIEnv, clazz C.jclass) C.jobject
pub fn alloc_object(env &Env, clazz JavaClass) JavaObject {
	return C.AllocObject(env, clazz)
}

// fn C.NewObject(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, ...) C.jobject
// pub fn new_object(env &Env, clazz JavaClass, methodID JavaMethodID, ...) JavaObject {
//	return C.NewObject(env, clazz, methodID, ...)
//}
// fn C.NewObjectV(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jobject
// pub fn new_object(env &Env, clazz JavaClass, methodID JavaMethodID, args C.va_list) JavaObject {
//	return C.NewObjectV(env, clazz, methodID, args)
//}
fn C.NewObjectA(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jobject
pub fn new_object_a(env &Env, clazz JavaClass, methodID JavaMethodID, args &JavaValue) JavaObject {
	return C.NewObjectA(env, clazz, methodID, args)
}

fn C.GetObjectClass(env &C.JNIEnv, obj C.jobject) C.jclass
pub fn get_object_class(env &Env, obj JavaObject) JavaClass {
	$if debug {
		clazz := C.GetObjectClass(env, obj)
		if exception_check(env) {
			exception_describe(env)
			if !isnil(obj) {
				delete_local_ref(env, obj)
			}
			panic(@MOD + '.' + @FN + ': an exception occured in the Java VM while trying to find class of object "$obj" in jni.Env (${ptr_str(env)})')
		}
		return clazz
	}
	return C.GetObjectClass(env, obj)
}

fn C.IsInstanceOf(env &C.JNIEnv, obj C.jobject, clazz C.jclass) C.jboolean
pub fn is_instance_of(env &Env, obj JavaObject, clazz JavaClass) bool {
	return j2v_boolean(C.IsInstanceOf(env, obj, clazz))
}

fn C.GetMethodID(env &C.JNIEnv, clazz C.jclass, name charptr, sig charptr) C.jmethodID
pub fn get_method_id(env &Env, clazz JavaClass, name string, sig string) JavaMethodID {
	$if debug {
		mid := C.GetMethodID(env, clazz, name.str, sig.str)
		if exception_check(env) {
			exception_describe(env)
			if !isnil(mid) {
				o := C.MethodIDToObject(mid)
				delete_local_ref(env, o)
			}
			panic(@MOD + '.' + @FN + ': an exception occured in the JavaVM while trying to find method "$name'+'($sig)" on class "$clazz" in jni.Env (${ptr_str(env)})')
		}
		return mid
	}
	return C.GetMethodID(env, clazz, name.str, sig.str)
}

// fn C.CallObjectMethod(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, ...) C.jobject
// pub fn call_object_method(env &Env, obj JavaObject, method_id JavaMethodID, ...) JavaObject {
//	return C.CallObjectMethod(env, obj, method_id, ...)
//}
// fn C.CallObjectMethodV(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args C.va_list) C.jobject
// pub fn call_object_method_v(env &Env, obj JavaObject, method_id JavaMethodID, args C.va_list) JavaObject {
//	return C.CallObjectMethodV(env, obj, method_id, args C.va_list)
//}
fn C.CallObjectMethodA(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args &C.jvalue) C.jobject
pub fn call_object_method_a(env &Env, obj JavaObject, method_id JavaMethodID, args &JavaValue) JavaObject {
	return C.CallObjectMethodA(env, obj, method_id, args)
}

// fn C.CallBooleanMethod(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, ...) C.jboolean
// pub fn call_boolean_method(env &Env, obj JavaObject, method_id JavaMethodID, ...) bool {
//	return C.CallBooleanMethod(env, obj, method_id, ...)
//}
// fn C.CallBooleanMethodV(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args C.va_list) C.jboolean
// pub fn call_boolean_method_v(env &Env, obj JavaObject, method_id JavaMethodID, args C.va_list) bool {
//	return C.CallBooleanMethodV(env, obj, method_id, args C.va_list)
//}
fn C.CallBooleanMethodA(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args &C.jvalue) C.jboolean
pub fn call_boolean_method_a(env &Env, obj JavaObject, method_id JavaMethodID, args &JavaValue) bool {
	return j2v_boolean(C.CallBooleanMethodA(env, obj, method_id, args))
}

// fn C.CallByteMethod(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, ...) C.jbyte
// pub fn call_byte_method(env &Env, obj JavaObject, method_id JavaMethodID, ...) C.jbyte {
//	return C.CallByteMethod(env, obj, method_id, ...)
//}
// fn C.CallByteMethodV(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args C.va_list) C.jbyte
// pub fn call_byte_method_v(env &Env, obj JavaObject, method_id JavaMethodID, args C.va_list) C.jbyte {
//	return C.CallByteMethodV(env, obj, method_id, args C.va_list)
//}
fn C.CallByteMethodA(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args &C.jvalue) C.jbyte
pub fn call_byte_method_a(env &Env, obj JavaObject, method_id JavaMethodID, args &JavaValue) byte {
	return j2v_byte(C.CallByteMethodA(env, obj, method_id, args))
}

// fn C.CallCharMethod(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, ...) C.jchar
// pub fn call_char_method(env &Env, obj JavaObject, method_id JavaMethodID, ...) C.jchar {
//	return C.CallCharMethod(env, obj, method_id, ...)
//}
// fn C.CallCharMethodV(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args C.va_list) C.jchar
// pub fn call_char_method_v(env &Env, obj JavaObject, method_id JavaMethodID, args C.va_list) C.jchar {
//	return C.CallCharMethodV(env, obj, method_id, args C.va_list)
//}
fn C.CallCharMethodA(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args &C.jvalue) C.jchar
pub fn call_char_method_a(env &Env, obj JavaObject, method_id JavaMethodID, args &JavaValue) rune {
	return j2v_char(C.CallCharMethodA(env, obj, method_id, args))
}

// fn C.CallShortMethod(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, ...) C.jshort
// pub fn call_short_method(env &Env, obj JavaObject, method_id JavaMethodID, ...) i16 {
//	return C.CallShortMethod(env, obj, method_id, ...)
//}
// fn C.CallShortMethodV(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args C.va_list) C.jshort
// pub fn call_short_method_v(env &Env, obj JavaObject, method_id JavaMethodID, args C.va_list) i16 {
//	return C.CallShortMethodV(env, obj, method_id, args C.va_list)
//}
fn C.CallShortMethodA(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args &C.jvalue) C.jshort
pub fn call_short_method_a(env &Env, obj JavaObject, method_id JavaMethodID, args &JavaValue) i16 {
	return j2v_short(C.CallShortMethodA(env, obj, method_id, args))
}

// fn C.CallIntMethod(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, ...) C.jint
// pub fn call_int_method(env &Env, obj JavaObject, method_id JavaMethodID, ...) int {
//	return C.CallIntMethod(env, obj, method_id, ...)
//}
// fn C.CallIntMethodV(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args C.va_list) C.jint
// pub fn call_int_method_v(env &Env, obj JavaObject, method_id JavaMethodID, args C.va_list) int {
//	return C.CallIntMethodV(env, obj, method_id, args C.va_list)
//}
fn C.CallIntMethodA(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args &C.jvalue) C.jint
pub fn call_int_method_a(env &Env, obj JavaObject, method_id JavaMethodID, args &JavaValue) int {
	return j2v_int(C.CallIntMethodA(env, obj, method_id, args))
}

// fn C.CallLongMethod(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, ...) C.jlong
// pub fn call_long_method(env &Env, obj JavaObject, method_id JavaMethodID, ...) i64 {
//	return C.CallLongMethod(env, obj, method_id, ...)
//}
// fn C.CallLongMethodV(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args C.va_list) C.jlong
// pub fn call_long_method_v(env &Env, obj JavaObject, method_id JavaMethodID, args C.va_list) i64 {
//	return C.CallLongMethodV(env, obj, method_id, args C.va_list)
//}
fn C.CallLongMethodA(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args &C.jvalue) C.jlong
pub fn call_long_method_a(env &Env, obj JavaObject, method_id JavaMethodID, args &JavaValue) i64 {
	return j2v_long(C.CallLongMethodA(env, obj, method_id, args))
}

// fn C.CallFloatMethod(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, ...) C.jfloat
// pub fn call_float_method(env &Env, obj JavaObject, method_id JavaMethodID, ...) f32 {
//	return C.CallFloatMethod(env, obj, method_id, ...)
//}
// fn C.CallFloatMethodV(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args C.va_list) C.jfloat
// pub fn call_float_method_v(env &Env, obj JavaObject, method_id JavaMethodID, args C.va_list) f32 {
//	return C.CallFloatMethodV(env, obj, method_id, args C.va_list)
//}
fn C.CallFloatMethodA(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args &C.jvalue) C.jfloat
pub fn call_float_method_a(env &Env, obj JavaObject, method_id JavaMethodID, args &JavaValue) f32 {
	return j2v_float(C.CallFloatMethodA(env, obj, method_id, args))
}

// fn C.CallDoubleMethod(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, ...) C.jdouble
// pub fn call_double_method(env &Env, obj JavaObject, method_id JavaMethodID, ...) f64 {
//	return C.CallDoubleMethod(env, obj, method_id, ...)
//}
// fn C.CallDoubleMethodV(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args C.va_list) C.jdouble
// pub fn call_double_method_v(env &Env, obj JavaObject, method_id JavaMethodID, args C.va_list) f64 {
//	return C.CallDoubleMethodV(env, obj, method_id, args C.va_list)
//}
fn C.CallDoubleMethodA(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args &C.jvalue) C.jdouble
pub fn call_double_method_a(env &Env, obj JavaObject, method_id JavaMethodID, args &JavaValue) f64 {
	return j2v_double(C.CallDoubleMethodA(env, obj, method_id, args))
}

// fn C.CallVoidMethod(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, ...)
// pub fn call_void_method(env &Env, obj JavaObject, method_id JavaMethodID, ...) {
//	return C.CallVoidMethod(env, obj, method_id, ...)
//}
// fn C.CallVoidMethodV(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args C.va_list)
// pub fn call_void_method_v(env &Env, obj JavaObject, method_id JavaMethodID, args C.va_list) {
//	return C.CallVoidMethodV(env, obj, method_id, args C.va_list)
//}
fn C.CallVoidMethodA(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args &C.jvalue)
pub fn call_void_method_a(env &Env, obj JavaObject, method_id JavaMethodID, args &JavaValue) {
	C.CallVoidMethodA(env, obj, method_id, args)
}

// fn C.CallNonvirtualObjectMethod(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, ...) C.jobject
// pub fn call_nonvirtual_object_method(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, ...) JavaObject {
//	return C.CallNonvirtualObjectMethod(env, obj, clazz, method_id, ...)
//}
// fn C.CallNonvirtualObjectMethodV(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jobject
// pub fn call_nonvirtual_object_method_v(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, args C.va_list) JavaObject {
//	return C.CallNonvirtualObjectMethodV(env, obj, clazz, method_id, args C.va_list)
//}
fn C.CallNonvirtualObjectMethodA(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jobject
pub fn call_nonvirtual_object_method_a(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, args &JavaValue) JavaObject {
	return C.CallNonvirtualObjectMethodA(env, obj, clazz, method_id, args)
}

// fn C.CallNonvirtualBooleanMethod(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, ...) C.jboolean
// pub fn call_nonvirtual_boolean_method(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, ...) bool {
//	return C.CallNonvirtualBooleanMethod(env, obj, clazz, method_id, ...)
//}
// fn C.CallNonvirtualBooleanMethodV(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jboolean
// pub fn call_nonvirtual_boolean_method_v(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, args C.va_list) bool {
//	return C.CallNonvirtualBooleanMethodV(env, obj, clazz, method_id, args C.va_list)
//}
fn C.CallNonvirtualBooleanMethodA(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jboolean
pub fn call_nonvirtual_boolean_method_a(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, args &JavaValue) bool {
	return j2v_boolean(C.CallNonvirtualBooleanMethodA(env, obj, clazz, method_id, args))
}

// fn C.CallNonvirtualByteMethod(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, ...) C.jbyte
// pub fn call_nonvirtual_byte_method(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, ...) C.jbyte {
//	return C.CallNonvirtualByteMethod(env, obj, clazz, method_id, ...)
//}
// fn C.CallNonvirtualByteMethodV(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jbyte
// pub fn call_nonvirtual_byte_method_v(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, args C.va_list) C.jbyte {
//	return C.CallNonvirtualByteMethodV(env, obj, clazz, method_id, args C.va_list)
//}
fn C.CallNonvirtualByteMethodA(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jbyte
pub fn call_nonvirtual_byte_method_a(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, args &JavaValue) byte {
	return j2v_byte(C.CallNonvirtualByteMethodA(env, obj, clazz, method_id, args))
}

// fn C.CallNonvirtualCharMethod(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, ...) C.jchar
// pub fn call_nonvirtual_char_method(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, ...) C.jchar {
//	return C.CallNonvirtualCharMethod(env, obj, clazz, method_id, ...)
//}
// fn C.CallNonvirtualCharMethodV(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jchar
// pub fn call_nonvirtual_char_method_v(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, args C.va_list) C.jchar {
//	return C.CallNonvirtualCharMethodV(env, obj, clazz, method_id, args C.va_list)
//}
fn C.CallNonvirtualCharMethodA(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jchar
pub fn call_nonvirtual_char_method_a(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, args &JavaValue) rune {
	return j2v_char(C.CallNonvirtualCharMethodA(env, obj, clazz, method_id, args))
}

// fn C.CallNonvirtualShortMethod(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, ...) C.jshort
// pub fn call_nonvirtual_short_method(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, ...) i16 {
//	return C.CallNonvirtualShortMethod(env, obj, clazz, method_id, ...)
//}
// fn C.CallNonvirtualShortMethodV(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jshort
// pub fn call_nonvirtual_short_method_v(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, args C.va_list) i16 {
//	return C.CallNonvirtualShortMethodV(env, obj, clazz, method_id, args C.va_list)
//}
fn C.CallNonvirtualShortMethodA(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jshort
pub fn call_nonvirtual_short_method_a(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, args &JavaValue) i16 {
	return j2v_short(C.CallNonvirtualShortMethodA(env, obj, clazz, method_id, args))
}

// fn C.CallNonvirtualIntMethod(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, ...) C.jint
// pub fn call_nonvirtual_int_method(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, ...) int {
//	return C.CallNonvirtualIntMethod(env, obj, clazz, method_id, ...)
//}
// fn C.CallNonvirtualIntMethodV(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jint
// pub fn call_nonvirtual_int_method_v(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, args C.va_list) int {
//	return C.CallNonvirtualIntMethodV(env, obj, clazz, method_id, args C.va_list)
//}
fn C.CallNonvirtualIntMethodA(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jint
pub fn call_nonvirtual_int_method_a(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, args &JavaValue) int {
	return j2v_int(C.CallNonvirtualIntMethodA(env, obj, clazz, method_id, args))
}

// fn C.CallNonvirtualLongMethod(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, ...) C.jlong
// pub fn call_nonvirtual_long_method(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, ...) i64 {
//	return C.CallNonvirtualLongMethod(env, obj, clazz, method_id, ...)
//}
// fn C.CallNonvirtualLongMethodV(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jlong
// pub fn call_nonvirtual_long_method_v(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, args C.va_list) i64 {
//	return C.CallNonvirtualLongMethodV(env, obj, clazz, method_id, args C.va_list)
//}
fn C.CallNonvirtualLongMethodA(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jlong
pub fn call_nonvirtual_long_method_a(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, args &JavaValue) i64 {
	return j2v_long(C.CallNonvirtualLongMethodA(env, obj, clazz, method_id, args))
}

// fn C.CallNonvirtualFloatMethod(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, ...) C.jfloat
// pub fn call_nonvirtual_float_method(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, ...) f32 {
//	return C.CallNonvirtualFloatMethod(env, obj, clazz, method_id, ...)
//}
// fn C.CallNonvirtualFloatMethodV(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jfloat
// pub fn call_nonvirtual_float_method_v(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, args C.va_list) f32 {
//	return C.CallNonvirtualFloatMethodV(env, obj, clazz, method_id, args C.va_list)
//}
fn C.CallNonvirtualFloatMethodA(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jfloat
pub fn call_nonvirtual_float_method_a(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, args &JavaValue) f32 {
	return j2v_float(C.CallNonvirtualFloatMethodA(env, obj, clazz, method_id, args))
}

// fn C.CallNonvirtualDoubleMethod(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, ...) C.jdouble
// pub fn call_nonvirtual_double_method(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, ...) f64 {
//	return C.CallNonvirtualDoubleMethod(env, obj, clazz, method_id, ...)
//}
// fn C.CallNonvirtualDoubleMethodV(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jdouble
// pub fn call_nonvirtual_double_method_v(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, args C.va_list) f64 {
//	return C.CallNonvirtualDoubleMethodV(env, obj, clazz, method_id, args C.va_list)
//}
fn C.CallNonvirtualDoubleMethodA(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jdouble
pub fn call_nonvirtual_double_method_a(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, args &JavaValue) f64 {
	return j2v_double(C.CallNonvirtualDoubleMethodA(env, obj, clazz, method_id, args))
}

// fn C.CallNonvirtualVoidMethod(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, ...)
// pub fn call_nonvirtual_void_method(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, ...) {
//	return C.CallNonvirtualVoidMethod(env, obj, clazz, method_id, ...)
//}
// fn C.CallNonvirtualVoidMethodV(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args C.va_list)
// pub fn call_nonvirtual_void_method_v(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, args C.va_list) {
//	return C.CallNonvirtualVoidMethodV(env, obj, clazz, method_id, args C.va_list)
//}
fn C.CallNonvirtualVoidMethodA(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args &C.jvalue)
pub fn call_nonvirtual_void_method_a(env &Env, obj JavaObject, clazz JavaClass, method_id JavaMethodID, args &JavaValue) {
	C.CallNonvirtualVoidMethodA(env, obj, clazz, method_id, args)
}

//
fn C.GetFieldID(env &C.JNIEnv, clazz C.jclass, name charptr, sig charptr) C.jfieldID
pub fn get_field_id(env &Env, clazz JavaClass, name string, sig string) JavaFieldID {
	return C.GetFieldID(env, clazz, name.str, sig.str)
}

//
fn C.GetObjectField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID) C.jobject
pub fn get_object_field(env &Env, obj JavaObject, field_id JavaFieldID) JavaObject {
	return C.GetObjectField(env, obj, field_id)
}
fn C.GetBooleanField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID) C.jboolean
pub fn get_boolean_field(env &Env, obj JavaObject, field_id JavaFieldID) bool {
	return j2v_boolean(C.GetBooleanField(env, obj, field_id))
}
fn C.GetByteField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID) C.jbyte
pub fn get_byte_field(env &Env, obj JavaObject, field_id JavaFieldID) byte {
	return j2v_byte(C.GetByteField(env, obj, field_id))
}
fn C.GetCharField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID) C.jchar
pub fn get_char_field(env &Env, obj JavaObject, field_id JavaFieldID) rune {
	return j2v_char(C.GetCharField(env, obj, field_id))
}
fn C.GetShortField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID) C.jshort
pub fn get_short_field(env &Env, obj JavaObject, field_id JavaFieldID) i16 {
	return j2v_short(C.GetShortField(env, obj, field_id))
}
fn C.GetIntField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID) C.jint
pub fn get_int_field(env &Env, obj JavaObject, field_id JavaFieldID) int {
	return j2v_int(C.GetIntField(env, obj, field_id))
}
fn C.GetLongField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID) C.jlong
pub fn get_long_field(env &Env, obj JavaObject, field_id JavaFieldID) i64 {
	return j2v_long(C.GetLongField(env, obj, field_id))
}
fn C.GetFloatField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID) C.jfloat
pub fn get_float_field(env &Env, obj JavaObject, field_id JavaFieldID) f32 {
	return j2v_float(C.GetFloatField(env, obj, field_id))
}
fn C.GetDoubleField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID) C.jdouble
pub fn get_double_field(env &Env, obj JavaObject, field_id JavaFieldID) f64 {
	return j2v_double(C.GetDoubleField(env, obj, field_id))
}

//
fn C.SetObjectField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID, val C.jobject)
pub fn set_object_field(env &Env, obj JavaObject, field_id JavaFieldID, val JavaObject) {
	C.SetObjectField(env, obj, field_id, val)
}
fn C.SetBooleanField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID, val C.jboolean)
pub fn set_boolean_field(env &Env, obj JavaObject, field_id JavaFieldID, val bool) {
	C.SetBooleanField(env, obj, field_id, jboolean(val))
}
fn C.SetByteField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID, val C.jbyte)
pub fn set_byte_field(env &Env, obj JavaObject, field_id JavaFieldID, val byte) {
	C.SetByteField(env, obj, field_id, jbyte(val))
}
fn C.SetCharField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID, val C.jchar)
pub fn set_char_field(env &Env, obj JavaObject, field_id JavaFieldID, val rune) {
	C.SetCharField(env, obj, field_id, jchar(val))
}
fn C.SetShortField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID, val C.jshort)
pub fn set_short_field(env &Env, obj JavaObject, field_id JavaFieldID, val i16) {
	C.SetShortField(env, obj, field_id, jshort(val))
}
fn C.SetIntField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID, val C.jint)
pub fn set_int_field(env &Env, obj JavaObject, field_id JavaFieldID, val int) {
	C.SetIntField(env, obj, field_id, jint(val))
}
fn C.SetLongField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID, val C.jlong)
pub fn set_long_field(env &Env, obj JavaObject, field_id JavaFieldID, val i64) {
	C.SetLongField(env, obj, field_id, jlong(val))
}
fn C.SetFloatField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID, val C.jfloat)
pub fn set_float_field(env &Env, obj JavaObject, field_id JavaFieldID, val f32) {
	C.SetFloatField(env, obj, field_id, jfloat(val))
}
fn C.SetDoubleField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID, val C.jdouble)
pub fn set_double_field(env &Env, obj JavaObject, field_id JavaFieldID, val f64) {
	C.SetDoubleField(env, obj, field_id, jdouble(val))
}

//
fn C.GetStaticMethodID(env &C.JNIEnv, clazz C.jclass, name charptr, sig charptr) C.jmethodID
pub fn get_static_method_id(env &Env, clazz JavaClass, name string, sig string) JavaMethodID {
	$if debug {
		mid := C.GetStaticMethodID(env, clazz, name.str, sig.str)
		if exception_check(env) {
			exception_describe(env)
			if !isnil(mid) {
				o := C.MethodIDToObject(mid)
				delete_local_ref(env, o)
			}
			//clsn := get_class_name(env, clazz)
			panic(@MOD + '.' + @FN + ': an exception occured in jni.Env (${ptr_str(env)} couldn\'t find method "$name" with signature "$sig" on class "$clazz")')
		}
		return mid
	}
	return C.GetStaticMethodID(env, clazz, name.str, sig.str)
}

//
// fn C.CallStaticObjectMethod(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, ...) C.jobject
// fn C.CallStaticObjectMethodV(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jobject
fn C.CallStaticObjectMethodA(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jobject

// fn C.CallStaticBooleanMethod(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, ...) C.jboolean
// fn C.CallStaticBooleanMethodV(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jboolean
fn C.CallStaticBooleanMethodA(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jboolean

// fn C.CallStaticByteMethod(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, ...) C.jbyte
// fn C.CallStaticByteMethodV(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jbyte
fn C.CallStaticByteMethodA(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jbyte

// fn C.CallStaticCharMethod(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, ...) C.jchar
// fn C.CallStaticCharMethodV(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jchar
fn C.CallStaticCharMethodA(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jchar

// fn C.CallStaticShortMethod(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, ...) C.jshort
// fn C.CallStaticShortMethodV(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jshort
fn C.CallStaticShortMethodA(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jshort

// fn C.CallStaticIntMethod(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, ...) C.jint
// fn C.CallStaticIntMethodV(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jint
fn C.CallStaticIntMethodA(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jint

// fn C.CallStaticLongMethod(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, ...) C.jlong
// fn C.CallStaticLongMethodV(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jlong
fn C.CallStaticLongMethodA(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jlong

// fn C.CallStaticFloatMethod(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, ...) C.jfloat
// fn C.CallStaticFloatMethodV(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jfloat
fn C.CallStaticFloatMethodA(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jfloat

// fn C.CallStaticDoubleMethod(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, ...) C.jdouble
// fn C.CallStaticDoubleMethodV(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jdouble
fn C.CallStaticDoubleMethodA(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jdouble

// fn C.CallStaticVoidMethod(env &C.JNIEnv, cls C.jclass, methodID C.jmethodID, ...)
// fn C.CallStaticVoidMethodV(env &C.JNIEnv, cls C.jclass, methodID C.jmethodID, args C.va_list)
fn C.CallStaticVoidMethodA(env &C.JNIEnv, cls C.jclass, methodID C.jmethodID, args &C.jvalue)

fn C.GetStaticFieldID(env &C.JNIEnv, clazz C.jclass, name charptr, sig charptr) C.jfieldID
fn C.GetStaticObjectField(env &C.JNIEnv, clazz C.jclass, fieldID C.jfieldID) C.jobject
fn C.GetStaticBooleanField(env &C.JNIEnv, clazz C.jclass, fieldID C.jfieldID) C.jboolean
fn C.GetStaticByteField(env &C.JNIEnv, clazz C.jclass, fieldID C.jfieldID) C.jbyte
fn C.GetStaticCharField(env &C.JNIEnv, clazz C.jclass, fieldID C.jfieldID) C.jchar
fn C.GetStaticShortField(env &C.JNIEnv, clazz C.jclass, fieldID C.jfieldID) C.jshort
fn C.GetStaticIntField(env &C.JNIEnv, clazz C.jclass, fieldID C.jfieldID) C.jint
fn C.GetStaticLongField(env &C.JNIEnv, clazz C.jclass, fieldID C.jfieldID) C.jlong
fn C.GetStaticFloatField(env &C.JNIEnv, clazz C.jclass, fieldID C.jfieldID) C.jfloat
fn C.GetStaticDoubleField(env &C.JNIEnv, clazz C.jclass, fieldID C.jfieldID) C.jdouble

fn C.SetStaticObjectField(env &C.JNIEnv, clazz C.jclass, fieldID C.jfieldID, value C.jobject)
fn C.SetStaticBooleanField(env &C.JNIEnv, clazz C.jclass, fieldID C.jfieldID, value C.jboolean)
fn C.SetStaticByteField(env &C.JNIEnv, clazz C.jclass, fieldID C.jfieldID, value C.jbyte)
fn C.SetStaticCharField(env &C.JNIEnv, clazz C.jclass, fieldID C.jfieldID, value C.jchar)
fn C.SetStaticShortField(env &C.JNIEnv, clazz C.jclass, fieldID C.jfieldID, value C.jshort)
fn C.SetStaticIntField(env &C.JNIEnv, clazz C.jclass, fieldID C.jfieldID, value C.jint)
fn C.SetStaticLongField(env &C.JNIEnv, clazz C.jclass, fieldID C.jfieldID, value C.jlong)
fn C.SetStaticFloatField(env &C.JNIEnv, clazz C.jclass, fieldID C.jfieldID, value C.jfloat)
fn C.SetStaticDoubleField(env &C.JNIEnv, clazz C.jclass, fieldID C.jfieldID, value C.jdouble)

fn C.NewString(env &C.JNIEnv, unicode &C.jchar, len C.jsize) C.jstring
fn C.GetStringLength(env &C.JNIEnv, str C.jstring) C.jsize
fn C.GetStringChars(env &C.JNIEnv, str C.jstring, isCopy &C.jboolean) &C.jchar
fn C.ReleaseStringChars(env &C.JNIEnv, str C.jstring, chars &C.jchar)

fn C.NewStringUTF(env &C.JNIEnv, utf charptr) C.jstring
fn C.GetStringUTFLength(env &C.JNIEnv, str C.jstring) C.jsize
fn C.GetStringUTFChars(env &C.JNIEnv, str C.jstring, isCopy &C.jboolean) charptr
fn C.ReleaseStringUTFChars(env &C.JNIEnv, str C.jstring, chars charptr)

fn C.GetArrayLength(env &C.JNIEnv, array C.jarray) C.jsize

fn C.NewObjectArray(env &C.JNIEnv, len C.jsize, clazz C.jclass, init C.jobject) C.jobjectArray
fn C.GetObjectArrayElement(env &C.JNIEnv, array C.jobjectArray, index C.jsize) C.jobject
fn C.SetObjectArrayElement(env &C.JNIEnv, array C.jobjectArray, index C.jsize, val C.jobject)

fn C.NewBooleanArray(env &C.JNIEnv, len C.jsize) C.jbooleanArray
fn C.NewByteArray(env &C.JNIEnv, len C.jsize) C.jbyteArray
fn C.NewCharArray(env &C.JNIEnv, len C.jsize) C.jcharArray
fn C.NewShortArray(env &C.JNIEnv, len C.jsize) C.jshortArray
fn C.NewIntArray(env &C.JNIEnv, len C.jsize) C.jintArray
fn C.NewLongArray(env &C.JNIEnv, len C.jsize) C.jlongArray
fn C.NewFloatArray(env &C.JNIEnv, len C.jsize) C.jfloatArray
fn C.NewDoubleArray(env &C.JNIEnv, len C.jsize) C.jdoubleArray

fn C.GetBooleanArrayElements(env &C.JNIEnv, array C.jbooleanArray, isCopy &C.jboolean) &C.jboolean
fn C.GetByteArrayElements(env &C.JNIEnv, array C.jbyteArray, isCopy &C.jboolean) &C.jbyte
fn C.GetCharArrayElements(env &C.JNIEnv, array C.jcharArray, isCopy &C.jboolean) &C.jchar
fn C.GetShortArrayElements(env &C.JNIEnv, array C.jshortArray, isCopy &C.jboolean) &C.jshort
fn C.GetIntArrayElements(env &C.JNIEnv, array C.jintArray, isCopy &C.jboolean) &C.jint
fn C.GetLongArrayElements(env &C.JNIEnv, array C.jlongArray, isCopy &C.jboolean) &C.jlong
fn C.GetFloatArrayElements(env &C.JNIEnv, array C.jfloatArray, isCopy &C.jboolean) &C.jfloat
fn C.GetDoubleArrayElements(env &C.JNIEnv, array C.jdoubleArray, isCopy &C.jboolean) &C.jdouble

fn C.ReleaseBooleanArrayElements(env &C.JNIEnv, array C.jbooleanArray, elems &C.jboolean, mode C.jint)
fn C.ReleaseByteArrayElements(env &C.JNIEnv, array C.jbyteArray, elems &C.jbyte, mode C.jint)
fn C.ReleaseCharArrayElements(env &C.JNIEnv, array C.jcharArray, elems &C.jchar, mode C.jint)
fn C.ReleaseShortArrayElements(env &C.JNIEnv, array C.jshortArray, elems &C.jshort, mode C.jint)
fn C.ReleaseIntArrayElements(env &C.JNIEnv, array C.jintArray, elems &C.jint, mode C.jint)
fn C.ReleaseLongArrayElements(env &C.JNIEnv, array C.jlongArray, elems &C.jlong, mode C.jint)
fn C.ReleaseFloatArrayElements(env &C.JNIEnv, array C.jfloatArray, elems &C.jfloat, mode C.jint)
fn C.ReleaseDoubleArrayElements(env &C.JNIEnv, array C.jdoubleArray, elems &C.jdouble, mode C.jint)

fn C.GetBooleanArrayRegion(env &C.JNIEnv, array C.jbooleanArray, start C.jsize, l C.jsize, buf &C.jboolean)
fn C.GetByteArrayRegion(env &C.JNIEnv, array C.jbyteArray, start C.jsize, len C.jsize, buf &C.jbyte)
fn C.GetCharArrayRegion(env &C.JNIEnv, array C.jcharArray, start C.jsize, len C.jsize, buf &C.jchar)
fn C.GetShortArrayRegion(env &C.JNIEnv, array C.jshortArray, start C.jsize, len C.jsize, buf &C.jshort)
fn C.GetIntArrayRegion(env &C.JNIEnv, array C.jintArray, start C.jsize, len C.jsize, buf &C.jint)
fn C.GetLongArrayRegion(env &C.JNIEnv, array C.jlongArray, start C.jsize, len C.jsize, buf &C.jlong)
fn C.GetFloatArrayRegion(env &C.JNIEnv, array C.jfloatArray, start C.jsize, len C.jsize, buf &C.jfloat)
fn C.GetDoubleArrayRegion(env &C.JNIEnv, array C.jdoubleArray, start C.jsize, len C.jsize, buf &C.jdouble)

fn C.SetBooleanArrayRegion(env &C.JNIEnv, array C.jbooleanArray, start C.jsize, l C.jsize, buf &C.jboolean)
fn C.SetByteArrayRegion(env &C.JNIEnv, array C.jbyteArray, start C.jsize, len C.jsize, buf &C.jbyte)
fn C.SetCharArrayRegion(env &C.JNIEnv, array C.jcharArray, start C.jsize, len C.jsize, buf &C.jchar)
fn C.SetShortArrayRegion(env &C.JNIEnv, array C.jshortArray, start C.jsize, len C.jsize, buf &C.jshort)
fn C.SetIntArrayRegion(env &C.JNIEnv, array C.jintArray, start C.jsize, len C.jsize, buf &C.jint)
fn C.SetLongArrayRegion(env &C.JNIEnv, array C.jlongArray, start C.jsize, len C.jsize, buf &C.jlong)
fn C.SetFloatArrayRegion(env &C.JNIEnv, array C.jfloatArray, start C.jsize, len C.jsize, buf &C.jfloat)
fn C.SetDoubleArrayRegion(env &C.JNIEnv, array C.jdoubleArray, start C.jsize, len C.jsize, buf &C.jdouble)

fn C.RegisterNatives(env &C.JNIEnv, clazz C.jclass, methods &C.JNINativeMethod, nMethods C.jint) C.jint
fn C.UnregisterNatives(env &C.JNIEnv, clazz C.jclass) C.jint

fn C.MonitorEnter(env &C.JNIEnv, obj C.jobject) C.jint
fn C.MonitorExit(env &C.JNIEnv, obj C.jobject) C.jint

fn C.GetJavaVM(env &C.JNIEnv, vm voidptr) C.jint

fn C.GetStringRegion(env &C.JNIEnv, str C.jstring, start C.jsize, len C.jsize, buf &C.jchar)
fn C.GetStringUTFRegion(env &C.JNIEnv, str C.jstring, start C.jsize, len C.jsize, buf charptr)

fn C.GetPrimitiveArrayCritical(env &C.JNIEnv, array C.jarray, isCopy &C.jboolean) voidptr
fn C.ReleasePrimitiveArrayCritical(env &C.JNIEnv, array C.jarray, carray voidptr, mode C.jint)

fn C.GetStringCritical(env &C.JNIEnv, string C.jstring, isCopy &C.jboolean) &C.jchar
fn C.ReleaseStringCritical(env &C.JNIEnv, string C.jstring, cstring &C.jchar)

fn C.NewWeakGlobalRef(env &C.JNIEnv, obj C.jobject) C.jweak
fn C.DeleteWeakGlobalRef(env &C.JNIEnv, ref C.jweak)

fn C.ExceptionCheck(env &C.JNIEnv) C.jboolean
pub fn exception_check(env &Env) bool {
	return j2v_boolean(C.ExceptionCheck(env))
}

fn C.NewDirectByteBuffer(env &C.JNIEnv, address voidptr, capacity C.jlong) C.jobject
fn C.GetDirectBufferAddress(env &C.JNIEnv, buf C.jobject) voidptr
fn C.GetDirectBufferCapacity(env &C.JNIEnv, buf C.jobject) C.jlong

// New JNI 1.6 Features

fn C.GetObjectRefType(env &C.JNIEnv, obj C.jobject) C.jobjectRefType
