// Copyright(C) 2019-2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package
import gg
import gx
import os.font
import sokol.sapp
import sokol.gfx
import sokol.sgl
import jni
import jni.auto
import jni.android.keyboard

const (
	pkg      = 'io.v.android.ex.VKeyboardActivity'
	bg_color = gx.white
)

[export: 'JNI_OnLoad']
fn jni_on_load(vm &jni.JavaVM, reserved voidptr) int {
	println(@FN + ' called')
	jni.set_java_vm(vm)
	$if android {
		// V consts - can't be used since `JNI_OnLoad`
		// is called by the Java VM before the lib
		// with V's init code is loaded and called.
		jni.setup_android('io.v.android.ex.VKeyboardActivity')
	}
	return int(jni.Version.v1_6)
}

// on_soft_keyboard_input is exported to the Java activity "VKeyboardActivity".
// The method is called in Java to notify you that:
// within `jstr`, the `count` characters beginning at `start` have just replaced old text that had `length` before.
[export: 'JNICALL Java_io_v_android_ex_VKeyboardActivity_onSoftKeyboardInput']
fn on_soft_keyboard_input(env &jni.Env, thiz jni.JavaObject, app_ptr i64, jstr jni.JavaString, start int, before int, count int) {
	if app_ptr == 0 {
		return
	}

	mut app := &App(app_ptr)

	buffer := jni.j2v_string(env, jstr)
	println(@MOD + '.' + @FN + ': "$buffer" ($start,$before,$count)')

	mut char_code := byte(0)
	mut char_literal := ''

	mut pos := start + before
	if pos < 0 {
		println(@MOD + '.' + @FN + ': $pos is negative')
	} else if pos > buffer.len {
		// Backspace
		println(@MOD + '.' + @FN + ': $start > $buffer.len')
	} else {
		char_code = byte(buffer[pos])
		char_literal = char_code.ascii_str()
	}

	println(@MOD + '.' + @FN + ': input "$char_literal"')

	app.buffer = buffer
	app.parsed_char = char_literal

	// TODO sort out this
	/*
	mut e := gg.Event{
		typ: sapp.EventType.key_down
		key_code: gg.KeyCode(char_code)
		char_code: u32(char_code)
		//char_literal
	}

	event(&e, mut app)
	*/
}

struct App {
mut:
	gg &gg.Context

	init_flag bool

	mouse_x int = -1
	mouse_y int = -1

	ticks i64

	buffer      string
	parsed_char string
}

fn (mut a App) show_keyboard() {
	println(@FN)
	$if android {
		auto.call_static_method(pkg + '.showSoftKeyboard()')
		auto.call_static_method(pkg + '.setSoftKeyboardBuffer(string)', a.buffer)
	}
}

fn (mut a App) hide_keyboard() {
	println(@FN)
	$if android {
		auto.call_static_method(pkg + '.hideSoftKeyboard()')
	}
}

fn frame(mut app App) {
	ws := gg.window_size()
	rws := gg.window_size_real_pixels()

	min := if rws.width < rws.height { f32(rws.width) } else { f32(rws.height) }

	app.gg.begin()

	app.gg.draw_text_def(int(f32(ws.width) * 0.1), int(f32(ws.height) * 0.2), 'Java buffer: "$app.buffer"')
	app.gg.draw_text_def(int(f32(ws.width) * 0.1), int(f32(ws.height) * 0.25), 'Last char parsed in V: "$app.parsed_char"')
	// NOTE Don't call out to slow Java code (keyboard.is_visible()) like this every frame
	// app.gg.draw_text_def(int(f32(ws.width) * 0.1), int(f32(ws.height) * 0.27), 'Keyboard visible: ${keyboard.is_visible()}')

	sgl.viewport(int((f32(rws.width) * 0.5) - (min * 0.5)), int((f32(rws.height) * 0.5) - (min * 0.5)),
		int(min), int(min), true)
	draw_triangle()

	app.gg.end()
}

fn draw_triangle() {
	sgl.defaults()
	sgl.begin_triangles()
	sgl.v2f_c3b(0.0, 0.5, 255, 0, 0)
	sgl.v2f_c3b(-0.5, -0.5, 0, 0, 255)
	sgl.v2f_c3b(0.5, -0.5, 0, 255, 0)
	sgl.end()
}

fn init(mut app App) {
	// Pass app reference off to Java so we
	// can get it back in the V callback (on_soft_keyboard_input)
	app_ref := i64(voidptr(app))
	auto.call_static_method(pkg + '.setVAppPointer(long) void', app_ref)
}

fn cleanup(mut app App) {
	keyboard.visibility(.hidden)
	gfx.shutdown()
}

fn event(ev &gg.Event, mut app App) {
	if ev.typ == .mouse_move {
		app.mouse_x = int(ev.mouse_x)
		app.mouse_y = int(ev.mouse_y)
	}
	$if debug ? {
		if ev.typ == .char || ev.typ == .key_down || ev.typ == .key_up {
			println('$ev.typ : $ev.char_code, $ev.key_code')
		}
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
			if keyboard.is_visible() {
				app.hide_keyboard()
			} else {
				app.show_keyboard()
			}
		}
	}
}

fn main() {
	mut app := &App{
		gg: 0
	}

	app.gg = gg.new_context(
		width: 200
		height: 400
		use_ortho: true
		create_window: true
		window_title: 'Keyboard Demo'
		user_data: app
		bg_color: bg_color
		frame_fn: frame
		init_fn: init
		cleanup_fn: cleanup
		event_fn: event
		font_path: font.default()
	)

	app.gg.run()
}
