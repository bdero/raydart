import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;

void main() async {
  final raylib_ffi =
      File(path.join(Directory.current.path, 'src/generated/raylib.dart'))
          .openRead()
          .transform(utf8.decoder)
          .transform(LineSplitter());

  final raylib_helpers = File(path.join(
          Directory.current.path, 'src/generated/raylib_helpers.dart'))
      .openWrite();

  raylib_helpers.write('''
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

import 'raylib.dart';

''');

  await for (var line in raylib_ffi) {
    if (!line.contains('ffi.Struct')) continue;

    final name = line.split(' ')[1];
    // Extension methods and generics aren't powerful enough to deal with this
    // because `ffi.SizeOf` requires the type parameter to be "compile time
    // constant", and apparently generics are not.
    raylib_helpers.write('''
ffi.Pointer<$name> New$name() {
  return malloc.allocate<$name>(ffi.sizeOf<$name>());
}

''');
  }
}
