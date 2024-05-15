import 'package:ctrl_r/databases/controle_database.dart';
import 'package:ctrl_r/providers/alert_provider.dart';
import 'package:ctrl_r/providers/controle_provider.dart';
import 'package:ctrl_r/providers/location_provider.dart';
import 'package:ctrl_r/providers/role_provider.dart';
import 'package:ctrl_r/screens/pages/splash_screen.dart';
import 'package:ctrl_r/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ControleDatabase.instance.database;
  // Position position = await LocationService.determinePosition();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ControleProvider>(
          create: (_) => ControleProvider(),
        ),
        ChangeNotifierProvider<AlertProvider>(
          create: (_) => AlertProvider(),
        ),
        ChangeNotifierProvider<RoleProvider>(
          create: (_) => RoleProvider(),
        ),
        ChangeNotifierProvider<LocationProvider>(
          create: (_) => LocationProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CTRL R',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const SplashScreen(),
    );
  }
}
