package io.vlang;

public class V
{
	int m_int_test;

	/* load the 'vlang' library on application startup.
	* On Android the library will have already been unpacked into
	* "/data/data/io.vlang/lib/libvlang.so" at installation time.
	*/
	static {
		System.loadLibrary("vlang");
	}

	public static void main(String[] args) {
		// Instatiate "V" class
		V v = new V();
		// Call native methods
		System.out.println("Java: V string: "+v.vGetString());
		System.out.println("Java: V int: "+v.vGetInt());
		System.out.println("Java: V add int: "+v.vAddInt(40,2));
		// V calls static methods on this V.class
		System.out.println("Java: V calls static methods:");
		v.callStaticMethods();
		// V calls object methods on this V.class
		System.out.println("Java: V calls object methods:");
		v.callObjectMethods();
		// Call method  we haven't implemented or exported in V (libvlang)
		try {
			v.unimplementedInV();
		} catch(java.lang.UnsatisfiedLinkError e) {
			System.out.println(e.toString());
			System.out.println("Exception example - no worries");
		}
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
	public void setInt(int val) {
		this.m_int_test = val;
		System.out.println("Java: "+V.class.getName()+'.'+getCurrentMethodName()+"() called by "+getCallerMethodName()+" value: "+this.m_int_test);
	}

	// Static "reflected" methods
	public static void vprintln(String s) {
		System.out.println("Java: "+V.class.getName()+'.'+getCurrentMethodName()+"(\""+s+"\") called by "+getCallerMethodName());
	}

	public static float javaFloatFunc(String s, int i) {
		System.out.println("Java: "+V.class.getName()+'.'+getCurrentMethodName()+"(\""+s+"\",\""+i+"\") called by "+getCallerMethodName());
		return 0.5f;
	}

	public static void javaVoidFunc(String s, int i) {
		System.out.println("Java: "+V.class.getName()+'.'+getCurrentMethodName()+"(\""+s+"\",\""+i+"\") called by "+getCallerMethodName());
	}

	// Static methods
	public static int mixedArguments(boolean add_i, int i) {
		System.out.println("Java: "+V.class.getName()+'.'+getCurrentMethodName()+"("+add_i+","+i+") called by "+getCallerMethodName());
		int out = 40;
		if (add_i == true) { out += i; }
		return out;
	}

	public static int getInt() {
		System.out.println("Java: "+V.class.getName()+'.'+getCurrentMethodName()+"() called by "+getCallerMethodName());
		return 42;
	}

	public static boolean getBool() {
		System.out.println("Java: "+V.class.getName()+'.'+getCurrentMethodName()+"() called by "+getCallerMethodName());
		return false;
	}

	public static float getFloat() {
		System.out.println("Java: "+V.class.getName()+'.'+getCurrentMethodName()+"() called by "+getCallerMethodName());
		return 42.5f;
	}

	public static String getString() {
		System.out.println("Java: "+V.class.getName()+'.'+getCurrentMethodName()+"() called by "+getCallerMethodName());
		return "Test string";
	}

	// Utils for debugging - don't use in production
	public static String getCurrentMethodName() {
		return StackWalker.getInstance()
						.walk(s -> s.skip(1).findFirst())
						.get()
						.getMethodName();
	}

	public static String getCallerMethodName() {
		return StackWalker.getInstance()
						.walk(s -> s.skip(2).findFirst())
						.get()
						.getClassName()+'.'+StackWalker.getInstance()
						.walk(s -> s.skip(2).findFirst())
						.get()
						.getMethodName();
	}
}
