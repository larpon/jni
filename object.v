module jni

pub struct Object {
	env &Env
	obj JavaObject
	pkg string
}

pub fn (o Object) call(typ MethodType, signature string, args ...Type) CallResult {
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
pub fn object(env &Env, obj JavaObject, pkg string) Object {
	return Object{
		env: env
		obj: obj
		pkg: pkg
	}
}
