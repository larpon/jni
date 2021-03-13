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
			eprintln(@MOD + '.' + @FN + ': $soft_visibility')
		}
		// Retrieve NativeActivity
		env := jni.default_env()

		activity := android.activity() or { panic(@MOD + '.' + @FN + ': ' + err.msg) }

		activity_class := jni.get_object_class(env, activity.clazz)

		// Retrieve Context.INPUT_METHOD_SERVICE
		class_context := jni.checked_find_class(env, 'android.content.Context') or {
			panic(@MOD + '.' + @FN + ': ' + err.msg)
		}
		fld_input_method_service := jni.get_static_field_id(env, class_context, 'INPUT_METHOD_SERVICE',
			'Ljava/lang/String;')

		input_method_service := C.GetStaticObjectField(env, class_context, fld_input_method_service)
		jni.panic_on_exception(env)

		// Runs getSystemService(Context.INPUT_METHOD_SERVICE)

		class_input_method_manager := jni.checked_find_class(env, 'android.view.inputmethod.InputMethodManager') or {
			panic(@MOD + '.' + @FN + ': ' + err.msg)
		}

		method_get_system_service := C.GetMethodID(env, activity_class, c'getSystemService',
			c'(Ljava/lang/String;)Ljava/lang/Object;')

		mut jv_args := []JavaValue{}
		jv_args << JavaValue{
			l: input_method_service
		}
		input_method_manager := jni.call_object_method_a(env, activity.clazz, method_get_system_service,
			jv_args.data)
		jni.panic_on_exception(env)

		jv_args.clear()

		// Runs getWindow().getDecorView()
		method_get_window := C.GetMethodID(env, activity_class, c'getWindow', c'()Landroid/view/Window;')
		window := jni.call_object_method_a(env, activity.clazz, method_get_window, jv_args.data)

		class_window := jni.checked_find_class(env, 'android.view.Window') or {
			panic(@MOD + '.' + @FN + ': ' + err.msg)
		}

		method_get_decor_view := C.GetMethodID(env, class_window, c'getDecorView', c'()Landroid/view/View;')

		decor_view := jni.call_object_method_a(env, window, method_get_decor_view, jv_args.data)

		if soft_visibility == .visible {
			// Runs lInputMethodManager.showSoftInput(...)
			method_show_soft_input := C.GetMethodID(env, class_input_method_manager, c'showSoftInput',
				c'(Landroid/view/View;I)Z')

			jv_args << JavaValue{
				l: decor_view
			}
			jv_args << JavaValue{
				i: jni.jint(0)
			}
			return jni.call_boolean_method_a(env, input_method_manager, method_show_soft_input,
				jv_args.data)
		} else {
			// Runs lWindow.getViewToken()
			class_view := jni.checked_find_class(env, 'android.view.View') or { panic(err) }
			method_get_window_token := C.GetMethodID(env, class_view, c'getWindowToken',
				c'()Landroid/os/IBinder;')
			binder := jni.call_object_method_a(env, decor_view, method_get_window_token,
				jv_args.data)

			// lInputMethodManager.hideSoftInput(...)
			method_hide_soft_input := C.GetMethodID(env, class_input_method_manager, c'hideSoftInputFromWindow',
				c'(Landroid/os/IBinder;I)Z')

			jv_args << JavaValue{
				l: binder
			}
			jv_args << JavaValue{
				i: jni.jint(0)
			}
			return jni.call_boolean_method_a(env, input_method_manager, method_hide_soft_input,
				jv_args.data)
		}
	}
	return false
}
