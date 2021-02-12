module auto

import jni

pub fn call_static_method(signature string, args ...jni.Type) jni.CallResult {
	env := jni.auto_env()
	return jni.call_static_method(env, signature, ...args)
}

pub fn call_object_method(obj jni.JavaObject, signature string, args ...jni.Type) jni.CallResult {
	env := jni.auto_env()
	return jni.call_object_method(env, obj, signature, ...args)
}

pub fn throw_exception(msg string) {
	env := jni.auto_env()
	jni.throw_exception(env, msg)
}
