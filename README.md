# JNI wrapper for V

V wrapper around the C Java Native Interface

**This is Work-In-Progress** - things will break and things will change.

You will need a working install of the [V compiler](https://github.com/vlang/v)
and a working Java JDK environment (version >= 8).

## Install
```bash
git clone https://github.com/Larpon/jni.git ~/.vmodules/jni
```

## Quick start

To use `jni` it is required to set the `JAVA_HOME` env variable to
point to a valid Java install path that hosts the JNI you want to use.

```bash
export JAVA_HOME=/path/to/java/root
```

### Desktop

To build the desktop example do:

```
cd ~/.vmodules/jni/examples/desktop/v_as_library
v run build.vsh
```

The `build.vsh` script is a simple helper for doing:
```
export JAVA_HOME=/detect/path/to/java/root
export LD_LIBRARY_PATH="$(pwd)":$LD_LIBRARY_PATH # Needed for Java to load the shared library
v -prod -shared libvlang.v
javac io/vlang/V.java
java io.vlang.V
```

### Android

The `jni` module supports Java interoperability with both Desktop and Android platforms.

To build the Android example you'll need a working version of [`vab`](https://github.com/vlang/vab).

Then simply do:
```
./vab ~/.vmodules/jni/examples/android/toast
```
