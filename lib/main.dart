import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:master_thesis/features/app/app.dart';
import 'package:master_thesis/features/data/user_session_repository.dart';
import 'package:master_thesis/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();
  await Firebase.initializeApp();
  final String? userId = await const FlutterSecureStorage()
      .read(key: UserSessionRepository.userSessionKey);
  log('Current User ID: $userId');

  runApp(App());
}
