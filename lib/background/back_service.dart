import 'dart:ui';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wagwan/services/database.dart';

import '../firebase_options.dart';
import 'notification.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

Future<void> initBgService() async {
  final service = FlutterBackgroundService();
  final AndroidConfiguration androidConfiguration =
      AndroidConfiguration(onStart: onStart, isForegroundMode: true);
  final IosConfiguration iosConfiguration = IosConfiguration();
  await service.configure(
    androidConfiguration: androidConfiguration,
    iosConfiguration: iosConfiguration,
  );
}

Future initFireBase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance serviceInstance) async {
  DartPluginRegistrant.ensureInitialized();
  await initFireBase();

  print("started...");

  while (FirebaseAuth.instance.currentUser == null) {
    print("No user.");
    await Future.delayed(const Duration(seconds: 5));
  }

  final database = DatabaseService(FirebaseAuth.instance.currentUser?.uid);

  // ignore: unused_local_variable
  final listener = database.notification.listen((snapshots) {
    for (final snapshot in snapshots.docChanges) {
      if (snapshot.type == DocumentChangeType.added) {
        final data = snapshot.doc.data() as Map;
        print(data);
        // UserNotification userNotification =
        //     UserNotification.fromMapData(snapshot.doc.data() as Map);
        sendNotifications(
            "New Message", data['display_name'] + ": " + data['message']);
      }
    }
  });

  // ignore: unused_local_variable
  final userStateListener = FirebaseAuth.instance.userChanges().listen((user) {
    if (user == null) {
      serviceInstance.stopSelf();
    }
  });
}

void sendNotifications(String title, String description) async {
  LocalNotification notification = LocalNotification();
  await notification.setup();

  notification.showNotification(title, description);
}
