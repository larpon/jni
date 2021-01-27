// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
//
// Wrappers around the ´(*env)->´ calls to simplify calling them in V
// Taken from https://github.com/juntaki/jnigo/blob/872b55d7b4/jni_wrapper.c
// See jnigo.LICENSE that came with this source.
//
jint GetVersion(JNIEnv *env) {
    return (*env)->GetVersion(env);
}

jclass DefineClass(JNIEnv *env, const char *name, jobject loader, const jbyte *buf, jsize len) {
    return (*env)->DefineClass(env, name, loader, buf, len);
}
jclass FindClass(JNIEnv *env, const char *name) {
    return (*env)->FindClass(env, name);
}

jmethodID FromReflectedMethod(JNIEnv *env, jobject method) {
    return (*env)->FromReflectedMethod(env, method);
}
jfieldID FromReflectedField(JNIEnv *env, jobject field) {
    return (*env)->FromReflectedField(env, field);
}

jobject ToReflectedMethod(JNIEnv *env, jclass cls, jmethodID methodID, jboolean isStatic) {
    return (*env)->ToReflectedMethod(env, cls, methodID, isStatic);
}

jclass GetSuperclass(JNIEnv *env, jclass sub) {
    return (*env)->GetSuperclass(env, sub);
}
jboolean IsAssignableFrom(JNIEnv *env, jclass sub, jclass sup) {
    return (*env)->IsAssignableFrom(env, sub, sup);
}

jobject ToReflectedField(JNIEnv *env, jclass cls, jfieldID fieldID, jboolean isStatic) {
    return (*env)->ToReflectedField(env, cls, fieldID, isStatic);
}

jint Throw(JNIEnv *env, jthrowable obj) {
    return (*env)->Throw(env, obj);
}
jint ThrowNew(JNIEnv *env, jclass clazz, const char *msg) {
    return (*env)->ThrowNew(env, clazz, msg);
}
jthrowable ExceptionOccurred(JNIEnv *env) {
    return (*env)->ExceptionOccurred(env);
}
void ExceptionDescribe(JNIEnv *env) {
    return (*env)->ExceptionDescribe(env);
}
void ExceptionClear(JNIEnv *env) {
    return (*env)->ExceptionClear(env);
}
void FatalError(JNIEnv *env, const char *msg) {
    return (*env)->FatalError(env, msg);
}

jint PushLocalFrame(JNIEnv *env, jint capacity) {
    return (*env)->PushLocalFrame(env, capacity);
}
jobject PopLocalFrame(JNIEnv *env, jobject result) {
    return (*env)->PopLocalFrame(env, result);
}

jobject NewGlobalRef(JNIEnv *env, jobject lobj) {
    return (*env)->NewGlobalRef(env, lobj);
}
void DeleteGlobalRef(JNIEnv *env, jobject gref) {
    return (*env)->DeleteGlobalRef(env, gref);
}
void DeleteLocalRef(JNIEnv *env, jobject obj) {
    return (*env)->DeleteLocalRef(env, obj);
}
jboolean IsSameObject(JNIEnv *env, jobject obj1, jobject obj2) {
    return (*env)->IsSameObject(env, obj1, obj2);
}
jobject NewLocalRef(JNIEnv *env, jobject ref) {
    return (*env)->NewLocalRef(env, ref);
}
jint EnsureLocalCapacity(JNIEnv *env, jint capacity) {
    return (*env)->EnsureLocalCapacity(env, capacity);
}

jobject AllocObject(JNIEnv *env, jclass clazz) {
    return (*env)->AllocObject(env, clazz);
}
jobject NewObjectA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args) {
    return (*env)->NewObjectA(env, clazz, methodID, args);
}

jclass GetObjectClass(JNIEnv *env, jobject obj) {
    return (*env)->GetObjectClass(env, obj);
}
jboolean IsInstanceOf(JNIEnv *env, jobject obj, jclass clazz) {
    return (*env)->IsInstanceOf(env, obj, clazz);
}

jmethodID GetMethodID(JNIEnv *env, jclass clazz, const char *name, const char *sig) {
    return (*env)->GetMethodID(env, clazz, name, sig);
}

jobject CallObjectMethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args) {
    return (*env)->CallObjectMethodA(env,obj,methodID,args);
}

jboolean CallBooleanMethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args) {
    return (*env)->CallBooleanMethodA(env,obj,methodID,args);
}

jbyte CallByteMethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args) {
    return (*env)->CallByteMethodA(env,obj,methodID,args);
}

jchar CallCharMethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args) {
    return (*env)->CallCharMethodA(env,obj,methodID,args);
}

jshort CallShortMethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args) {
    return (*env)->CallShortMethodA(env,obj,methodID,args);
}

jint CallIntMethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args) {
    return (*env)->CallIntMethodA(env,obj,methodID,args);
}

jlong CallLongMethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args) {
    return (*env)->CallLongMethodA(env,obj,methodID,args);
}

jfloat CallFloatMethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args) {
    return (*env)->CallFloatMethodA(env,obj,methodID,args);
}

jdouble CallDoubleMethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args) {
    return (*env)->CallDoubleMethodA(env,obj,methodID,args);
}

void CallVoidMethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args) {
    return (*env)->CallVoidMethodA(env,obj,methodID,args);
}

jobject CallNonvirtualObjectMethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args) {
    return (*env)->CallNonvirtualObjectMethodA(env,obj,clazz,methodID,args);
}

jboolean CallNonvirtualBooleanMethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args) {
    return (*env)->CallNonvirtualBooleanMethodA(env,obj,clazz,methodID,args);
}

jbyte CallNonvirtualByteMethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args) {
    return (*env)->CallNonvirtualByteMethodA(env,obj,clazz,methodID,args);
}

jchar CallNonvirtualCharMethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args) {
    return (*env)->CallNonvirtualCharMethodA(env,obj,clazz,methodID,args);
}

jshort CallNonvirtualShortMethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args) {
    return (*env)->CallNonvirtualShortMethodA(env,obj,clazz,methodID,args);
}

jint CallNonvirtualIntMethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args) {
    return (*env)->CallNonvirtualIntMethodA(env,obj,clazz,methodID,args);
}

jlong CallNonvirtualLongMethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args) {
    return (*env)->CallNonvirtualLongMethodA(env,obj,clazz,methodID,args);
}

jfloat CallNonvirtualFloatMethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args) {
    return (*env)->CallNonvirtualFloatMethodA(env,obj,clazz,methodID,args);
}

jdouble CallNonvirtualDoubleMethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args) {
    return (*env)->CallNonvirtualDoubleMethodA(env,obj,clazz,methodID,args);
}

void CallNonvirtualVoidMethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args) {
    return (*env)->CallNonvirtualVoidMethodA(env,obj,clazz,methodID,args);
}

jfieldID GetFieldID(JNIEnv *env, jclass clazz, const char *name, const char *sig) {
    return (*env)->GetFieldID(env, clazz, name, sig);
}

jobject GetObjectField(JNIEnv *env, jobject obj, jfieldID fieldID) {
    return (*env)->GetObjectField(env,obj,fieldID);
}
jboolean GetBooleanField(JNIEnv *env, jobject obj, jfieldID fieldID) {
    return (*env)->GetBooleanField(env,obj,fieldID);
}
jbyte GetByteField(JNIEnv *env, jobject obj, jfieldID fieldID) {
    return (*env)->GetByteField(env,obj,fieldID);
}
jchar GetCharField(JNIEnv *env, jobject obj, jfieldID fieldID) {
    return (*env)->GetCharField(env,obj,fieldID);
}
jshort GetShortField(JNIEnv *env, jobject obj, jfieldID fieldID) {
    return (*env)->GetShortField(env,obj,fieldID);
}
jint GetIntField(JNIEnv *env, jobject obj, jfieldID fieldID) {
    return (*env)->GetIntField(env,obj,fieldID);
}
jlong GetLongField(JNIEnv *env, jobject obj, jfieldID fieldID) {
    return (*env)->GetLongField(env,obj,fieldID);
}
jfloat GetFloatField(JNIEnv *env, jobject obj, jfieldID fieldID) {
    return (*env)->GetFloatField(env,obj,fieldID);
}
jdouble GetDoubleField(JNIEnv *env, jobject obj, jfieldID fieldID) {
    return (*env)->GetDoubleField(env,obj,fieldID);
}

void SetObjectField(JNIEnv *env, jobject obj, jfieldID fieldID, jobject val) {
    return (*env)->SetObjectField(env,obj,fieldID,val);
}
void SetBooleanField(JNIEnv *env, jobject obj, jfieldID fieldID, jboolean val) {
    return (*env)->SetBooleanField(env,obj,fieldID,val);
}
void SetByteField(JNIEnv *env, jobject obj, jfieldID fieldID, jbyte val) {
    return (*env)->SetByteField(env,obj,fieldID,val);
}
void SetCharField(JNIEnv *env, jobject obj, jfieldID fieldID, jchar val) {
    return (*env)->SetCharField(env,obj,fieldID,val);
}
void SetShortField(JNIEnv *env, jobject obj, jfieldID fieldID, jshort val) {
    return (*env)->SetShortField(env,obj,fieldID,val);
}
void SetIntField(JNIEnv *env, jobject obj, jfieldID fieldID, jint val) {
    return (*env)->SetIntField(env,obj,fieldID,val);
}
void SetLongField(JNIEnv *env, jobject obj, jfieldID fieldID, jlong val) {
    return (*env)->SetLongField(env,obj,fieldID,val);
}
void SetFloatField(JNIEnv *env, jobject obj, jfieldID fieldID, jfloat val) {
    return (*env)->SetFloatField(env,obj,fieldID,val);
}
void SetDoubleField(JNIEnv *env, jobject obj, jfieldID fieldID, jdouble val) {
    return (*env)->SetDoubleField(env,obj,fieldID,val);
}

jmethodID GetStaticMethodID(JNIEnv *env, jclass clazz, const char *name, const char *sig) {
    return (*env)->GetStaticMethodID(env, clazz, name, sig);
}

jobject CallStaticObjectMethodA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args) {
    return (*env)->CallStaticObjectMethodA(env,clazz,methodID,args);
}

jboolean CallStaticBooleanMethodA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args) {
    return (*env)->CallStaticBooleanMethodA(env,clazz,methodID,args);
}

jbyte CallStaticByteMethodA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args) {
    return (*env)->CallStaticByteMethodA(env,clazz,methodID,args);
}

jchar CallStaticCharMethodA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args) {
    return (*env)->CallStaticCharMethodA(env,clazz,methodID,args);
}

jshort CallStaticShortMethodA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args) {
    return (*env)->CallStaticShortMethodA(env,clazz,methodID,args);
}

jint CallStaticIntMethodA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args) {
    return (*env)->CallStaticIntMethodA(env,clazz,methodID,args);
}

jlong CallStaticLongMethodA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args) {
    return (*env)->CallStaticLongMethodA(env,clazz,methodID,args);
}

jfloat CallStaticFloatMethodA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args) {
    return (*env)->CallStaticFloatMethodA(env,clazz,methodID,args);
}

jdouble CallStaticDoubleMethodA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args) {
    return (*env)->CallStaticDoubleMethodA(env,clazz,methodID,args);
}

void CallStaticVoidMethodA(JNIEnv *env, jclass cls, jmethodID methodID, const jvalue *args) {
    return (*env)->CallStaticVoidMethodA(env,cls,methodID,args);
}

jfieldID GetStaticFieldID(JNIEnv *env, jclass clazz, const char *name, const char *sig) {
    return (*env)->GetStaticFieldID(env, clazz, name, sig);
}
jobject GetStaticObjectField(JNIEnv *env, jclass clazz, jfieldID fieldID) {
    return (*env)->GetStaticObjectField(env,clazz,fieldID);
}
jboolean GetStaticBooleanField(JNIEnv *env, jclass clazz, jfieldID fieldID) {
    return (*env)->GetStaticBooleanField(env,clazz,fieldID);
}
jbyte GetStaticByteField(JNIEnv *env, jclass clazz, jfieldID fieldID) {
    return (*env)->GetStaticByteField(env,clazz,fieldID);
}
jchar GetStaticCharField(JNIEnv *env, jclass clazz, jfieldID fieldID) {
    return (*env)->GetStaticCharField(env,clazz,fieldID);
}
jshort GetStaticShortField(JNIEnv *env, jclass clazz, jfieldID fieldID) {
    return (*env)->GetStaticShortField(env,clazz,fieldID);
}
jint GetStaticIntField(JNIEnv *env, jclass clazz, jfieldID fieldID) {
    return (*env)->GetStaticIntField(env,clazz,fieldID);
}
jlong GetStaticLongField(JNIEnv *env, jclass clazz, jfieldID fieldID) {
    return (*env)->GetStaticLongField(env,clazz,fieldID);
}
jfloat GetStaticFloatField(JNIEnv *env, jclass clazz, jfieldID fieldID) {
    return (*env)->GetStaticFloatField(env,clazz,fieldID);
}
jdouble GetStaticDoubleField(JNIEnv *env, jclass clazz, jfieldID fieldID) {
    return (*env)->GetStaticDoubleField(env,clazz,fieldID);
}

void SetStaticObjectField(JNIEnv *env, jclass clazz, jfieldID fieldID, jobject value) {
    return (*env)->SetStaticObjectField(env,clazz,fieldID,value);
}
void SetStaticBooleanField(JNIEnv *env, jclass clazz, jfieldID fieldID, jboolean value) {
    return (*env)->SetStaticBooleanField(env,clazz,fieldID,value);
}
void SetStaticByteField(JNIEnv *env, jclass clazz, jfieldID fieldID, jbyte value) {
    return (*env)->SetStaticByteField(env,clazz,fieldID,value);
}
void SetStaticCharField(JNIEnv *env, jclass clazz, jfieldID fieldID, jchar value) {
    return (*env)->SetStaticCharField(env,clazz,fieldID,value);
}
void SetStaticShortField(JNIEnv *env, jclass clazz, jfieldID fieldID, jshort value) {
    return (*env)->SetStaticShortField(env,clazz,fieldID,value);
}
void SetStaticIntField(JNIEnv *env, jclass clazz, jfieldID fieldID, jint value) {
    return (*env)->SetStaticIntField(env,clazz,fieldID,value);
}
void SetStaticLongField(JNIEnv *env, jclass clazz, jfieldID fieldID, jlong value) {
    return (*env)->SetStaticLongField(env,clazz,fieldID,value);
}
void SetStaticFloatField(JNIEnv *env, jclass clazz, jfieldID fieldID, jfloat value) {
    return (*env)->SetStaticFloatField(env,clazz,fieldID,value);
}
void SetStaticDoubleField(JNIEnv *env, jclass clazz, jfieldID fieldID, jdouble value) {
    return (*env)->SetStaticDoubleField(env,clazz,fieldID,value);
}

jstring NewString(JNIEnv *env, const jchar *unicode, jsize len) {
    return (*env)->NewString(env, unicode, len);
}
jsize GetStringLength(JNIEnv *env, jstring str) {
    return (*env)->GetStringLength(env, str);
}
const jchar *GetStringChars(JNIEnv *env, jstring str, jboolean *isCopy) {
    return (*env)->GetStringChars(env,str,isCopy);
}
void ReleaseStringChars(JNIEnv *env, jstring str, const jchar *chars) {
    return (*env)->ReleaseStringChars(env, str, chars);
}

jstring NewStringUTF(JNIEnv *env, const char *utf) {
    return (*env)->NewStringUTF(env,utf);

}
jsize GetStringUTFLength(JNIEnv *env, jstring str) {
    return (*env)->GetStringUTFLength(env, str);
}
const char*GetStringUTFChars(JNIEnv *env, jstring str, jboolean *isCopy) {
    return (*env)->GetStringUTFChars(env,str,isCopy);
}
void ReleaseStringUTFChars(JNIEnv *env, jstring str, const char *chars) {
    return (*env)->ReleaseStringUTFChars(env, str, chars);
}

jsize GetArrayLength(JNIEnv *env, jarray array) {
    return (*env)->GetArrayLength(env, array);
}

jobjectArray NewObjectArray(JNIEnv *env, jsize len, jclass clazz, jobject init) {
    return (*env)->NewObjectArray(env,len,clazz,init);
}
jobject GetObjectArrayElement(JNIEnv *env, jobjectArray array, jsize index) {
    return (*env)->GetObjectArrayElement(env, array, index);
}
void SetObjectArrayElement(JNIEnv *env, jobjectArray array, jsize index, jobject val) {
    return (*env)->SetObjectArrayElement(env,array,index,val);
}

jbooleanArray NewBooleanArray(JNIEnv *env, jsize len) {
    return (*env)->NewBooleanArray(env, len);
}
jbyteArray NewByteArray(JNIEnv *env, jsize len) {
    return (*env)->NewByteArray(env, len);
}
jcharArray NewCharArray(JNIEnv *env, jsize len) {
    return (*env)->NewCharArray(env, len);
}
jshortArray NewShortArray(JNIEnv *env, jsize len) {
    return (*env)->NewShortArray(env, len);
}
jintArray NewIntArray(JNIEnv *env, jsize len) {
    return (*env)->NewIntArray(env, len);
}
jlongArray NewLongArray(JNIEnv *env, jsize len) {
    return (*env)->NewLongArray(env, len);
}
jfloatArray NewFloatArray(JNIEnv *env, jsize len) {
    return (*env)->NewFloatArray(env, len);
}
jdoubleArray NewDoubleArray(JNIEnv *env, jsize len) {
    return (*env)->NewDoubleArray(env, len);
}

jboolean *GetBooleanArrayElements(JNIEnv *env, jbooleanArray array, jboolean *isCopy) {
    return (*env)->GetBooleanArrayElements(env,array,isCopy);
}
jbyte *GetByteArrayElements(JNIEnv *env, jbyteArray array, jboolean *isCopy) {
    return (*env)->GetByteArrayElements(env,array,isCopy);
}
jchar *GetCharArrayElements(JNIEnv *env, jcharArray array, jboolean *isCopy) {
    return (*env)->GetCharArrayElements(env,array,isCopy);
}
jshort *GetShortArrayElements(JNIEnv *env, jshortArray array, jboolean *isCopy) {
    return (*env)->GetShortArrayElements(env,array,isCopy);
}
jint *GetIntArrayElements(JNIEnv *env, jintArray array, jboolean *isCopy) {
    return (*env)->GetIntArrayElements(env,array,isCopy);
}
jlong *GetLongArrayElements(JNIEnv *env, jlongArray array, jboolean *isCopy) {
    return (*env)->GetLongArrayElements(env,array,isCopy);
}
jfloat *GetFloatArrayElements(JNIEnv *env, jfloatArray array, jboolean *isCopy) {
    return (*env)->GetFloatArrayElements(env,array,isCopy);
}
jdouble *GetDoubleArrayElements(JNIEnv *env, jdoubleArray array, jboolean *isCopy) {
    return (*env)->GetDoubleArrayElements(env,array,isCopy);
}

void ReleaseBooleanArrayElements(JNIEnv *env, jbooleanArray array, jboolean *elems, jint mode) {
    return (*env)->ReleaseBooleanArrayElements(env,array,elems,mode);
}
void ReleaseByteArrayElements(JNIEnv *env, jbyteArray array, jbyte *elems, jint mode) {
    return (*env)->ReleaseByteArrayElements(env,array,elems,mode);
}
void ReleaseCharArrayElements(JNIEnv *env, jcharArray array, jchar *elems, jint mode) {
    return (*env)->ReleaseCharArrayElements(env,array,elems,mode);
}
void ReleaseShortArrayElements(JNIEnv *env, jshortArray array, jshort *elems, jint mode) {
    return (*env)->ReleaseShortArrayElements(env,array,elems,mode);
}
void ReleaseIntArrayElements(JNIEnv *env, jintArray array, jint *elems, jint mode) {
    return (*env)->ReleaseIntArrayElements(env,array,elems,mode);
}
void ReleaseLongArrayElements(JNIEnv *env, jlongArray array, jlong *elems, jint mode) {
    return (*env)->ReleaseLongArrayElements(env,array,elems,mode);
}
void ReleaseFloatArrayElements(JNIEnv *env, jfloatArray array, jfloat *elems, jint mode) {
    return (*env)->ReleaseFloatArrayElements(env,array,elems,mode);
}
void ReleaseDoubleArrayElements(JNIEnv *env, jdoubleArray array, jdouble *elems, jint mode) {
    return (*env)->ReleaseDoubleArrayElements(env,array,elems,mode);
}

void GetBooleanArrayRegion(JNIEnv *env, jbooleanArray array, jsize start, jsize l, jboolean *buf) {
    return (*env)->GetBooleanArrayRegion(env,array,start,l,buf);
}
void GetByteArrayRegion(JNIEnv *env, jbyteArray array, jsize start, jsize len, jbyte *buf) {
    return (*env)->GetByteArrayRegion(env,array,start,len,buf);
}
void GetCharArrayRegion(JNIEnv *env, jcharArray array, jsize start, jsize len, jchar *buf) {
    return (*env)->GetCharArrayRegion(env,array,start,len,buf);
}
void GetShortArrayRegion(JNIEnv *env, jshortArray array, jsize start, jsize len, jshort *buf) {
    return (*env)->GetShortArrayRegion(env,array,start,len,buf);
}
void GetIntArrayRegion(JNIEnv *env, jintArray array, jsize start, jsize len, jint *buf) {
    return (*env)->GetIntArrayRegion(env,array,start,len,buf);
}
void GetLongArrayRegion(JNIEnv *env, jlongArray array, jsize start, jsize len, jlong *buf) {
    return (*env)->GetLongArrayRegion(env,array,start,len,buf);
}
void GetFloatArrayRegion(JNIEnv *env, jfloatArray array, jsize start, jsize len, jfloat *buf) {
    return (*env)->GetFloatArrayRegion(env,array,start,len,buf);
}
void GetDoubleArrayRegion(JNIEnv *env, jdoubleArray array, jsize start, jsize len, jdouble *buf) {
    return (*env)->GetDoubleArrayRegion(env,array,start,len,buf);
}

void SetBooleanArrayRegion(JNIEnv *env, jbooleanArray array, jsize start, jsize l, const jboolean *buf) {
    return (*env)->SetBooleanArrayRegion(env,array,start,l,buf);
}

void SetByteArrayRegion(JNIEnv *env, jbyteArray array, jsize start, jsize len, const jbyte *buf) {
    return (*env)->SetByteArrayRegion(env,array,start,len,buf);
}
void SetCharArrayRegion(JNIEnv *env, jcharArray array, jsize start, jsize len, const jchar *buf) {
    return (*env)->SetCharArrayRegion(env,array,start,len,buf);
}
void SetShortArrayRegion(JNIEnv *env, jshortArray array, jsize start, jsize len, const jshort *buf) {
    return (*env)->SetShortArrayRegion(env,array,start,len,buf);
}
void SetIntArrayRegion(JNIEnv *env, jintArray array, jsize start, jsize len, const jint *buf) {
    return (*env)->SetIntArrayRegion(env,array,start,len,buf);
}
void SetLongArrayRegion(JNIEnv *env, jlongArray array, jsize start, jsize len, const jlong *buf) {
    return (*env)->SetLongArrayRegion(env,array,start,len,buf);
}
void SetFloatArrayRegion(JNIEnv *env, jfloatArray array, jsize start, jsize len, const jfloat *buf) {
    return (*env)->SetFloatArrayRegion(env,array,start,len,buf);
}
void SetDoubleArrayRegion(JNIEnv *env, jdoubleArray array, jsize start, jsize len, const jdouble *buf) {
    return (*env)->SetDoubleArrayRegion(env,array,start,len,buf);
}

jint RegisterNatives(JNIEnv *env, jclass clazz, const JNINativeMethod *methods, jint nMethods) {
    return (*env)->RegisterNatives(env, clazz, methods, nMethods);
}

jint UnregisterNatives(JNIEnv *env, jclass clazz) {
    return (*env)->UnregisterNatives(env, clazz);
}

jint MonitorEnter(JNIEnv *env, jobject obj) {
    return (*env)->MonitorEnter(env, obj);
}
jint MonitorExit(JNIEnv *env, jobject obj) {
    return (*env)->MonitorExit(env, obj);
}

//jint GetJavaVM(JNIEnv *env, JavaVM **vm);

void GetStringRegion(JNIEnv *env, jstring str, jsize start, jsize len, jchar *buf) {
    return (*env)->GetStringRegion(env,str,start,len,buf);
}
void GetStringUTFRegion(JNIEnv *env, jstring str, jsize start, jsize len, char *buf) {
    return (*env)->GetStringUTFRegion(env,str,start,len,buf);
}

void *GetPrimitiveArrayCritical(JNIEnv *env, jarray array, jboolean *isCopy) {
    return (*env)->GetPrimitiveArrayCritical(env,array,isCopy);
}
void ReleasePrimitiveArrayCritical(JNIEnv *env, jarray array, void *carray, jint mode) {
    return (*env)->ReleasePrimitiveArrayCritical(env,array,carray,mode);
}

const jchar *GetStringCritical(JNIEnv *env, jstring string, jboolean *isCopy) {
    return (*env)->GetStringCritical(env,string,isCopy);
}
void ReleaseStringCritical(JNIEnv *env, jstring string, const jchar *cstring) {
    return (*env)->ReleaseStringCritical(env, string, cstring);
}

jweak NewWeakGlobalRef(JNIEnv *env, jobject obj) {
    return (*env)->NewWeakGlobalRef(env, obj);
}
void DeleteWeakGlobalRef(JNIEnv *env, jweak ref) {
    return (*env)->DeleteWeakGlobalRef(env, ref);
}

jboolean ExceptionCheck(JNIEnv *env) {
    return (*env)->ExceptionCheck(env);
}

jobject NewDirectByteBuffer(JNIEnv *env, void*address, jlong capacity) {
    return (*env)->NewDirectByteBuffer(env, address, capacity);
}
void*GetDirectBufferAddress(JNIEnv *env, jobject buf) {
    return (*env)->GetDirectBufferAddress(env, buf);
}
jlong GetDirectBufferCapacity(JNIEnv *env, jobject buf) {
    return (*env)->GetDirectBufferCapacity(env, buf);
}

/* New JNI 1.6 Features */

jobjectRefType GetObjectRefType(JNIEnv *env, jobject obj) {
    return (*env)->GetObjectRefType(env, obj);
}

/*
#ifndef V_JNI_WRAPPER
#define V_JNI_WRAPPER

jint GetVersion(JNIEnv *env);

jclass DefineClass(JNIEnv *env, const char *name, jobject loader, const jbyte *buf, jsize len);
jclass FindClass(JNIEnv *env, const char *name);

jmethodID FromReflectedMethod(JNIEnv *env, jobject method);
jfieldID FromReflectedField(JNIEnv *env, jobject field);

jobject ToReflectedMethod(JNIEnv *env, jclass cls, jmethodID methodID, jboolean isStatic);

jclass GetSuperclass(JNIEnv *env, jclass sub);
jboolean IsAssignableFrom(JNIEnv *env, jclass sub, jclass sup);

jobject ToReflectedField(JNIEnv *env, jclass cls, jfieldID fieldID, jboolean isStatic);

jint Throw(JNIEnv *env, jthrowable obj);
jint ThrowNew(JNIEnv *env, jclass clazz, const char *msg);
jthrowable ExceptionOccurred(JNIEnv *env);
void ExceptionDescribe(JNIEnv *env);
void ExceptionClear(JNIEnv *env);
void FatalError(JNIEnv *env, const char *msg);

jint PushLocalFrame(JNIEnv *env, jint capacity);
jobject PopLocalFrame(JNIEnv *env, jobject result);

jobject NewGlobalRef(JNIEnv *env, jobject lobj);
void DeleteGlobalRef(JNIEnv *env, jobject gref);
void DeleteLocalRef(JNIEnv *env, jobject obj);
jboolean IsSameObject(JNIEnv *env, jobject obj1, jobject obj2);
jobject NewLocalRef(JNIEnv *env, jobject ref);
jint EnsureLocalCapacity(JNIEnv *env, jint capacity);

jobject AllocObject(JNIEnv *env, jclass clazz);
jobject NewObjectA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

jclass GetObjectClass(JNIEnv *env, jobject obj);
jboolean IsInstanceOf(JNIEnv *env, jobject obj, jclass clazz);

jmethodID GetMethodID(JNIEnv *env, jclass clazz, const char *name, const char *sig);

jobject CallObjectMethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue * args);

jboolean CallBooleanMethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue * args);

jbyte CallByteMethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args);

jchar CallCharMethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args);

jshort CallShortMethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args);

jint CallIntMethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args);

jlong CallLongMethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args);

jfloat CallFloatMethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args);

jdouble CallDoubleMethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args);

void CallVoidMethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue * args);

jobject CallNonvirtualObjectMethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue * args);

jboolean CallNonvirtualBooleanMethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue * args);

jbyte CallNonvirtualByteMethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args);

jchar CallNonvirtualCharMethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args);

jshort CallNonvirtualShortMethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args);

jint CallNonvirtualIntMethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args);

jlong CallNonvirtualLongMethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args);

jfloat CallNonvirtualFloatMethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args);

jdouble CallNonvirtualDoubleMethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args);

void CallNonvirtualVoidMethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue * args);

jfieldID GetFieldID(JNIEnv *env, jclass clazz, const char *name, const char *sig);

jobject GetObjectField(JNIEnv *env, jobject obj, jfieldID fieldID);
jboolean GetBooleanField(JNIEnv *env, jobject obj, jfieldID fieldID);
jbyte GetByteField(JNIEnv *env, jobject obj, jfieldID fieldID);
jchar GetCharField(JNIEnv *env, jobject obj, jfieldID fieldID);
jshort GetShortField(JNIEnv *env, jobject obj, jfieldID fieldID);
jint GetIntField(JNIEnv *env, jobject obj, jfieldID fieldID);
jlong GetLongField(JNIEnv *env, jobject obj, jfieldID fieldID);
jfloat GetFloatField(JNIEnv *env, jobject obj, jfieldID fieldID);
jdouble GetDoubleField(JNIEnv *env, jobject obj, jfieldID fieldID);

void SetObjectField(JNIEnv *env, jobject obj, jfieldID fieldID, jobject val);
void SetBooleanField(JNIEnv *env, jobject obj, jfieldID fieldID, jboolean val);
void SetByteField(JNIEnv *env, jobject obj, jfieldID fieldID, jbyte val);
void SetCharField(JNIEnv *env, jobject obj, jfieldID fieldID, jchar val);
void SetShortField(JNIEnv *env, jobject obj, jfieldID fieldID, jshort val);
void SetIntField(JNIEnv *env, jobject obj, jfieldID fieldID, jint val);
void SetLongField(JNIEnv *env, jobject obj, jfieldID fieldID, jlong val);
void SetFloatField(JNIEnv *env, jobject obj, jfieldID fieldID, jfloat val);
void SetDoubleField(JNIEnv *env, jobject obj, jfieldID fieldID, jdouble val);

jmethodID GetStaticMethodID(JNIEnv *env, jclass clazz, const char *name, const char *sig);

jobject CallStaticObjectMethodA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

jboolean CallStaticBooleanMethodA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

jbyte CallStaticByteMethodA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

jchar CallStaticCharMethodA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

jshort CallStaticShortMethodA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

jint CallStaticIntMethodA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

jlong CallStaticLongMethodA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

jfloat CallStaticFloatMethodA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

jdouble CallStaticDoubleMethodA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

void CallStaticVoidMethodA(JNIEnv *env, jclass cls, jmethodID methodID, const jvalue * args);

jfieldID GetStaticFieldID(JNIEnv *env, jclass clazz, const char *name, const char *sig);
jobject GetStaticObjectField(JNIEnv *env, jclass clazz, jfieldID fieldID);
jboolean GetStaticBooleanField(JNIEnv *env, jclass clazz, jfieldID fieldID);
jbyte GetStaticByteField(JNIEnv *env, jclass clazz, jfieldID fieldID);
jchar GetStaticCharField(JNIEnv *env, jclass clazz, jfieldID fieldID);
jshort GetStaticShortField(JNIEnv *env, jclass clazz, jfieldID fieldID);
jint GetStaticIntField(JNIEnv *env, jclass clazz, jfieldID fieldID);
jlong GetStaticLongField(JNIEnv *env, jclass clazz, jfieldID fieldID);
jfloat GetStaticFloatField(JNIEnv *env, jclass clazz, jfieldID fieldID);
jdouble GetStaticDoubleField(JNIEnv *env, jclass clazz, jfieldID fieldID);

void SetStaticObjectField(JNIEnv *env, jclass clazz, jfieldID fieldID, jobject value);
void SetStaticBooleanField(JNIEnv *env, jclass clazz, jfieldID fieldID, jboolean value);
void SetStaticByteField(JNIEnv *env, jclass clazz, jfieldID fieldID, jbyte value);
void SetStaticCharField(JNIEnv *env, jclass clazz, jfieldID fieldID, jchar value);
void SetStaticShortField(JNIEnv *env, jclass clazz, jfieldID fieldID, jshort value);
void SetStaticIntField(JNIEnv *env, jclass clazz, jfieldID fieldID, jint value);
void SetStaticLongField(JNIEnv *env, jclass clazz, jfieldID fieldID, jlong value);
void SetStaticFloatField(JNIEnv *env, jclass clazz, jfieldID fieldID, jfloat value);
void SetStaticDoubleField(JNIEnv *env, jclass clazz, jfieldID fieldID, jdouble value);

jstring NewString(JNIEnv *env, const jchar *unicode, jsize len);
jsize GetStringLength(JNIEnv *env, jstring str);
const jchar *GetStringChars(JNIEnv *env, jstring str, jboolean *isCopy);
void ReleaseStringChars(JNIEnv *env, jstring str, const jchar *chars);

jstring NewStringUTF(JNIEnv *env, const char *utf);
jsize GetStringUTFLength(JNIEnv *env, jstring str);
const char* GetStringUTFChars(JNIEnv *env, jstring str, jboolean *isCopy);
void ReleaseStringUTFChars(JNIEnv *env, jstring str, const char* chars);

jsize GetArrayLength(JNIEnv *env, jarray array);

jobjectArray NewObjectArray(JNIEnv *env, jsize len, jclass clazz, jobject init);
jobject GetObjectArrayElement(JNIEnv *env, jobjectArray array, jsize index);
void SetObjectArrayElement(JNIEnv *env, jobjectArray array, jsize index, jobject val);

jbooleanArray NewBooleanArray(JNIEnv *env, jsize len);
jbyteArray NewByteArray(JNIEnv *env, jsize len);
jcharArray NewCharArray(JNIEnv *env, jsize len);
jshortArray NewShortArray(JNIEnv *env, jsize len);
jintArray NewIntArray(JNIEnv *env, jsize len);
jlongArray NewLongArray(JNIEnv *env, jsize len);
jfloatArray NewFloatArray(JNIEnv *env, jsize len);
jdoubleArray NewDoubleArray(JNIEnv *env, jsize len);

jboolean * GetBooleanArrayElements(JNIEnv *env, jbooleanArray array, jboolean *isCopy);
jbyte * GetByteArrayElements(JNIEnv *env, jbyteArray array, jboolean *isCopy);
jchar * GetCharArrayElements(JNIEnv *env, jcharArray array, jboolean *isCopy);
jshort * GetShortArrayElements(JNIEnv *env, jshortArray array, jboolean *isCopy);
jint * GetIntArrayElements(JNIEnv *env, jintArray array, jboolean *isCopy);
jlong * GetLongArrayElements(JNIEnv *env, jlongArray array, jboolean *isCopy);
jfloat * GetFloatArrayElements(JNIEnv *env, jfloatArray array, jboolean *isCopy);
jdouble * GetDoubleArrayElements(JNIEnv *env, jdoubleArray array, jboolean *isCopy);

void ReleaseBooleanArrayElements(JNIEnv *env, jbooleanArray array, jboolean *elems, jint mode);
void ReleaseByteArrayElements(JNIEnv *env, jbyteArray array, jbyte *elems, jint mode);
void ReleaseCharArrayElements(JNIEnv *env, jcharArray array, jchar *elems, jint mode);
void ReleaseShortArrayElements(JNIEnv *env, jshortArray array, jshort *elems, jint mode);
void ReleaseIntArrayElements(JNIEnv *env, jintArray array, jint *elems, jint mode);
void ReleaseLongArrayElements(JNIEnv *env, jlongArray array, jlong *elems, jint mode);
void ReleaseFloatArrayElements(JNIEnv *env, jfloatArray array, jfloat *elems, jint mode);
void ReleaseDoubleArrayElements(JNIEnv *env, jdoubleArray array, jdouble *elems, jint mode);

void GetBooleanArrayRegion(JNIEnv *env, jbooleanArray array, jsize start, jsize l, jboolean *buf);
void GetByteArrayRegion(JNIEnv *env, jbyteArray array, jsize start, jsize len, jbyte *buf);
void GetCharArrayRegion(JNIEnv *env, jcharArray array, jsize start, jsize len, jchar *buf);
void GetShortArrayRegion(JNIEnv *env, jshortArray array, jsize start, jsize len, jshort *buf);
void GetIntArrayRegion(JNIEnv *env, jintArray array, jsize start, jsize len, jint *buf);
void GetLongArrayRegion(JNIEnv *env, jlongArray array, jsize start, jsize len, jlong *buf);
void GetFloatArrayRegion(JNIEnv *env, jfloatArray array, jsize start, jsize len, jfloat *buf);
void GetDoubleArrayRegion(JNIEnv *env, jdoubleArray array, jsize start, jsize len, jdouble *buf);

void SetBooleanArrayRegion(JNIEnv *env, jbooleanArray array, jsize start, jsize l, const jboolean *buf);
void SetByteArrayRegion(JNIEnv *env, jbyteArray array, jsize start, jsize len, const jbyte *buf);
void SetCharArrayRegion(JNIEnv *env, jcharArray array, jsize start, jsize len, const jchar *buf);
void SetShortArrayRegion(JNIEnv *env, jshortArray array, jsize start, jsize len, const jshort *buf);
void SetIntArrayRegion(JNIEnv *env, jintArray array, jsize start, jsize len, const jint *buf);
void SetLongArrayRegion(JNIEnv *env, jlongArray array, jsize start, jsize len, const jlong *buf);
void SetFloatArrayRegion(JNIEnv *env, jfloatArray array, jsize start, jsize len, const jfloat *buf);
void SetDoubleArrayRegion(JNIEnv *env, jdoubleArray array, jsize start, jsize len, const jdouble *buf);

jint RegisterNatives(JNIEnv *env, jclass clazz, const JNINativeMethod *methods, jint nMethods);
jint UnregisterNatives(JNIEnv *env, jclass clazz);

jint MonitorEnter(JNIEnv *env, jobject obj);
jint MonitorExit(JNIEnv *env, jobject obj);

jint GetJavaVM(JNIEnv *env, JavaVM **vm);

void GetStringRegion(JNIEnv *env, jstring str, jsize start, jsize len, jchar *buf);
void GetStringUTFRegion(JNIEnv *env, jstring str, jsize start, jsize len, char *buf);

void * GetPrimitiveArrayCritical(JNIEnv *env, jarray array, jboolean *isCopy);
void ReleasePrimitiveArrayCritical(JNIEnv *env, jarray array, void *carray, jint mode);

const jchar * GetStringCritical(JNIEnv *env, jstring string, jboolean *isCopy);
void ReleaseStringCritical(JNIEnv *env, jstring string, const jchar *cstring);

jweak NewWeakGlobalRef(JNIEnv *env, jobject obj);
void DeleteWeakGlobalRef(JNIEnv *env, jweak ref);

jboolean ExceptionCheck(JNIEnv *env);

jobject NewDirectByteBuffer(JNIEnv *env, void* address, jlong capacity);
void* GetDirectBufferAddress(JNIEnv *env, jobject buf);
jlong GetDirectBufferCapacity(JNIEnv *env, jobject buf);

// New JNI 1.6 Features

jobjectRefType GetObjectRefType(JNIEnv *env, jobject obj);

#endif
*/
