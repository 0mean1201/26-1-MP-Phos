import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/main_layout.dart';
import 'services/face_recognition_service.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/sync_service.dart';
import 'core/constants.dart';
import 'core/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FaceRecognitionService().initialize();
  await _ensureAppInstance();
  await _loadSavedTheme();
  await AuthService().init();
  runApp(const PhotoBoothApp());
}

Future<void> _loadSavedTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString('phos_theme') ?? 'light';
  themeNotifier.value = saved == 'dark' ? ThemeMode.dark : ThemeMode.light;
  themeNotifier.addListener(() {
    prefs.setString(
        'phos_theme', themeNotifier.value == ThemeMode.dark ? 'dark' : 'light');
  });
}

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
    SyncService().enqueuePendingPhotos();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) SyncService().enqueuePendingPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: "Pho's App",
          // ── 라이트 테마 ──────────────────────────────
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppColors.background,
            primaryColor: AppColors.primary,
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              surface: Colors.white,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            cardColor: Colors.white,
            dividerColor: Colors.grey,
            fontFamily: 'Roboto',
          ),
          // ── 다크 테마 ──────────────────────────────
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.darkBackground,
            primaryColor: AppColors.darkPrimary,
            colorScheme: const ColorScheme.dark(
              primary: AppColors.darkPrimary,
              surface: AppColors.darkSurface,
              onPrimary: AppColors.darkBackground,
              onSurface: AppColors.darkTextMain,
            ),
            cardColor: AppColors.darkSurface,
            dividerColor: AppColors.darkDivider,
            fontFamily: 'Roboto',
            // 다크 모드 AppBar
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.darkBackground,
              foregroundColor: AppColors.darkTextMain,
              elevation: 0,
            ),
            // 다크 모드 BottomNavigationBar
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: AppColors.darkNavBar,
              selectedItemColor: AppColors.darkPrimary,
              unselectedItemColor: AppColors.darkTextSub,
            ),
            // 다크 모드 Dialog
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.darkSurface,
            ),
            // 다크 모드 SnackBar
            snackBarTheme: const SnackBarThemeData(
              backgroundColor: AppColors.darkSurface,
              contentTextStyle: TextStyle(color: AppColors.darkTextMain),
            ),
          ),
          themeMode: mode,
          home: const MainLayout(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}