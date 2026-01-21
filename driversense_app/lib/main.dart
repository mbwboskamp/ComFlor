import 'package:flutter/material.dart';
import 'package:driversense_app/bootstrap.dart';
import 'package:driversense_app/app.dart';
import 'package:driversense_app/core/config/env_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await bootstrap(EnvConfig.dev);

  runApp(const DriverSenseApp());
}
