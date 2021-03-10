// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
module jni

/*
typedef unsigned char   jboolean;
typedef unsigned short  jchar;
typedef short           jshort;
typedef float           jfloat;
typedef double          jdouble;

typedef jint            jsize;
*/

type JavaVM = C.JavaVM
type Env = C.JNIEnv
type JavaObject = C.jobject
type JavaString = C.jstring
type JavaClass = C.jclass
type JavaMethodID = C.jmethodID
type JavaFieldID = C.jfieldID
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

// helpers.h
// fn C.vc_cast(from voidptr, to voidptr) voidptr
fn C.StringToObject(str C.jstring) C.jobject

fn C.ObjectToString(obj C.jobject) C.jstring

fn C.ObjectToClass(obj C.jobject) C.jclass

fn C.ClassToObject(cls C.jclass) C.jobject

fn C.MethodIDToObject(cls C.jmethodID) C.jobject

fn C.jniGetEnv() &C.JNIEnv

fn C.jniSetJavaVM(vm &JavaVM)

fn C.jniFindClass(name charptr) C.jclass

fn C.jniSetupAndroid(name charptr)

// jni_wrapper.h
fn C.FindClass(env &C.JNIEnv, name charptr) C.jclass

fn C.DeleteLocalRef(env &C.JNIEnv, obj C.jobject)

// jni.h // TODO lots of missing func defs
// Exceptions
fn C.ExceptionClear(env &C.JNIEnv)

//
fn C.ExceptionDescribe(env &C.JNIEnv)

//
fn C.ExceptionCheck(env &C.JNIEnv) C.jboolean

//
fn C.ThrowNew(env &C.JNIEnv, clazz C.jclass, msg charptr) C.jint

// Unicode / jchar
fn C.NewString(env &C.JNIEnv, unicode charptr, len C.jsize) C.jstring

fn C.GetStringLength(env &C.JNIEnv, jstr C.jstring) C.jsize

fn C.GetStringChars(env &C.JNIEnv, jstr C.jstring, is_copy &C.jboolean) &C.jchar

fn C.ReleaseStringChars(env &C.JNIEnv, jstr C.jstring, chars &C.jchar)

// UTF-8
fn C.NewStringUTF(env &C.JNIEnv, utf charptr) C.jstring

fn C.GetStringUTFChars(env &C.JNIEnv, jstr C.jstring, b C.jboolean) charptr

fn C.ReleaseStringUTFChars(env &C.JNIEnv, jstr C.jstring, chars charptr)

//
fn C.GetMethodID(env &C.JNIEnv, clazz C.jclass, name charptr, sig charptr) C.jmethodID

fn C.GetStaticFieldID(env &C.JNIEnv, clazz C.jclass, name charptr, sig charptr) C.jfieldID
fn C.GetStaticObjectField(env &C.JNIEnv, clazz C.jclass, fieldID C.jfieldID) C.jobject
// jboolean GetStaticBooleanField(JNIEnv *env, jclass clazz, jfieldID fieldID)
// jbyte GetStaticByteField(JNIEnv *env, jclass clazz, jfieldID fieldID)
// jchar GetStaticCharField(JNIEnv *env, jclass clazz, jfieldID fieldID)
// jshort GetStaticShortField(JNIEnv *env, jclass clazz, jfieldID fieldID)
// jint GetStaticIntField(JNIEnv *env, jclass clazz, jfieldID fieldID)
// jlong GetStaticLongField(JNIEnv *env, jclass clazz, jfieldID fieldID)
// jfloat GetStaticFloatField(JNIEnv *env, jclass clazz, jfieldID fieldID)
// jdouble GetStaticDoubleField(JNIEnv *env, jclass clazz, jfieldID fieldID)

// void SetStaticObjectField(JNIEnv *env, jclass clazz, jfieldID fieldID, jobject value)
// void SetStaticBooleanField(JNIEnv *env, jclass clazz, jfieldID fieldID, jboolean value)
// void SetStaticByteField(JNIEnv *env, jclass clazz, jfieldID fieldID, jbyte value)
// void SetStaticCharField(JNIEnv *env, jclass clazz, jfieldID fieldID, jchar value)
// void SetStaticShortField(JNIEnv *env, jclass clazz, jfieldID fieldID, jshort value)
// void SetStaticIntField(JNIEnv *env, jclass clazz, jfieldID fieldID, jint value)
// void SetStaticLongField(JNIEnv *env, jclass clazz, jfieldID fieldID, jlong value)
// void SetStaticFloatField(JNIEnv *env, jclass clazz, jfieldID fieldID, jfloat value)
// void SetStaticDoubleField(JNIEnv *env, jclass clazz, jfieldID fieldID, jdouble value)

fn C.GetObjectClass(env &C.JNIEnv, obj C.jobject) C.jclass

fn C.GetStaticMethodID(env &C.JNIEnv, clazz C.jclass, name charptr, signature charptr) C.jmethodID

// Instance method calling (calling methods on Java object instances)
fn C.CallVoidMethodA(env &C.JNIEnv, obj C.jobject, method_id C.jmethodID, args &C.jvalue)

fn C.CallObjectMethodA(env &C.JNIEnv, obj C.jobject, method_id C.jmethodID, args &C.jvalue) C.jobject

fn C.CallBooleanMethodA(env &C.JNIEnv, obj C.jobject, method_id C.jmethodID, args &C.jvalue) C.jboolean

fn C.CallByteMethodA(env &C.JNIEnv, obj C.jobject, method_id C.jmethodID, args &C.jvalue) C.jbyte

fn C.CallCharMethodA(env &C.JNIEnv, obj C.jobject, method_id C.jmethodID, args &C.jvalue) C.jchar

fn C.CallShortMethodA(env &C.JNIEnv, obj C.jobject, method_id C.jmethodID, args &C.jvalue) C.jshort

fn C.CallIntMethodA(env &C.JNIEnv, obj C.jobject, method_id C.jmethodID, args &C.jvalue) C.jint

fn C.CallLongMethodA(env &C.JNIEnv, obj C.jobject, method_id C.jmethodID, args &C.jvalue) C.jlong

fn C.CallFloatMethodA(env &C.JNIEnv, obj C.jobject, method_id C.jmethodID, args &C.jvalue) C.jfloat

fn C.CallDoubleMethodA(env &C.JNIEnv, obj C.jobject, method_id C.jmethodID, args &C.jvalue) C.jdouble

// Static method calling (calling static methods on Java classes)
fn C.CallStaticVoidMethodA(env &C.JNIEnv, clazz C.jclass, method_id C.jmethodID, args &C.jvalue)

fn C.CallStaticObjectMethodA(env &C.JNIEnv, clazz C.jclass, method_id C.jmethodID, args &C.jvalue) JavaObject

fn C.CallStaticBooleanMethodA(env &C.JNIEnv, clazz C.jclass, method_id C.jmethodID, args &C.jvalue) C.jboolean

fn C.CallStaticByteMethodA(env &C.JNIEnv, clazz C.jclass, method_id C.jmethodID, args &C.jvalue) C.jbyte

fn C.CallStaticCharMethodA(env &C.JNIEnv, clazz C.jclass, method_id C.jmethodID, args &C.jvalue) C.jchar

fn C.CallStaticShortMethodA(env &C.JNIEnv, clazz C.jclass, method_id C.jmethodID, args &C.jvalue) C.jshort

fn C.CallStaticIntMethodA(env &C.JNIEnv, clazz C.jclass, method_id C.jmethodID, args &C.jvalue) C.jint

fn C.CallStaticLongMethodA(env &C.JNIEnv, clazz C.jclass, method_id C.jmethodID, args &C.jvalue) C.jlong

fn C.CallStaticFloatMethodA(env &C.JNIEnv, clazz C.jclass, method_id C.jmethodID, args &C.jvalue) C.jfloat

fn C.CallStaticDoubleMethodA(env &C.JNIEnv, clazz C.jclass, method_id C.jmethodID, args &C.jvalue) C.jdouble
