import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:maps_flutter/provider/api_provider.dart';
import 'package:maps_flutter/services/api_service.dart';
import 'package:maps_flutter/services/direction_service.dart';
import 'package:maps_flutter/services/picker_service.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PickerServiceScreen()),
        ChangeNotifierProvider(create: (context) => DirectionService()),
        ChangeNotifierProvider(
          create: (context) => ApiProvider(
            ApiService(
              Client(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const HomePage(),
      ),
    );
  }
}
