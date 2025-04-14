import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/project_task_provider.dart';
import 'providers/time_entry_provider.dart';
import 'screens/home_screen.dart';
import 'screens/project_task_management_screen.dart';
import 'screens/add_time_entry_screen.dart';

void main() {
  runApp(TimeTrackerApp());
}

class TimeTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectTaskProvider()),
        ChangeNotifierProvider(create: (_) => TimeEntryProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.teal, // Teal AppBar as per screenshots
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.yellow[700], // Yellow FAB
            foregroundColor: Colors.black,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/manage': (context) => ProjectTaskManagementScreen(),
          '/add_entry': (context) => AddTimeEntryScreen(),
        },
      ),
    );
  }
}