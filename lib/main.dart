import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensormobileapplication/components/ThemeProvider.dart';
import 'package:sensormobileapplication/screens/StepCounter.dart';
import 'package:sensormobileapplication/screens/compass.dart';
import 'package:sensormobileapplication/screens/lightsensor.dart';
import 'package:sensormobileapplication/screens/maps.dart';
import 'package:sensormobileapplication/screens/proximitysensor.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
  await initNotifications();
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
      // Handle notification tap
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: themeNotifier.currentTheme,
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({required this.title, Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.hintColor,
        title: Text(
          widget.title,
          style: TextStyle(color: theme.primaryColor),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildOption(
            context,
            theme,
            icon: Icons.map,
            label: 'Maps',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapPage())),
          ),
          _buildOption(
            context,
            theme,
            icon: Icons.sensor_door,
            label: 'Proximity Sensor',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProximityPage())),
          ),
          _buildOption(
            context,
            theme,
            icon: Icons.run_circle_outlined,
            label: 'Step Counter',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => StepCounterPage())),
          ),
          _buildOption(
            context,
            theme,
            icon: Icons.compass_calibration_outlined,
            label: 'Compass',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CompassPage())),
          ),
          _buildOption(
            context,
            theme,
            icon: Icons.lightbulb_rounded,
            label: 'Light Sensor',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => LightSensorPage())),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, ThemeData theme, {required IconData icon, required String label, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, size: 50.0, color: theme.primaryColor),
        title: Text(label, style: TextStyle(color: theme.primaryColor)),
        onTap: onTap,
      ),
    );
  }
}
