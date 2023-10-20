import 'package:flutter/material.dart';
import 'package:rugram/core/di/app_providers.dart';
import 'package:rugram/features/home/home_page.dart';

import 'di/app_services.dart';

class MyApp extends StatelessWidget {
  final AppServices appServices;

  const MyApp({
    required this.appServices,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      appServices: appServices,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
