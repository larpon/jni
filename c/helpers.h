// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package

static JavaVM* gJavaVM;

void jniSetJavaVM(JavaVM* vm) {
  //LOGI("jniSetJavaVM");
  gJavaVM = vm;
}

// Called to save JavaVM if library is loaded from Java:
int JNI_OnLoad(JavaVM* vm, void* reserved) {
  //LOGI("JNI_OnLoad: saving gJavaVM");
  jniSetJavaVM(vm);

  return JNI_VERSION_1_6;
}

JavaVM* jniGetJavaVM() {
  return gJavaVM;
}

// Utility function to get JNIEnv
JNIEnv* jniGetEnv() {
  JNIEnv *env;
  if (gJavaVM == 0) {
    //LOGE("Invalid global Java VM");
    return 0;
  }

  int status;
  status = (*gJavaVM)->GetEnv(gJavaVM,(void **) &env, JNI_VERSION_1_6);
  if (status < 0) {
    //LOGW("Failed to get JNI environment, trying to attach thread");
    // Try to attach native thread to JVM:
    status = (*gJavaVM)->AttachCurrentThread(gJavaVM, &env, 0);
    if (status < 0) {
      //LOGE("Failed to attach current thread to JVM");
      return 0;
    }
  }

  return env;
}

jobject StringToObject(jstring str) {
    return (jobject)str;
}

jstring ObjectToString(jobject obj) {
    return (jstring)obj;
}

jclass ObjectToClass(jobject obj) {
    return (jclass)obj;
}

jobject ClassToObject(jclass cls) {
    return (jobject)cls;
}

#define vc_cast(from, to) (to)from;

//#define JEnvCall_1(env, call, arg1)              (*env)->call(env, arg1)
//#define JEnvCall_2(env, call, arg1, arg2)        (*env)->call(env, arg1, arg2)
//#define JEnvCall_3(env, call, arg1, arg2, arg3)  (*env)->call(env, arg1, arg2, arg3)
