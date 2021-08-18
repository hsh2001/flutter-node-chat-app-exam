import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../provider/count_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final countProvider = Provider.of<CountProvider>(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: countProvider.up,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                'images/moa.jpg',
                width: 100,
                height: 100,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: Text(
                'Hello Flutter!\nYou clicked moa\n${countProvider.count} times',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.toNamed('/test'),
            child: const Text('Go to test page to click this button'),
          ),
        ],
      ),
    );
  }
}
