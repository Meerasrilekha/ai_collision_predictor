import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/splash_screen.dart';
import 'pages/dashboard.dart';
import 'pages/simulation_page.dart';
import 'pages/results_page.dart';
import 'pages/ar_visualization_page.dart';
import 'providers/simulation_provider.dart';
import 'providers/environmental_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SimulationProvider()),
        ChangeNotifierProvider(create: (_) => EnvironmentalProvider()),
      ],
      child: MaterialApp(
        title: 'AI Collision Predictor',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/dashboard': (context) => const Dashboard(),
          '/simulation': (context) => const SimulationPage(),
          '/results': (context) => const ResultsPage(),
          '/ar': (context) => const ARVisualizationPage(),
        },
      ),
    );
  }
}
