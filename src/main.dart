import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';

import 'generated/raylib.dart';
import 'raylib.dart';

void main() {
  ray.InitWindow(800, 600, 'test window'.toInt8());
  ray.SetTargetFPS(60);

  final p_camera = malloc.allocate<Camera3D>(ffi.sizeOf<Camera3D>());
  final camera = p_camera.ref
    ..position.x = 4
    ..position.y = 2
    ..position.z = 4
    ..target.x = 0
    ..target.y = 1.8
    ..target.z = 0
    ..up.x = 0
    ..up.y = 1
    ..up.z = 0
    ..fovy = 60
    ..projection = CameraProjection.CAMERA_PERSPECTIVE;

  ray.SetCameraMode(camera, CameraMode.CAMERA_FIRST_PERSON);

  while (ray.WindowShouldClose() == 0) {
    ray.UpdateCamera(p_camera);
    ray.BeginDrawing();
    {
      ray.ClearBackground(ray.GetColor(0xff9999ff));

      ray.BeginMode3D(camera);
      {
        //final v = Vector3();
        //print(v.x);
        //ray.DrawCube(v, 2, 2, 2, ray.GetColor(0x0088ffff));
      }
      ray.EndMode3D();
    }
    ray.EndDrawing();
  }

  ray.CloseWindow();
}
