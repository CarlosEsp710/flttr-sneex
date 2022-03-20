import 'package:flutter/material.dart';

import 'package:flutter_sneex/app/constants/asset_paths.dart';
import 'package:flutter_sneex/app/widgets/loading.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            logo,
            width: 120,
          ),
          const SizedBox(
            height: 10,
          ),
          const Loading(),
        ],
      ),
    );
  }
}
