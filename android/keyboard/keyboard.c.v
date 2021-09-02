// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
module keyboard

import jni
import jni.android

pub enum SoftKeyboardVisibility {
	visible
	hidden
}

// V implementation of https://groups.google.com/g/android-ndk/c/Tk3g00wLKhk/m/TJQucoaE_asJ
pub fn visibility(soft_visibility SoftKeyboardVisibility) bool {
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

		//input_method_service := C.GetStaticObjectField(env, class_context, fld_input_method_service)
		input_method_service := jni.get_static_object_field(env, class_context, fld_input_method_service)
		jni.panic_on_exception(env)

		// Runs getSystemService(Context.INPUT_METHOD_SERVICE)

		class_input_method_manager := jni.find_class(env, 'android.view.inputmethod.InputMethodManager')

		//method_get_system_service := C.GetMethodID(env, activity_class, c'getSystemService', c'(Ljava/lang/String;)Ljava/lang/Object;')
		method_get_system_service := jni.get_method_id(env, activity_class, 'getSystemService', '(Ljava/lang/String;)Ljava/lang/Object;')

		mut jv_args := []jni.JavaValue{}
		jv_args << jni.JavaValue{
			l: input_method_service
		}
		input_method_manager := jni.call_object_method_a(env, activity.clazz, method_get_system_service,
			jv_args.data)
		jni.panic_on_exception(env)

		jv_args.clear()

		// Runs getWindow().getDecorView()
		//method_get_window := C.GetMethodID(env, activity_class, c'getWindow', c'()Landroid/view/Window;')
		method_get_window := jni.get_method_id(env, activity_class, 'getWindow', '()Landroid/view/Window;')
		window := jni.call_object_method_a(env, activity.clazz, method_get_window, jv_args.data)

		class_window := jni.find_class(env, 'android.view.Window')

		//method_get_decor_view := C.GetMethodID(env, class_window, c'getDecorView', c'()Landroid/view/View;')
		method_get_decor_view := jni.get_method_id(env, class_window, 'getDecorView', '()Landroid/view/View;')

		decor_view := jni.call_object_method_a(env, window, method_get_decor_view, jv_args.data)

		if soft_visibility == .visible {
			// Runs lInputMethodManager.showSoftInput(...)
			method_show_soft_input := jni.get_method_id(env, class_input_method_manager, 'showSoftInput', '(Landroid/view/View;I)Z')
			//method_show_soft_input := C.GetMethodID(env, class_input_method_manager, c'showSoftInput',	c'(Landroid/view/View;I)Z')

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
			//method_get_window_token := C.GetMethodID(env, class_view, c'getWindowToken', c'()Landroid/os/IBinder;')
			method_get_window_token := jni.get_method_id(env, class_view, 'getWindowToken', '()Landroid/os/IBinder;')
			binder := jni.call_object_method_a(env, decor_view, method_get_window_token,
				jv_args.data)

			// lInputMethodManager.hideSoftInput(...)
			//method_hide_soft_input := C.GetMethodID(env, class_input_method_manager, c'hideSoftInputFromWindow', c'(Landroid/os/IBinder;I)Z')
			method_hide_soft_input := jni.get_method_id(env, class_input_method_manager, 'hideSoftInputFromWindow', '(Landroid/os/IBinder;I)Z')

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


// V implementation of https://github.com/floooh/sokol/pull/503/files#diff-42747840ac0dd5aaeaa9368919646cc57e72a0bb54c03ad85c7eac18956ea584R7817-R7936
pub fn is_visible() bool {
	$if android {
		$if debug ? {
			eprintln(@MOD + '.' + @FN + ' called')
		}

		env, need_detach := jni.env_detach()
		defer {
			jni.detach_thread(need_detach)
		}

		mut jv_args := []jni.JavaValue{}

		// Retrieve NativeActivity
		activity := android.activity() or { panic(@MOD + '.' + @FN + ': ' + err.msg) }
		activity_class := jni.get_object_class(env, activity.clazz)
		
		// We can't have the current status of the keyboard
		// So instead, we get the size of the view after removing decorations (status and navigation bar)
		// and we compare it to the view visible display frame
		// If they are not equal, then the keyboard may be visible

		//jclass view_class = (*env)->FindClass(env, "android/view/View");
		view_class := jni.find_class(env, 'android.view.View')

		// view_height = decor_view.getHeight();
		//jmethodID get_display = (*env)->GetMethodID(env, view_class, "getDisplay", "()Landroid/view/Display;");
		method_get_display := jni.get_method_id(env, view_class, 'getDisplay', '()Landroid/view/Display;')

		//jobject display = (*env)->CallObjectMethod(env, _sapp.android.decor_view, get_display);
		method_get_window := jni.get_method_id(env, activity_class, 'getWindow', '()Landroid/view/Window;')
		window := jni.call_object_method_a(env, activity.clazz, method_get_window, jv_args.data)
		class_window := jni.find_class(env, 'android.view.Window')
		method_get_decor_view := jni.get_method_id(env, class_window, 'getDecorView', '()Landroid/view/View;')
		decor_view := jni.call_object_method_a(env, window, method_get_decor_view, jv_args.data)
		display := jni.call_object_method_a(env, decor_view, method_get_display, jv_args.data)


		// display_dimension = new Point();
		//jclass point_class = (*env)->FindClass(env, "android/graphics/Point");
		point_class := jni.find_class(env, 'android.graphics.Point')
		//jmethodID point_ctor = (*env)->GetMethodID(env, point_class, "<init>", "()V");
		point_ctor := jni.get_method_id(env, point_class, "<init>", "()V")
		//jobject display_dimension = (*env)->NewObject(env, point_class, point_ctor);
		display_dimension := jni.new_object_a(env, point_class, point_ctor, jv_args.data)

		// display.getSize(display_dimension);
		//jclass display_class = (*env)->FindClass(env, "android/view/Display");
		display_class := jni.find_class(env, 'android.view.Display')
		//jmethodID get_size = (*env)->GetMethodID(env, display_class, "getSize", "(Landroid/graphics/Point;)V" );
		get_size := jni.get_method_id(env, display_class, 'getSize', '(Landroid/graphics/Point;)V')

		//(*env)->CallVoidMethod(env,display,get_size,display_dimension);

		jv_args << jni.JavaValue{
			l: display_dimension
		}
		jni.call_void_method_a(env, display, get_size, jv_args.data)

		// display_height = display_dimension.y;
		//jfieldID point_y = (*env)->GetFieldID(env, point_class, "y", "I");
		point_y := jni.get_field_id(env, point_class, 'y', 'I')

		//int display_height = (*env)->GetIntField(env, display_dimension, point_y);
		display_height := jni.get_int_field(env, display_dimension, point_y)

		/* TODO
		// view_visible_rect = new Rect();
		jclass rect_class = (*env)->FindClass(env, "android/graphics/Rect");
		jmethodID rect_ctor = (*env)->GetMethodID(
			env,
			rect_class,
			"<init>",
			"()V"
			);
		jobject view_visible_rect = (*env)->NewObject(env, rect_class, rect_ctor);

		// decor_view.getWindowVisibleDisplayFrame(view_visible_rect);
		jmethodID get_window_visible_display_frame = (*env)->GetMethodID(
			env,
			view_class,
			"getWindowVisibleDisplayFrame",
			"(Landroid/graphics/Rect;)V"
			);
		(*env)->CallVoidMethod(
			env,
			_sapp.android.decor_view,
			get_window_visible_display_frame,
			view_visible_rect
			);

		// status_bar_height = view_visible_rect.top;
		jfieldID rect_top = (*env)->GetFieldID(
			env,
			rect_class,
			"top",
			"I"
			);
		int status_bar_height = (*env)->GetIntField(env, view_visible_rect, rect_top);

		// view_visible_height = view_visible_rect.height();
		jmethodID rect_height = (*env)->GetMethodID(
			env,
			rect_class,
			"height",
			"()I"
			);
		int view_visible_height = (*env)->CallIntMethod(
			env,
			view_visible_rect,
			rect_height
			);

		(*env)->DeleteLocalRef(env, view_visible_rect);
		(*env)->DeleteLocalRef(env, rect_class);
		(*env)->DeleteLocalRef(env, view_class);

		if (need_detach) {
			(*_sapp.android.activity->vm)->DetachCurrentThread(_sapp.android.activity->vm);
		}
		*/
		//return display_height - status_bar_height != view_visible_height;
		//return ''
	}
	return false
}

