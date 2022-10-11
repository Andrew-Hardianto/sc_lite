import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sc_lite/provider/user_provider.dart';
import 'package:sc_lite/router.dart';
import 'package:sc_lite/service/main_service.dart';
import 'package:sc_lite/views/screen/get-started/get_started_screen.dart';
import 'package:sc_lite/views/screen/home/home_screen.dart';
import 'package:sc_lite/views/screen/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await requestPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final mainService = MainService();
  dynamic first;
  dynamic token;

  @override
  void initState() {
    super.initState();
    // _initPage();
  }

  Widget? _initPage() {
    mainService.storage.read(key: 'firstLaunch').then((value) {
      setState(() {
        first = value;
      });
    });
    mainService.storage.read(key: 'ACT@KN2').then((value) {
      setState(() {
        token = value;
      });
    });
    if (first != null) {
      if (token == null) {
        return const LoginScreen();
      } else if (token != null) {
        return const HomeScreen();
      }
    } else {
      return const GetStartedScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Starconnect Lite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
        fontFamily: 'Nunito',
      ),
      onGenerateRoute: ((settings) => generateRoute(settings)),
      home: _initPage(),
      builder: EasyLoading.init(),
    );
  }
}

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  setupNotifications();
  showFlutterNotification(message);
}

setupNotifications() async {
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
      enableVibration: true,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }
}

Future<void> requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.instance.getToken().then((value) async {
    print(value);
    await MainService()
        .storage
        .write(key: 'YLI2Q4W', value: MainService().encrypt(value!));
  });
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'launch_background',
        ),
      ),
    );
  }
}
