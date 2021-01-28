module jni

pub struct Object {
	env &Env
	obj JavaObject
	pkg string
}

pub fn (o Object) call(typ ObjectType, signature string, args ...Type) CallResult {
	return match typ {
		.@static { call_static_method(o.env, o.pkg + '.' + signature, ...args) }
		.instance { call_object_method(o.env, o.obj, o.pkg + '.' + signature, ...args) }
	}
}

/*
pub fn (o Object) call_static(signature string, args ...Type) CallResult {
	return call_static_method(o.env, o.pkg+'.'+signature, ...args)
	//return call_object_method(o.env, o.obj, o.pkg+'.'+signature, ...args)
}
*/
pub fn object(env &C.JNIEnv, obj C.jobject, pkg string) Object {
	return Object{
		env: env
		obj: obj
		pkg: pkg
	}
}
