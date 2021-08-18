import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'provider/count_provider.dart';
import 'screen/home_screen.dart';
import 'screen/test_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CountProvider()),
      ],
      child: GetMaterialApp(
        title: 'Hello flutter',
        theme: ThemeData(primaryColor: Colors.blue),
        home: const HomeScreen(),
        getPages: [
          GetPage(
            name: '/test',
            page: () => const TestScreen(),
          ),
        ],
      ),
    );
  }
}
