import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/item_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CampusLostFoundApp());
}

class CampusLostFoundApp extends StatelessWidget {
  const CampusLostFoundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemProvider()),
      ],
      child: MaterialApp(
        title: 'Campus Lost & Found',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00756A)),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
