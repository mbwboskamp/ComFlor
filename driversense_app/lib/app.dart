import 'package:flutter/material.dart';

class DriverSenseApp extends StatelessWidget {
  const DriverSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Simplified test app
    return MaterialApp(
      title: 'DriverSense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TestHomePage(),
    );
  }
}

class TestHomePage extends StatelessWidget {
  const TestHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DriverSense Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.drive_eta, size: 80, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'App werkt!',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
