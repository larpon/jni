// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
module keyboard

import jni
import jni.auto
import jni.android

pub enum SoftKeyboardVisibility {
	visible
	hidden
}

// visibility set the visibility of the soft input on Android.
// it's a pure JNI implementation so no special calls is needed on the Java side.
// The major caveat is that, currently, there's no *reliable* way to get key events.
// For key events to work ~95% we need to do things via a Java class that can hold state.
// At some point a pur JNI implementation could probably be done.
pub fn visibility(soft_visibility SoftKeyboardVisibility) bool {
	// V implementation of:
	// https://groups.google.com/g/android-ndk/c/Tk3g00wLKhk/m/TJQucoaE_asJ
	$if android {
		$if debug ? {
			eprintln(@MOD + '.' + @FN + ': $soft_visibility')
		}

		env, need_detach := jni.env_detach()
		defer {
			jni.detach_thread(need_detach)
		}

		// Retrieve NativeActivity
		activity := android.activity() or { panic(@MOD + '.' + @FN + ': ' + err.msg) }
		activity_class := jni.get_object_class(env, activity.clazz)

		// Retrieve Context.INPUT_METHOD_SERVICE
		class_context := jni.find_class(env, 'android.content.Context')
		fld_input_method_service := jni.get_static_field_id(env, class_context, 'INPUT_METHOD_SERVICE',
			'Ljava/lang/String;')

		input_method_service := jni.get_static_object_field(env, class_context, fld_input_method_service)
		jni.panic_on_exception(env)

		// Runs getSystemService(Context.INPUT_METHOD_SERVICE)
		input_method_manager_class := jni.find_class(env, 'android.view.inputmethod.InputMethodManager')

		method_get_system_service := jni.get_method_id(env, activity_class, 'getSystemService',
			'(Ljava/lang/String;)Ljava/lang/Object;')

		mut jv_args := []jni.JavaValue{}
		jv_args << jni.JavaValue{
			l: input_method_service
		}
		input_method_manager := jni.call_object_method_a(env, activity.clazz, method_get_system_service,
			jv_args.data)
		jni.panic_on_exception(env)

		jv_args.clear()

		// Runs getWindow().getDecorView()
		method_get_window := jni.get_method_id(env, activity_class, 'getWindow', '()Landroid/view/Window;')
		window := jni.call_object_method_a(env, activity.clazz, method_get_window, jv_args.data)

		class_window := jni.find_class(env, 'android.view.Window')

		method_get_decor_view := jni.get_method_id(env, class_window, 'getDecorView',
			'()Landroid/view/View;')

		decor_view := jni.call_object_method_a(env, window, method_get_decor_view, jv_args.data)

		if soft_visibility == .visible {
			// Runs lInputMethodManager.showSoftInput(...)
			method_show_soft_input := jni.get_method_id(env, input_method_manager_class,
				'showSoftInput', '(Landroid/view/View;I)Z')

			jv_args << jni.JavaValue{
				l: decor_view
			}
			jv_args << jni.JavaValue{
				i: jni.jint(0)
			}
			return jni.call_boolean_method_a(env, input_method_manager, method_show_soft_input,
				jv_args.data)
		} else {
			// Runs lWindow.getViewToken()
			class_view := jni.find_class(env, 'android.view.View')
			method_get_window_token := jni.get_method_id(env, class_view, 'getWindowToken',
				'()Landroid/os/IBinder;')
			binder := jni.call_object_method_a(env, decor_view, method_get_window_token,
				jv_args.data)

			// lInputMethodManager.hideSoftInput(...)
			method_hide_soft_input := jni.get_method_id(env, input_method_manager_class,
				'hideSoftInputFromWindow', '(Landroid/os/IBinder;I)Z')

			jv_args << jni.JavaValue{
				l: binder
			}
			jv_args << jni.JavaValue{
				i: jni.jint(0)
			}
			return jni.call_boolean_method_a(env, input_method_manager, method_hide_soft_input,
				jv_args.data)
		}
	}
	return false
}

// is_visible returns `true` if it's like that the soft input is covering some of the screen.
// It is not recommended to run this in hot code paths like a game loop since
// it takes round trips through the JNI and allocates/deallocates memory via the JVM.
pub fn is_visible() bool {
	// V implementation of:
	// https://github.com/floooh/sokol/pull/503/files#diff-42747840ac0dd5aaeaa9368919646cc57e72a0bb54c03ad85c7eac18956ea584R7817-R7936
	$if android {
		$if debug ? {
			eprintln(@MOD + '.' + @FN + ' called')
		}

		env, need_detach := jni.env_detach()
		defer {
			jni.detach_thread(need_detach)
		}

		// Retrieve NativeActivity
		activity := android.activity() or { panic(@MOD + '.' + @FN + ': ' + err.msg) }
		activity_class := jni.get_object_class(env, activity.clazz)

		mut jv_args := []jni.JavaValue{}

		// We can't have the current status of the keyboard
		// So instead, we get the size of the view after removing decorations (status and navigation bar)
		// and we compare it to the view visible display frame
		// If they are not equal, then the keyboard may be visible

		view_class := jni.find_class(env, 'android.view.View')

		// view_height = decor_view.getHeight();
		method_get_display := jni.get_method_id(env, view_class, 'getDisplay', '()Landroid/view/Display;')

		method_get_window := jni.get_method_id(env, activity_class, 'getWindow', '()Landroid/view/Window;')
		window := jni.call_object_method_a(env, activity.clazz, method_get_window, jni.void_arg.data)
		class_window := jni.find_class(env, 'android.view.Window')
		method_get_decor_view := jni.get_method_id(env, class_window, 'getDecorView',
			'()Landroid/view/View;')
		decor_view := jni.call_object_method_a(env, window, method_get_decor_view, jni.void_arg.data)
		display := jni.call_object_method_a(env, decor_view, method_get_display, jni.void_arg.data)

		// display_dimension = new Point();
		point_class := jni.find_class(env, 'android.graphics.Point')
		point_ctor := jni.get_method_id(env, point_class, '<init>', '()V')
		display_dimension := jni.new_object_a(env, point_class, point_ctor, jni.void_arg.data)

		// display.getSize(display_dimension);
		display_class := jni.find_class(env, 'android.view.Display')
		get_size := jni.get_method_id(env, display_class, 'getSize', '(Landroid/graphics/Point;)V')

		jv_args << jni.JavaValue{
			l: display_dimension
		}
		jni.call_void_method_a(env, display, get_size, jv_args.data)

		// display_height = display_dimension.y;
		point_y := jni.get_field_id(env, point_class, 'y', 'I')

		// int display_height = (*env)->GetIntField(env, display_dimension, point_y);
		display_height := jni.get_int_field(env, display_dimension, point_y)

		// view_visible_rect = new Rect();
		rect_class := jni.find_class(env, 'android.graphics.Rect')
		rect_ctor := jni.get_method_id(env, rect_class, '<init>', '()V')
		view_visible_rect := jni.new_object_a(env, rect_class, rect_ctor, jni.void_arg.data)

		// decor_view.getWindowVisibleDisplayFrame(view_visible_rect);
		get_window_visible_display_frame := jni.get_method_id(env, view_class, 'getWindowVisibleDisplayFrame',
			'(Landroid/graphics/Rect;)V')

		jv_args.clear()
		jv_args << jni.JavaValue{
			l: view_visible_rect
		}
		jni.call_void_method_a(env, decor_view, get_window_visible_display_frame, jv_args.data)

		// status_bar_height = view_visible_rect.top;
		rect_top := jni.get_field_id(env, rect_class, 'top', 'I')
		status_bar_height := jni.get_int_field(env, view_visible_rect, rect_top)

		// view_visible_height = view_visible_rect.height();
		rect_height := jni.get_method_id(env, rect_class, 'height', '()I')
		view_visible_height := jni.call_int_method_a(env, view_visible_rect, rect_height,
			jni.void_arg.data)

		// Release new'd objects
		jni.delete_local_ref(env, view_visible_rect)
		jni.delete_local_ref(env, &jni.JavaObject(voidptr(&rect_class)))
		jni.delete_local_ref(env, display_dimension)
		jni.delete_local_ref(env, &jni.JavaObject(voidptr(&view_class)))

		// hack := display_height - status_bar_height != view_visible_height // ??? Original code had this
		// but it doesn't work on devices with where the primary keys are software keys places in a bar in the bottom.
		// I can't believe how all this became such a horrible mess.

		hack := (f32(display_height) - status_bar_height) * 0.20 > view_visible_height
		return hack // display_height - status_bar_height != view_visible_height
	}
	return false
}
