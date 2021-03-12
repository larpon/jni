// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
module jni

pub fn env() &Env {
	return C.jniGetEnv()
}

pub fn vm() &JavaVM {
	return C.jniGetJavaVM()
}

type JavaVM = C.JavaVM
type Env = C.JNIEnv
//type JavaByte = C.jbyte
type JavaObject = C.jobject
type JavaString = C.jstring
type JavaClass = C.jclass
type JavaMethodID = C.jmethodID
type JavaFieldID = C.jfieldID
type JavaThrowable = C.jthrowable
type JavaValue = C.jvalue

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

// TODO
pub fn get_object_class(env &Env, obj JavaObject) JavaClass {
	return C.GetObjectClass(env, obj)
}

// jni.h / jni_wrapper.h

fn C.GetVersion(env &C.JNIEnv) C.jint
pub fn get_version(env &Env) int {
	return int( C.GetVersion(env) )
}

fn C.DefineClass(env &C.JNIEnv, name charptr, loader C.jobject, buf &C.jbyte, len int) C.jclass
// NOTE: unsure about `buf` (C.jbyte -> signed char) and `len` (C.jsize -> C.jint) types.
pub fn define_class(env &Env, name string, loader JavaObject, buf byteptr, len int) JavaClass {
	return C.DefineClass(env, name.str, loader, buf, len)
}
fn C.FindClass(env &C.JNIEnv, name charptr) C.jclass
pub fn find_class(env &Env, name string) JavaClass {
	return C.FindClass(env, name.str)
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
	return j2v_int(C.EnsureLocalCapacity(env, j2v_int(capacity)))
}

fn C.AllocObject(env &C.JNIEnv, clazz C.jclass) C.jobject
pub fn alloc_object(env &Env, clazz JavaClass) JavaObject {
	return C.AllocObject(env, clazz)
}
//fn C.NewObject(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, ...) C.jobject
//pub fn new_object(env &Env, clazz JavaClass, methodID JavaMethodID, ...) JavaObject {
//	return C.NewObject(env, clazz, methodID, ...)
//}
//fn C.NewObjectV(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jobject
//pub fn new_object(env &Env, clazz JavaClass, methodID JavaMethodID, args C.va_list) JavaObject {
//	return C.NewObjectV(env, clazz, methodID, args)
//}
fn C.NewObjectA(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jobject
pub fn new_object_a(env &Env, clazz JavaClass, methodID JavaMethodID, args &JavaValue) JavaObject {
	return C.NewObjectA(env, clazz, methodID, args)
}


fn C.GetObjectClass(env &C.JNIEnv, obj C.jobject) C.jclass
fn C.IsInstanceOf(env &C.JNIEnv, obj C.jobject, clazz C.jclass) C.jboolean

fn C.GetMethodID(env &C.JNIEnv, clazz C.jclass, name charptr, sig charptr) C.jmethodID

//fn C.CallObjectMethod(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, ...) C.jobject
//fn C.CallObjectMethodV(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args C.va_list) C.jobject
fn C.CallObjectMethodA(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args &C.jvalue) C.jobject

//fn C.CallBooleanMethod(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, ...) C.jboolean
//fn C.CallBooleanMethodV(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args C.va_list) C.jboolean
fn C.CallBooleanMethodA(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args &C.jvalue) C.jboolean

//fn C.CallByteMethod(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, ...) C.jbyte
//fn C.CallByteMethodV(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args C.va_list) C.jbyte
fn C.CallByteMethodA(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args &C.jvalue) C.jbyte

//fn C.CallCharMethod(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, ...) C.jchar
//fn C.CallCharMethodV(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args C.va_list) C.jchar
fn C.CallCharMethodA(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args &C.jvalue) C.jchar

//fn C.CallShortMethod(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, ...) C.jshort
//fn C.CallShortMethodV(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args C.va_list) C.jshort
fn C.CallShortMethodA(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args &C.jvalue) C.jshort

//fn C.CallIntMethod(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, ...) C.jint
//fn C.CallIntMethodV(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args C.va_list) C.jint
fn C.CallIntMethodA(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args &C.jvalue) C.jint

//fn C.CallLongMethod(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, ...) C.jlong
//fn C.CallLongMethodV(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args C.va_list) C.jlong
fn C.CallLongMethodA(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args &C.jvalue) C.jlong

//fn C.CallFloatMethod(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, ...) C.jfloat
//fn C.CallFloatMethodV(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args C.va_list) C.jfloat
fn C.CallFloatMethodA(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args &C.jvalue) C.jfloat

//fn C.CallDoubleMethod(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, ...) C.jdouble
//fn C.CallDoubleMethodV(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args C.va_list) C.jdouble
fn C.CallDoubleMethodA(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args &C.jvalue) C.jdouble

//fn C.CallVoidMethod(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, ...)
//fn C.CallVoidMethodV(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args C.va_list)
fn C.CallVoidMethodA(env &C.JNIEnv, obj C.jobject, methodID C.jmethodID, args &C.jvalue)

//fn C.CallNonvirtualObjectMethod(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, ...) C.jobject
//fn C.CallNonvirtualObjectMethodV(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jobject
fn C.CallNonvirtualObjectMethodA(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jobject

//fn C.CallNonvirtualBooleanMethod(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, ...) C.jboolean
//fn C.CallNonvirtualBooleanMethodV(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jboolean
fn C.CallNonvirtualBooleanMethodA(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jboolean

//fn C.CallNonvirtualByteMethod(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, ...) C.jbyte
//fn C.CallNonvirtualByteMethodV(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jbyte
fn C.CallNonvirtualByteMethodA(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jbyte

//fn C.CallNonvirtualCharMethod(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, ...) C.jchar
//fn C.CallNonvirtualCharMethodV(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jchar
fn C.CallNonvirtualCharMethodA(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jchar

//fn C.CallNonvirtualShortMethod(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, ...) C.jshort
//fn C.CallNonvirtualShortMethodV(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jshort
fn C.CallNonvirtualShortMethodA(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jshort

//fn C.CallNonvirtualIntMethod(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, ...) C.jint
//fn C.CallNonvirtualIntMethodV(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jint
fn C.CallNonvirtualIntMethodA(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jint

//fn C.CallNonvirtualLongMethod(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, ...) C.jlong
//fn C.CallNonvirtualLongMethodV(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jlong
fn C.CallNonvirtualLongMethodA(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jlong

//fn C.CallNonvirtualFloatMethod(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, ...) C.jfloat
//fn C.CallNonvirtualFloatMethodV(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jfloat
fn C.CallNonvirtualFloatMethodA(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jfloat

//fn C.CallNonvirtualDoubleMethod(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, ...) C.jdouble
//fn C.CallNonvirtualDoubleMethodV(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jdouble
fn C.CallNonvirtualDoubleMethodA(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jdouble

//fn C.CallNonvirtualVoidMethod(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, ...)
//fn C.CallNonvirtualVoidMethodV(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args C.va_list)
fn C.CallNonvirtualVoidMethodA(env &C.JNIEnv, obj C.jobject, clazz C.jclass, methodID C.jmethodID, args &C.jvalue)

fn C.GetFieldID(env &C.JNIEnv, clazz C.jclass, name charptr, sig charptr) C.jfieldID

fn C.GetObjectField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID) C.jobject
fn C.GetBooleanField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID) C.jboolean
fn C.GetByteField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID) C.jbyte
fn C.GetCharField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID) C.jchar
fn C.GetShortField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID) C.jshort
fn C.GetIntField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID) C.jint
fn C.GetLongField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID) C.jlong
fn C.GetFloatField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID) C.jfloat
fn C.GetDoubleField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID) C.jdouble

fn C.SetObjectField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID, val C.jobject)
fn C.SetBooleanField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID, val C.jboolean)
fn C.SetByteField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID, val C.jbyte)
fn C.SetCharField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID, val C.jchar)
fn C.SetShortField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID, val C.jshort)
fn C.SetIntField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID, val C.jint)
fn C.SetLongField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID, val C.jlong)
fn C.SetFloatField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID, val C.jfloat)
fn C.SetDoubleField(env &C.JNIEnv, obj C.jobject, fieldID C.jfieldID, val C.jdouble)

fn C.GetStaticMethodID(env &C.JNIEnv, clazz C.jclass, name charptr, sig charptr) C.jmethodID

//fn C.CallStaticObjectMethod(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, ...) C.jobject
//fn C.CallStaticObjectMethodV(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jobject
fn C.CallStaticObjectMethodA(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jobject

//fn C.CallStaticBooleanMethod(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, ...) C.jboolean
//fn C.CallStaticBooleanMethodV(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jboolean
fn C.CallStaticBooleanMethodA(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jboolean

//fn C.CallStaticByteMethod(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, ...) C.jbyte
//fn C.CallStaticByteMethodV(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jbyte
fn C.CallStaticByteMethodA(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jbyte

//fn C.CallStaticCharMethod(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, ...) C.jchar
//fn C.CallStaticCharMethodV(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jchar
fn C.CallStaticCharMethodA(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jchar

//fn C.CallStaticShortMethod(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, ...) C.jshort
//fn C.CallStaticShortMethodV(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jshort
fn C.CallStaticShortMethodA(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jshort

//fn C.CallStaticIntMethod(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, ...) C.jint
//fn C.CallStaticIntMethodV(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jint
fn C.CallStaticIntMethodA(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jint

//fn C.CallStaticLongMethod(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, ...) C.jlong
//fn C.CallStaticLongMethodV(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jlong
fn C.CallStaticLongMethodA(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jlong

//fn C.CallStaticFloatMethod(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, ...) C.jfloat
//fn C.CallStaticFloatMethodV(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jfloat
fn C.CallStaticFloatMethodA(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jfloat

//fn C.CallStaticDoubleMethod(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, ...) C.jdouble
//fn C.CallStaticDoubleMethodV(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args C.va_list) C.jdouble
fn C.CallStaticDoubleMethodA(env &C.JNIEnv, clazz C.jclass, methodID C.jmethodID, args &C.jvalue) C.jdouble

//fn C.CallStaticVoidMethod(env &C.JNIEnv, cls C.jclass, methodID C.jmethodID, ...)
//fn C.CallStaticVoidMethodV(env &C.JNIEnv, cls C.jclass, methodID C.jmethodID, args C.va_list)
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

fn C.NewDirectByteBuffer(env &C.JNIEnv, address voidptr, capacity C.jlong) C.jobject
fn C.GetDirectBufferAddress(env &C.JNIEnv, buf C.jobject) voidptr
fn C.GetDirectBufferCapacity(env &C.JNIEnv, buf C.jobject) C.jlong

/* New JNI 1.6 Features */

fn C.GetObjectRefType(env &C.JNIEnv, obj C.jobject) C.jobjectRefType
