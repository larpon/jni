// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
module keyboard

import jni
import jni.android

enum SoftKeyboardVisibility {
	visible
	hidden
}

// V implementation of https://groups.google.com/g/android-ndk/c/Tk3g00wLKhk/m/TJQucoaE_asJ
pub fn visibility(soft_visibility SoftKeyboardVisibility) bool {
	$if android {
		$if debug ? {
			eprintln(@MOD+'.'+@FN+': $soft_visibility')
		}
		// Retrieve NativeActivity
		env := jni.auto_env()

		activity := android.activity() or { panic(@MOD+'.'+@FN+': '+err.msg) }

		activity_class := jni.get_object_class(env, activity.clazz)

		// Retrieve Context.INPUT_METHOD_SERVICE
		class_context := jni.auto_find_class('android.content.Context') or { panic(@MOD+'.'+@FN+': '+err.msg) }
		fld_input_method_service := jni.get_static_field_id(env, class_context, 'INPUT_METHOD_SERVICE', 'Ljava/lang/String;')

		input_method_service := C.GetStaticObjectField(env, class_context, fld_input_method_service)
		jni.die_on_exception(env)

		// Runs getSystemService(Context.INPUT_METHOD_SERVICE)

		class_input_method_manager := jni.auto_find_class('android.view.inputmethod.InputMethodManager') or { panic(@MOD+'.'+@FN+': '+err.msg) }

		method_get_system_service := C.GetMethodID(env, activity_class, c'getSystemService', c'(Ljava/lang/String;)Ljava/lang/Object;')

		mut jv_args := []C.jvalue{}
		jv_args << C.jvalue {l: input_method_service}

		input_method_manager := C.CallObjectMethodA(env, activity.clazz, method_get_system_service, jv_args.data)
		jni.die_on_exception(env)

		jv_args.clear()

		// Runs getWindow().getDecorView()
		method_get_window := C.GetMethodID(env, activity_class, c'getWindow', c'()Landroid/view/Window;')
		window := C.CallObjectMethodA(env, activity.clazz, method_get_window, jv_args.data)

		class_window := jni.auto_find_class('android.view.Window') or { panic(@MOD+'.'+@FN+': '+err.msg) }

		method_get_decor_view := C.GetMethodID(env, class_window, c'getDecorView', c'()Landroid/view/View;')

		decor_view := C.CallObjectMethodA(env, window, method_get_decor_view, jv_args.data)

		if soft_visibility == .visible {
			// Runs lInputMethodManager.showSoftInput(...)
			method_show_soft_input := C.GetMethodID(env, class_input_method_manager, c'showSoftInput', c'(Landroid/view/View;I)Z')

			jv_args << C.jvalue {l: decor_view}
			jv_args << C.jvalue {i: jni.jint(0)}
			return jni.j2v_boolean( C.CallBooleanMethodA(env, input_method_manager, method_show_soft_input, jv_args.data) )
		} else {
			// Runs lWindow.getViewToken()
			class_view := jni.auto_find_class('android.view.View') or { panic(err) }
			method_get_window_token := C.GetMethodID(env, class_view, c'getWindowToken', c'()Landroid/os/IBinder;')
			binder :=  C.CallObjectMethodA(env, decor_view, method_get_window_token, jv_args.data)

			// lInputMethodManager.hideSoftInput(...)
			method_hide_soft_input := C.GetMethodID(env, class_input_method_manager, c'hideSoftInputFromWindow', c'(Landroid/os/IBinder;I)Z')

			jv_args << C.jvalue {l: binder}
			jv_args << C.jvalue {i: jni.jint(0)}
			return jni.j2v_boolean( C.CallBooleanMethodA(env, input_method_manager, method_hide_soft_input, jv_args.data) )
		}
	}
	return false
}
