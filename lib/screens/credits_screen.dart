import 'package:beltofdestiny/providers/audio_provider.dart';
import 'package:beltofdestiny/screens/widgets/wobbly_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
              constraints: const BoxConstraints(
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
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              child: const Text(
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
                                icon: const Icon(Icons.open_in_new),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Privacy'),
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
                                icon: const Icon(Icons.open_in_new),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Terms'),
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
                                icon: const Icon(Icons.open_in_new),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Github'),
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
                                icon: const Icon(Icons.open_in_new),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Flutter Dev Challenge'),
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
                                icon: const Icon(Icons.open_in_new),
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text("Version"),
                              trailing: FutureBuilder(
                                future: PackageInfo.fromPlatform(),
                                builder: (widget, snapshot) {
                                  if (snapshot.hasData) {
                                    PackageInfo info =
                                        snapshot.data as PackageInfo;
                                    return Text(
                                      'v${info.version}+${info.buildNumber}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    );
                                  } else {
                                    return const Text('Loading...');
                                  }
                                },
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('About Belt of Destiny'),
                              trailing: IconButton(
                                onPressed: () => showAboutDialog(
                                  context: context,
                                  applicationLegalese: 'Made by Chris Stayte',
                                ),
                                icon: const Icon(Icons.info_outline),
                              ),
                            ),
                            const Gap(50),
                            NesContainer(
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Text(
                                    'Music',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  const Text('Music from pixabay'),
                                  const Gap(10),
                                  const ListTile(
                                    title: Text('Title'),
                                    trailing: Text(
                                      'Artist',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ...songs.map(
                                    (song) => ListTile(
                                      dense: false,
                                      title: Text(song.name),
                                      trailing: Text(song.artist ?? 'Unknown'),
                                    ),
                                  ),
                                  const Gap(20),
                                  Text(
                                    'Sound Effects',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  const Text('Sound effects from pixabay'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Gap(12),
                  WobblyButton(
                    child: const Text('Back'),
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
