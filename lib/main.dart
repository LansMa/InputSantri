import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fskoruqudtcnlbghtpuw.supabase.co', // Ganti!
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZza29ydXF1ZHRjbmxiZ2h0cHV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA1NjczNjgsImV4cCI6MjA2NjE0MzM2OH0.feqwCASKZTB-4_-kC7nlcLFke-9e7MXLTqxyxCcuVWw', // Ganti!
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Izin Santri',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
