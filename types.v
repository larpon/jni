module jni

type Void = bool
type Type = JavaObject | Void | bool | f32 | f64 | int | string //| rune | i16 | int | i64 | byte

// pub type Any = string | int | i64 | f32 | f64 | bool | []Any | map[voidptr]Any
enum MethodType {
	@static
	instance
}

/*
Signature table

Signature                 | Java Type             | V Type
---------------------------------------------------------------------------
Z                         | boolean               | bool
---------------------------------------------------------------------------
B                         | byte                  | byte
---------------------------------------------------------------------------
C                         | char                  | rune
---------------------------------------------------------------------------
S                         | short                 | i16
---------------------------------------------------------------------------
I                         | int                   | int
---------------------------------------------------------------------------
J                         | long                  | i64
---------------------------------------------------------------------------
F                         | float                 | f32
---------------------------------------------------------------------------
D                         | double                | f64
---------------------------------------------------------------------------
L fully-qualified-class ; | fully-qualified-class |
---------------------------------------------------------------------------
[ type                    | type[]                |
---------------------------------------------------------------------------
( arg-types ) ret-type    | method type           |
---------------------------------------------------------------------------
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
		JavaObject { 'Ljava/lang/Object;' }
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
		bool {
			C.jvalue{
				z: jboolean(vt)
			}
		}
		f32 {
			C.jvalue{
				i: jfloat(vt)
			}
		}
		f64 {
			C.jvalue{
				i: jdouble(vt)
			}
		}
		int {
			C.jvalue{
				i: jint(vt)
			}
		}
		string { // TODO
			C.jvalue{
				l: C.StringToObject(jstring(C.jniGetEnv(), vt))
			}
		}
		JavaObject {
			C.jvalue{
				l: C.jobject(vt)
			}
		}
		else {
			C.jvalue{}
		}
	}
}

[inline]
pub fn j2v_string(env &Env, jstr C.jstring) string {
	mut cn := ''
	unsafe {
		native_string := C.GetStringUTFChars(env, jstr, C.jboolean(C.JNI_FALSE))
		cn = '' + native_string.vstring()
		C.ReleaseStringUTFChars(env, jstr, native_string)
	}
	return cn
}

[inline]
pub fn j2v_char(jchar C.jchar) rune {
	return rune(u16(jchar))
}

[inline]
pub fn j2v_byte(jbyte C.jbyte) byte {
	return byte(i8(jbyte))
}

[inline]
pub fn j2v_boolean(jbool C.jboolean) bool {
	return jbool == C.jboolean(C.JNI_TRUE)
}

[inline]
pub fn j2v_int(jint C.jint) int {
	return int(jint)
}

[inline]
pub fn j2v_short(jshort C.jshort) i16 {
	return i16(jshort)
}

[inline]
pub fn j2v_long(jlong C.jlong) i64 {
	return i64(jlong)
}

[inline]
pub fn j2v_float(jfloat C.jfloat) f32 {
	return f32(jfloat)
}

[inline]
pub fn j2v_double(jdouble C.jdouble) f64 {
	return f64(jdouble)
}

[inline]
pub fn jboolean(val bool) C.jboolean {
	if val {
		return C.jboolean(C.JNI_TRUE)
	}
	return C.jboolean(C.JNI_FALSE)
}

[inline]
pub fn jfloat(val f32) C.jfloat {
	return C.jfloat(val)
}

[inline]
pub fn jdouble(val f64) C.jdouble {
	return C.jdouble(val)
}

[inline]
pub fn jint(val int) C.jint {
	return C.jint(val)
}

[inline]
pub fn jstring(env &Env, val string) C.jstring {
	return C.NewStringUTF(env, val.str)
}
