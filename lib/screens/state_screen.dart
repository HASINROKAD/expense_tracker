import 'package:flutter/material.dart';
import '../widgets/state_widgets.dart';

class StatesScreen extends StatelessWidget {
  const StatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const ChartWidget(),
            ],
          ),
        ),
      ),
    );
  }
}