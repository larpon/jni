module jni

type Type = bool | int | f32 | f64 | string | JavaObject
// pub type Any = string | int | i64 | f32 | f64 | bool | []Any | map[voidptr]Any

enum ObjectType {
	@static
	instance
}

/* JNI signature table

Signature                 | Java Type
--------------------------------------------------
Z                         | boolean
--------------------------------------------------
B                         | byte
--------------------------------------------------
C                         | char
--------------------------------------------------
S                         | short
--------------------------------------------------
I                         | int
--------------------------------------------------
J                         | long
--------------------------------------------------
F                         | float
--------------------------------------------------
D                         | double
--------------------------------------------------
L fully-qualified-class ; | fully-qualified-class
--------------------------------------------------
[ type                    | type[]
--------------------------------------------------
( arg-types ) ret-type    | method type

*/

pub fn v2j_fn_name(v_func_name string) string {
	splt := v_func_name.split('_')
	mut java_fn_name := splt[0]
	for i := 1; i < splt.len; i++ {
		java_fn_name += splt[i].capitalize()
	}
	return java_fn_name
}

fn v2j_signature_type(vt Type) string {
	return match vt {
		bool { 'Z' }
		f32 { 'F' }
		f64 { 'D' }
		int { 'I' }
		string { 'Ljava/lang/String;' }
		else { 'V' } // void
	}
}

fn v2j_string_signature_type(vt string) string {
	return match vt {
		'bool' { 'Z' }
		'int' { 'I' }
		'f32' { 'F' }
		'f64' { 'D' }
		'string' { 'Ljava/lang/String;' }
		else { 'V' } // void
	}
}

fn v2j_value(vt Type) C.jvalue {
	return match vt {
		bool { C.jvalue{z: jboolean(vt) } }
		f32 { C.jvalue{i: jfloat(vt) } }
		f64 { C.jvalue{i: jdouble(vt) } }
		int { C.jvalue{i: jint(vt) } }
		string { // TODO
			C.jvalue{l: C.StringToObject(jstring(C.jniGetEnv(),vt)) }
		}
		else {
			C.jvalue{}
		}
	}
}

pub fn j2v_string(env &Env, jstr C.jstring) string {
	mut cn := ''
	unsafe {
		native_string := C.GetStringUTFChars(env, jstr, C.JNI_FALSE)
		cn = ''+native_string.vstring()
		C.ReleaseStringUTFChars(env, jstr, native_string)
	}
	return cn
}

//

pub fn jboolean(val bool) C.jboolean {
	if val {
		return C.jboolean(C.JNI_TRUE)
	}
	return C.jboolean(C.JNI_FALSE)
}

pub fn jfloat(val f32) C.jfloat {
	return C.jfloat(val)
}

pub fn jdouble(val f64) C.jdouble {
	return C.jdouble(val)
}

pub fn jint(val int) C.jint {
	return C.jint(val)
}

pub fn jstring(env &Env, val string) C.jstring {
	return C.NewStringUTF(env, val.str)
}

