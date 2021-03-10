module raw

import jni

pub fn env()  &jni.Env {
	return C.jniGetEnv()
}
