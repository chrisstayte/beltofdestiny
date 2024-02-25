import 'package:beltofdestiny/screens/widgets/wobbly_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Credits',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 25,
                  ),
                  children: [
                    ListTile(
                      title: Text('Author'),
                      subtitle: Text('Chris Stayte'),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.link),
                      ),
                    ),
                    ListTile(
                      title: Text('Privacy'),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.link),
                      ),
                    ),
                    ListTile(
                      title: Text('Terms'),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.link),
                      ),
                    ),
                    ListTile(
                      title: Text('Terms'),
                    )
                  ],
                ),
              ),
              const Gap(12),
              WobblyButton(
                child: Text('Back'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
