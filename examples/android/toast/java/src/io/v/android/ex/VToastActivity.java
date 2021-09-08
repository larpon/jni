package io.v.android.ex;

import android.widget.Toast;

public class VToastActivity extends io.v.android.VActivity {
	private static VToastActivity thiz;

	public VToastActivity() { thiz = this; }

	private static void showToast(String text) {
		final String s = text;
		thiz.runOnUiThread(new Runnable() {
			public void run() {
				Toast.makeText(thiz, s, Toast.LENGTH_SHORT).show();
			}
		});
	}
}
