package io.v.android.ex;

import java.lang.CharSequence;
import java.lang.String;

import android.os.Bundle;
import android.widget.RelativeLayout;
import android.widget.EditText;

import android.view.ViewGroup.LayoutParams;
import android.view.inputmethod.InputMethodManager;
import android.content.Context;
import android.text.TextWatcher;
import android.text.Editable;

import android.util.Log; // Log.v(), //Log.d(), //Log.d(), Log.w(), and Log.e()

public class VKeyboardActivity extends io.v.android.VActivity {
	private static final String TAG = "VKeyboardActivity";
	private static VKeyboardActivity thiz;

	private EditText hiddenEditText;
	private RelativeLayout layout;

	private long vApp;
	public VKeyboardActivity() { thiz = this; }

	public static void setVAppPointer(long ptr) {
		thiz.vApp = ptr;
	}

	// This is the "on_soft_keyboard_input" function in V (keyboard.v)
	public native void onSoftKeyboardInput(long app, String s, int start, int before, int count);

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		// Create a layout we can add the hidden EditText widget to.
		RelativeLayout myLayout = new RelativeLayout(this);
		this.layout = myLayout;

		// View the content
		setContentView(myLayout);
	}

	// Example of how to entangle soft input visibility into the Activity life-cycle.
	// Needs better handling but it illustrate what can be done.
	@Override
	protected void onStop(){
		super.onStop();
		thiz.hideSoftKeyboard();
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		thiz.hideSoftKeyboard();
	}

	@Override
	protected void onPause(){
		super.onPause();
		thiz.hideSoftKeyboard();
    }

    @Override
	protected void onResume(){
		super.onResume();
		if(thiz.hiddenEditText == null) {
			return;
		}
		thiz.showSoftKeyboard();
    }

    public static void setSoftKeyboardBuffer(String text) {
		if(thiz.hiddenEditText == null) {
			Log.e(TAG,"No keyboard initalized");
			return;
		}
		final EditText editText = thiz.hiddenEditText;
		editText.setText(text);
		editText.post(new Runnable() {
				@Override
				public void run() {
					editText.setSelection(editText.getText().length());
				}
		});
	}

    public static void showSoftKeyboard() {
		//Log.d(TAG,"showSoftKeyboard called");

		final EditText editText = new EditText(thiz);
		thiz.hiddenEditText = editText;

		thiz.runOnUiThread(new Runnable() {
			public void run() {
				//Log.d(TAG,"showSoftKeyboard IN UI THREAD called");

				// Pass two args; must be LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT, or an integer pixel value.
				editText.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));

				editText.setEnabled(true);
				editText.setFocusableInTouchMode(true);
				editText.setFocusable(true);

				thiz.layout.addView(editText);

				editText.requestFocus();

				InputMethodManager imm = (InputMethodManager) thiz.getSystemService(Context.INPUT_METHOD_SERVICE);
				imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);

				editText.addTextChangedListener(new TextWatcher() {

					@Override
					public void afterTextChanged(Editable s) { /* TODO Auto-generated method stub */ }

					@Override
					public void beforeTextChanged(CharSequence s, int start, int count, int after) { /* TODO Auto-generated method stub */ }

					@Override
					public void onTextChanged(CharSequence s, int start, int before, int count) {
						// This method is called to notify you that, within s, the count characters beginning at start have just replaced old text that had length before.
						//Log.d(TAG,"Java: "+s.toString());
						// Send it off to V method - we are in the UI thread so it's safe to
						// use the vApp pointer in V here!
						thiz.onSoftKeyboardInput(thiz.vApp, s.toString(), start, before, count);

					}
				});
			}
		});
	}

	public static void hideSoftKeyboard() {
		//Log.d(TAG,"hideSoftKeyboard called");

		thiz.runOnUiThread(new Runnable() {
			public void run() {
				//Log.d(TAG,"hideSoftKeyboard IN UI THREAD called");
				EditText et = thiz.hiddenEditText;

				if(et == null) {
					return;
				}
				InputMethodManager imm = (InputMethodManager)thiz.getSystemService(Context.INPUT_METHOD_SERVICE);
				imm.hideSoftInputFromWindow(et.getWindowToken(), 0);

				thiz.getWindow().getDecorView().clearFocus();

				if(thiz.hiddenEditText != null) {
					thiz.hiddenEditText = null;
				}
				thiz.getWindow().getDecorView().clearFocus();
			}
		});
	}

}
