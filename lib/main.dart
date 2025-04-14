import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'package:provider/provider.dart';
import 'appState.dart';
import 'theme/AppTheme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import './theme/app_theme_data.dart';
import './database/database_modal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState(); // Initialize
  await appState.initializePersistedState();
  //await AppTheme.initialize();

  //Version
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  print(packageInfo.appName);
  print(packageInfo.packageName);
  print(packageInfo.version);
  print(packageInfo.buildNumber);
  appState.appVerion = "${packageInfo.version}+${packageInfo.buildNumber}";

  //DatabaseModal.dbInit();

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: App(),
  ));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();

  static _AppState of(BuildContext context) => context.findAncestorStateOfType<_AppState>()!;
}

class _AppState extends State<App> {
  //App State
  //AppState appState = AppState.instance;
  ThemeMode _themeMode = AppTheme.themeMode;

  void setThemeMode_invert() => setState(() {
        _themeMode = (_themeMode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
        AppState().update(() {
          AppState().isDarkMode = !AppState().isDarkMode;
        });
        //AppTheme.saveThemeMode(_themeMode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppThemeData.lightTheme,
      darkTheme: AppThemeData.darkTheme,
      themeMode: _themeMode,
      home: const HomePage(),
    );
  }
}
