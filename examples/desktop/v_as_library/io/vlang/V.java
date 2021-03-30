package io.vlang;

public class V
{
	private static final String LOGTAG = "Java: io.vlang.V";
	int m_int_test;

	/* load the 'vlang' library on application startup.
	* On Android the library will have already been unpacked into
	* "/data/data/io.vlang/lib/libvlang.so" at installation time.
	*/
	static {
		System.out.println(LOGTAG+" Library look-up path(s):"+System.getProperty("java.library.path"));
		System.loadLibrary("vlang");
	}

	public static void main(String[] args) {
		// Instatiate "V" class
		V v = new V();
		// Call native methods
		System.out.println(LOGTAG+".main() string: "+v.vGetString());
		System.out.println(LOGTAG+".main() int: "+v.vGetInt());
		System.out.println(LOGTAG+".main() add int: "+v.vAddInt(40,2));
		// V calls static methods on this V.class
		System.out.println(LOGTAG+".main() callling static methods...");
		v.callStaticMethods();
		// V calls object methods on this V.class
		System.out.println(LOGTAG+".main() callling object methods...");
		v.callObjectMethods();
		// Call method  we haven't implemented or exported in V (libvlang)
		try {
			v.unimplementedInV();
		} catch(java.lang.UnsatisfiedLinkError e) {
			System.out.println(e.toString());
			System.out.println(LOGTAG+".main() Exception example - no worries");
		}
		System.out.println(LOGTAG+".main() recovered :)");
	}

	/* Native methods
	* Native methods implemented by the 'libvlang' native library,
	* packaged with this application.
	*/
	public native void callStaticMethods();
	public native void callObjectMethods();
	public native String vGetString();
	public native int vGetInt();
	public native int vAddInt(int a, int b);

	/* Unimplemented native method declaration that is *not*
	* implemented by 'libvlang'.
	* This is simply to show that you can declare as many native
	* methods in your Java code as you want, their implementation
	* is searched in the currently loaded native libraries only the
	* first time you call them.
	*
	* Trying to call this function will result in a
	* java.lang.UnsatisfiedLinkError exception !
	*/
	public native String unimplementedInV();

	// Instance methods, touching member fields
	public V getInstance() {
		System.out.println(LOGTAG+".getInstance() returning 'this' to V code");
		return this;
	}

	public void passInstance(V v) {
		if(v == null) {
			System.out.println(LOGTAG+".passInstance() passed V instance is null :(");
			return;
		}
		System.out.println(LOGTAG+".passInstance() value: "+v.toString());
		v.setInt(43);
	}

	// Instance methods, touching member fields
	public void setInt(int val) {
		this.m_int_test = val;
		System.out.println(LOGTAG+".setInt()"+"() value: "+this.m_int_test);
	}

	// Static "reflected" methods
	public static void jprintln(String s) {
		System.out.println(LOGTAG+".jprintln"+"(\""+s+"\")");
	}

	public static float javaFloatFunc(String s, int i) {
		System.out.println(LOGTAG+".javaFloatFunc"+"(\""+s+"\",\""+i+"\")");
		return 0.5f;
	}

	public static void javaVoidFunc(String s, int i) {
		System.out.println(LOGTAG+".javaVoidFunc"+"(\""+s+"\",\""+i+"\")");
	}

	// Static methods
	public static int mixedArguments(boolean add_i, int i) {
		System.out.println(LOGTAG+".mixedArguments"+"("+add_i+","+i+")");
		int out = 40;
		if (add_i == true) { out += i; }
		return out;
	}

	public static int getInt() {
		System.out.println(LOGTAG+".getInt"+"()");
		return 42;
	}

	public static boolean getBool() {
		System.out.println(LOGTAG+".getBool"+"()");
		return false;
	}

	public static float getFloat() {
		System.out.println(LOGTAG+".getFloat"+"()");
		return 42.5f;
	}

	public static String getString() {
		System.out.println(LOGTAG+".getString"+"()");
		return "Hello from Java";
	}
}
