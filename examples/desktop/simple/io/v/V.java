package io.v;

public class V
{
	private static final String LOGTAG = "Java: io.v.V";

	static {
		System.out.println(LOGTAG+" Library look-up path(s):"+System.getProperty("java.library.path"));
		System.loadLibrary("v");
	}

	public static void main(String[] args) {
		// Create instance of the "V" class
		V v = new V();
		// Call native methods
		System.out.println(LOGTAG+".main() string from native V: \""+v.getStringFromV()+"\"");
	}

	/* Native methods
	* Native methods implemented by the 'libv' native library,
	* packaged with this application.
	*/
	public native String getStringFromV();

	// Static method
	public static String getStringFromJava() {
		return "Hello from Java!";
	}
}
