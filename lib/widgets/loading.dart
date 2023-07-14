import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(48.0),
      child: Center(
        child: LinearProgressIndicator(
          semanticsLabel: 'Loading...',
        ),
      ),
    );
  }
}
