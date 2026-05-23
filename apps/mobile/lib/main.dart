import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'screens/main_layout.dart';

// ✅ 전역 변수로 선언 — 팀원 코드 영향 없이 카메라 스크린에서 가져다 씀
List<CameraDescription> cameras = [];

// ✅ async로 변경 (카메라 초기화 필요)
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 비동기 초기화 전 필수

  // ✅ 카메라 목록 초기화 — 실패해도 앱은 정상 실행됨
  try {
    cameras = await availableCameras();
  } catch (e) {
    debugPrint('카메라 초기화 실패: $e');
  }

  runApp(const PhotoBoothApp());
}

class PhotoBoothApp extends StatelessWidget {
  const PhotoBoothApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phos',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAF9F6),
        primaryColor: const Color(0xFF9D72FF),
        fontFamily: 'Roboto',
      ),
      home: const MainLayout(), // ✅ 팀원 코드 그대로 유지
      debugShowCheckedModeBanner: false,
    );
  }
}
