import 'package:beltofdestiny/screens/widgets/wobbly_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Credits'),
            const Gap(12),
            WobblyButton(
              child: Text('Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
