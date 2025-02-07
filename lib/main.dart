import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/motel_provider.dart';
import 'views/motel_list_screen.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MotelProvider()), // Adicione o Provider aqui
      ],
      child: MaterialApp(
        title: 'Motel Finder',
        theme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFFD11521),
            onPrimary: Color(0xFFFFFFFF),
            secondary: Color.fromARGB(255, 138, 138, 138),
            onSecondary: Color(0xFFFFFFFF),
            error: Color(0x66EB5757),
            onError: Color(0x66EB5757),
            surface: Color(0xFFF0F0F0),
            onSurface: Color(0xFFA4AAB4),
          ),
        ),
        home: const MotelListScreen(),
      ),
    );
  }
}
