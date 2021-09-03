// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
#include <stdarg.h>
#include <stdio.h>

#ifdef __ANDROID__
#include <android/log.h>
#define V_JNI_ANDROID_LOG_TAG "V_ANDROID"
#define V_JNI_ANDROID_LOG_I(...) __android_log_print(ANDROID_LOG_INFO, V_JNI_ANDROID_LOG_TAG, __VA_ARGS__)
#define V_JNI_ANDROID_LOG_W(...) __android_log_print(ANDROID_LOG_WARN, V_JNI_ANDROID_LOG_TAG, __VA_ARGS__)
#define V_JNI_ANDROID_LOG_E(...) __android_log_print(ANDROID_LOG_ERROR, V_JNI_ANDROID_LOG_TAG, __VA_ARGS__)
#define V_JNI_ANDROID_LOG_D(...) __android_log_print(ANDROID_LOG_DEBUG, V_JNI_ANDROID_LOG_TAG, __VA_ARGS__)
#endif

static JavaVM* gJavaVM;

static jobject gClassLoader;
static jmethodID gFindClassMethod;

void __v_jni_log_i(const char *fmt, ...) {
	va_list args;
    va_start(args, fmt);
	#ifdef __ANDROID__
		V_JNI_ANDROID_LOG_I(fmt, args);
	#else
		vprintf(fmt, args);
	#endif
	va_end(args);
}

void __v_jni_log_w(const char *fmt, ...) {
	va_list args;
    va_start(args, fmt);
	#ifdef __ANDROID__
		V_JNI_ANDROID_LOG_W(fmt, args);
	#else
		vprintf(fmt, args);
	#endif
	va_end(args);
}

void __v_jni_log_e(const char *fmt, ...) {
	va_list args;
    va_start(args, fmt);
	#ifdef __ANDROID__
		V_JNI_ANDROID_LOG_E(fmt, args);
	#else
		vprintf(fmt, args);
	#endif
	va_end(args);
}

void __v_jni_log_d(const char *fmt, ...) {
	#if defined(_VDEBUG)
	{
		va_list args;
		va_start(args, fmt);
		#ifdef __ANDROID__
			V_JNI_ANDROID_LOG_D(fmt, args);
		#else
			vprintf(fmt, args);
		#endif
		va_end(args);
	}
	#endif
}

void gSetJavaVM(JavaVM* vm) {
	__v_jni_log_d("jni.c.gSetJavaVM %p", vm);
	gJavaVM = vm;
}

JavaVM* gGetJavaVM() {
	return gJavaVM;
}

// Utility function to get JNIEnv
JNIEnv* gGetEnv() {
	JNIEnv *env;
	if (gJavaVM == 0) {
		__v_jni_log_e("jni.c: (gGetEnv) Invalid global Java VM");
		return 0;
	}

	int status;
	status = (*gJavaVM)->GetEnv(gJavaVM,(void **) &env, JNI_VERSION_1_6);

	if (status < 0) {
		__v_jni_log_i("jni.c: Attaching thread to get JNI environment from Java VM %p", gJavaVM);
		// Try to attach native thread to JVM:
		status = (*gJavaVM)->AttachCurrentThread(gJavaVM, &env, 0);
		if (status < 0) {
			__v_jni_log_e("jni.c: Failed to attach current thread to Java VM %p", gJavaVM);
			return 0;
		}
		__v_jni_log_i("jni.c: Attached to thread successfully");
	}

	return env;
}

/*
gEnvNeedDetach allows you to see if the VM needs detach when you're done
using the JNIEnv. In the real world this isn't very nice to work with since
all calls retrieving a JNIEnv pointer need to check the need_detach and detach
the current thread accordingly...

Example usage of gEnvNeedDetach:

jclass gFindClass(const char *name) {
	JNIEnv *env;
	bool need_detach = gEnvNeedDetach(&env);

	jclass clz = (*env)->CallObjectMethod(env, gClassLoader, gFindClassMethod, (*env)->NewStringUTF(env, name));

	if (need_detach) {
		JavaVM *vm = gGetJavaVM();
        (*vm)->DetachCurrentThread(vm);
    }

	return clz;
}
*/
bool gEnvNeedDetach(JNIEnv **env) {
	if (gJavaVM == 0) {
		__v_jni_log_e("jni.c: (gGetEnvShouldDetach) Invalid global Java VM");
		return 0;
	}
	// Get current thread JNI environment
	JavaVM *vm = gGetJavaVM();
	*env = NULL;

	if ((*vm)->GetEnv(vm, (void**)env, JNI_VERSION_1_6) == JNI_OK) {
		return false;
	}

	JavaVMAttachArgs args = {
		.version  = JNI_VERSION_1_6,
		.name = "NativeThread",
		.group = NULL
	};

	if ((*vm)->AttachCurrentThread(vm, env, &args) != JNI_OK) {
		return false;
	}

	return true;
}

void gDetachThread() {
	JavaVM *vm = gGetJavaVM();
	(*vm)->DetachCurrentThread(vm);
}

jclass gFindClass(const char *name) {
	JNIEnv *env = gGetEnv();
	return (*env)->CallObjectMethod(env, gClassLoader, gFindClassMethod, (*env)->NewStringUTF(env, name));
}

void gSetupAndroid(const char *fqActivityName) {
	#ifdef __ANDROID__
	__v_jni_log_d("jni.c.gSetupAndroid()");
	__v_jni_log_d(fqActivityName);
	JNIEnv *env = gGetEnv();
	//replace with one of your classes in the line below
	__v_jni_log_d("jni.c.gSetupAndroid() finding activity class...");
	jclass randomClass = (*env)->FindClass(env, fqActivityName);
	__v_jni_log_d("jni.c.gSetupAndroid() FindClass %p", randomClass);
	if (ExceptionCheck(env) == JNI_TRUE) { ExceptionDescribe(env); }
	jclass classClass = (*env)->GetObjectClass(env, randomClass);
	__v_jni_log_d("jni.c.gSetupAndroid() GetObjectClass %p", classClass);
	if (ExceptionCheck(env) == JNI_TRUE) { ExceptionDescribe(env); }
	jclass classLoaderClass = (*env)->FindClass(env, "java/lang/ClassLoader");
	__v_jni_log_d("jni.c.gSetupAndroid() FindClass %p", classLoaderClass);
	if (ExceptionCheck(env) == JNI_TRUE) { ExceptionDescribe(env); }
	jmethodID getClassLoaderMethod = (*env)->GetMethodID(env, classClass, "getClassLoader", "()Ljava/lang/ClassLoader;");
	__v_jni_log_d("jni.c.gSetupAndroid() GetMethodID %d", getClassLoaderMethod);
	if (ExceptionCheck(env) == JNI_TRUE) { ExceptionDescribe(env); }
	gClassLoader = (*env)->NewGlobalRef(env, (*env)->CallObjectMethod(env, randomClass, getClassLoaderMethod));
	__v_jni_log_d("jni.c.gSetupAndroid() gClassLoader %p", gClassLoader);
	if (ExceptionCheck(env) == JNI_TRUE) { ExceptionDescribe(env); }
	gFindClassMethod = (*env)->GetMethodID(env, classLoaderClass, "findClass", "(Ljava/lang/String;)Ljava/lang/Class;");
	__v_jni_log_d("jni.c.gSetupAndroid() GetMethodID %d", gFindClassMethod);
	if (ExceptionCheck(env) == JNI_TRUE) { ExceptionDescribe(env); }
	#endif
}
