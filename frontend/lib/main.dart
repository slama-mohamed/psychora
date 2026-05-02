import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:psychora/core/navigation/app_router.dart';
import 'package:psychora/core/network/api_service.dart';
import 'package:psychora/features/patients/presentation/providers/patient_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final PatientProvider patientProvider = PatientProvider(prefs);
  await patientProvider.load();
  
  // Load auth token from storage at app startup
  debugPrint('DEBUG: Loading token from storage at app startup...');
  await ApiService().readTokenFromStorage();
  debugPrint('DEBUG: App startup complete');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PatientProvider>.value(value: patientProvider),
      ],
      child: const Myapp(),
    ),
  );
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  } 
}