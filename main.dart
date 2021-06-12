import 'dart:ffi' as ffi;
import 'dart:io' show Directory, Platform;

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

import 'raylib.dart' as ray_ffi;

extension StringExtensions on String {
  ffi.Pointer<ffi.Int8> toInt8() {
    return toNativeUtf8().cast<ffi.Int8>();
  }
}

void main() {
  var suffix = 'so';
  if (Platform.isMacOS) suffix = 'dylib';
  if (Platform.isWindows) suffix = 'dll';

  final lib = ffi.DynamicLibrary.open(
      path.join(Directory.current.path, 'raylib.$suffix'));
  final Ray = ray_ffi.NativeLibrary(lib);

  Ray.InitWindow(800, 600, 'test window'.toInt8());
  Ray.SetTargetFPS(60);

  while (Ray.WindowShouldClose() == 0) {
    Ray.BeginDrawing();

    Ray.ClearBackground(Ray.GetColor(0xff9999ff));

    Ray.EndDrawing();
  }

  Ray.CloseWindow();
}
