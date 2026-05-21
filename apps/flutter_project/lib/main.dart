import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/main_layout.dart';
import 'services/face_recognition_service.dart';
import 'services/api_service.dart';
import 'services/sync_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FaceRecognitionService().initialize();
  await _ensureAppInstance();

  runApp(const PhotoBoothApp());
}

/// 최초 실행 시 서버에서 AppInstance ID를 발급받아 로컬에 저장.
/// 서버가 응답하지 않으면 -1(미등록 sentinel)을 저장하고,
/// 이후 SyncService가 앱 재개 시 재시도한다.
Future<void> _ensureAppInstance() async {
  final prefs = await SharedPreferences.getInstance();
  final stored = prefs.getInt('phos_app_instance_id');

  if (stored != null && stored != -1) {
    ApiService().setAppInstanceId(stored);
    return;
  }

  try {
    final id = await ApiService().registerAppInstance();
    await prefs.setInt('phos_app_instance_id', id);
    ApiService().setAppInstanceId(id);
  } catch (_) {
    await prefs.setInt('phos_app_instance_id', -1);
    ApiService().setAppInstanceId(-1);
  }
}

class PhotoBoothApp extends StatefulWidget {
  const PhotoBoothApp({super.key});

  @override
  State<PhotoBoothApp> createState() => _PhotoBoothAppState();
}

class _PhotoBoothAppState extends State<PhotoBoothApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // 앱 시작 시 한 번 동기화 시도
    SyncService().enqueuePendingPhotos();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      SyncService().enqueuePendingPhotos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pho\'s App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAF9F6),
        primaryColor: const Color(0xFF9D72FF),
        fontFamily: 'Roboto',
      ),
      home: const MainLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}
