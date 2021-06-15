import 'dart:ffi' as ffi;
import 'dart:io' show Directory, Platform;

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

import 'generated/raylib.dart';

export 'generated/raylib.dart';
export 'generated/raylib_helpers.dart';

extension StringExtensions on String {
  ffi.Pointer<ffi.Int8> toInt8() {
    return toNativeUtf8().cast<ffi.Int8>();
  }
}

String GetLibSuffix() {
  var suffix = 'so';
  if (Platform.isMacOS) suffix = 'dylib';
  if (Platform.isWindows) suffix = 'dll';
  return suffix;
}

final lib = ffi.DynamicLibrary.open(
    path.join(Directory.current.path, 'raylib.${GetLibSuffix()}'));
final ray = NativeLibrary(lib);
