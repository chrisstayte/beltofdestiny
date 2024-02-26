import 'package:beltofdestiny/screens/widgets/wobbly_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: kIsWeb ? const EdgeInsets.all(15.0) : EdgeInsets.zero,
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 800,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Credits',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Expanded(
                    child: NesSingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 25),
                              child: Text(
                                  '''Submission for 2024 Flutter Dev Challenge
                                  
                                  Much love and support to all of the packages I relied on to help me build this app and much thanks to flutter for such a great framework.
                                  '''),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Author'),
                              subtitle: const Text('Chris Stayte'),
                              trailing: IconButton(
                                onPressed: () async {
                                  Uri url =
                                      Uri.parse('https://chrisstayte.com');

                                  if (kIsWeb) {
                                    launchUrl(
                                      url,
                                    );
                                  } else {
                                    if (await canLaunchUrl(url)) {
                                      launchUrl(url);
                                    }
                                  }
                                },
                                icon: const Icon(Icons.link),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('Privacy'),
                              trailing: IconButton(
                                onPressed: () async {
                                  Uri url = Uri.parse(
                                      'https://beltofdestiny.com/privacy');

                                  if (kIsWeb) {
                                    launchUrl(url);
                                  } else {
                                    if (await canLaunchUrl(url)) {
                                      launchUrl(url);
                                    }
                                  }
                                },
                                icon: Icon(Icons.link),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('Terms'),
                              trailing: IconButton(
                                onPressed: () async {
                                  Uri url = Uri.parse(
                                      'https://beltofdestiny.com/terms');

                                  if (kIsWeb) {
                                    launchUrl(url);
                                  } else {
                                    if (await canLaunchUrl(url)) {
                                      launchUrl(url);
                                    }
                                  }
                                },
                                icon: Icon(Icons.link),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('Github'),
                              trailing: IconButton(
                                onPressed: () async {
                                  Uri url = Uri.parse(
                                      'https://github.com/chrisstayte/beltofdestiny');

                                  if (kIsWeb) {
                                    launchUrl(url);
                                  } else {
                                    if (await canLaunchUrl(url)) {
                                      launchUrl(url);
                                    }
                                  }
                                },
                                icon: Icon(Icons.link),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('Flutter Dev Challenge'),
                              trailing: IconButton(
                                onPressed: () async {
                                  Uri url = Uri.parse(
                                      'https://flutter.dev/global-gamers');

                                  if (kIsWeb) {
                                    launchUrl(url);
                                  } else {
                                    if (await canLaunchUrl(url)) {
                                      launchUrl(url);
                                    }
                                  }
                                },
                                icon: Icon(Icons.link),
                              ),
                            ),
                            const Gap(34),
                            const AboutListTile(
                              dense: false,
                              icon: Icon(Icons.info_outline_rounded),
                            ),
                          ],
                        ),
                      ),
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
        ),
      ),
    );
  }
}
