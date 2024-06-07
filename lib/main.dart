import 'package:chatbot_app/chat_screen.dart';
import 'package:chatbot_app/models/globalSharedPreferences.dart';
import 'package:flutter/material.dart';
import 'chat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.instance.initialise();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter + Generative AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Color.fromARGB(255, 82, 234, 132),
        ),
        useMaterial3: true,
      ),
      home: const Chat(),
    );
  }
}

