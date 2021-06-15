import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';

import 'raylib.dart';

void main() {
  ray.InitWindow(800, 600, 'test window'.toInt8());
  ray.SetTargetFPS(60);

  final p_camera = NewCamera3D();
  final camera = p_camera.ref
    ..position.x = 4
    ..position.y = 2
    ..position.z = 4
    ..target.x = 0
    ..target.y = 0
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
        ray.DrawCube(
            NewVector3().ref
              ..x = 0
              ..y = 0
              ..z = 0,
            1,
            1,
            1,
            ray.GetColor(0xffffffff));
      }
      ray.EndMode3D();
    }
    ray.EndDrawing();
  }

  ray.CloseWindow();
}
