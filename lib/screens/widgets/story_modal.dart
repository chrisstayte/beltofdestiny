import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StoryModal extends StatelessWidget {
  const StoryModal({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Story'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Once upon a time, in a land far, far away...',
              style: TextStyle(fontSize: 20),
            ),
            Gap(20),
            Text(
              'There was a hero who was destined to save the world.',
              style: TextStyle(fontSize: 20),
            ),
            Gap(20),
            Text(
              'But first, they had to find the Belt of Destiny.',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
