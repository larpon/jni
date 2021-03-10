// Copyright(C) 2019-2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
import gg
import gx

import sokol.sapp
import sokol.gfx
import sokol.sgl

import jni
import jni.android.keyboard

const (
	pkg = 'io.v.android.ex.VKeyboardActivity'
	bg_color   = gx.white
)

[export: 'JNI_OnLoad']
fn jni_on_load(vm &jni.JavaVM, reserved voidptr) int {
	println(@FN+' called')
	jni.set_java_vm(vm)
	$if android {
		// V consts - can't be used since `JNI_OnLoad`
		// is called by the Java VM before the lib
		// with V's init code is loaded and called.
		jni.setup_android('io.v.android.ex.VKeyboardActivity')
	}
	return C.JNI_VERSION_1_6
}

struct App {
mut:
	gg            &gg.Context

	init_flag     bool
	
	mouse_x       int = -1
	mouse_y       int = -1

	ticks         i64

	keyboard_visible bool
}

fn (mut a App) show_keyboard() {
	println(@FN)
	$if android {
		if keyboard.visibility(.visible) {
			a.keyboard_visible = true
		}
	}
}

fn (mut a App) hide_keyboard() {
	println(@FN)
	$if android {
		if keyboard.visibility(.hidden) {
			a.keyboard_visible = false
		}
	}
}


fn frame(mut app App) {
	ws := gg.window_size()
	
	min := if ws.width < ws.height { f32(ws.width) } else { f32(ws.height) }

	app.gg.begin()
	sgl.defaults()

	sgl.viewport(int((f32(ws.width)*0.5)-(min*0.5)), int((f32(ws.height)*0.5)-(min*0.5)), int(min), int(min), true)
	draw_triangle()

	app.gg.end()
}

fn draw_triangle() {
	sgl.defaults()
	sgl.begin_triangles()
	sgl.v2f_c3b( 0.0,  0.5, 255, 0, 0)
	sgl.v2f_c3b(-0.5, -0.5, 0, 0, 255)
	sgl.v2f_c3b( 0.5, -0.5, 0, 255, 0)
	sgl.end()
}

fn init(mut app App) {
	desc := sapp.create_desc()
	gfx.setup(&desc)
	sgl_desc := C.sgl_desc_t{
		max_vertices: 50 * 65536
	}
	sgl.setup(&sgl_desc)
}

fn cleanup(mut app App) {
	gfx.shutdown()
}

fn event(ev &gg.Event, mut app App) {
	if ev.typ == .mouse_move {
		app.mouse_x = int(ev.mouse_x)
		app.mouse_y = int(ev.mouse_y)
	}
	if ev.typ == .key_down {
		println('Key down: $ev.key_code')
	}
	if ev.typ == .touches_began || ev.typ == .touches_moved {
		if ev.num_touches > 0 {
			touch_point := ev.touches[0]
			app.mouse_x = int(touch_point.pos_x)
			app.mouse_y = int(touch_point.pos_y)
		}
	}
	if ev.typ == .touches_ended || ev.typ == .mouse_up {
		if ev.num_touches > 0 {
			if app.keyboard_visible { app.hide_keyboard() } else { app.show_keyboard() }
		}
	}

	//println('$app.mouse_x,$app.mouse_y')
}

fn main(){
	// App init
	mut app := &App{
		gg: 0
	}

	app.gg = gg.new_context({
		width: 200
		height: 400
		use_ortho: true // This is needed for 2D drawing
		create_window: true
		window_title: 'Keyboard Demo'
		user_data: app
		bg_color: bg_color
		frame_fn: frame
		init_fn: init
		cleanup_fn: cleanup
		event_fn: event
	})

	app.gg.run()
}
