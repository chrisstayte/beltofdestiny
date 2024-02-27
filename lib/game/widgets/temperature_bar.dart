import 'package:beltofdestiny/extensions.dart';
import 'package:beltofdestiny/models/remote_config.dart';
import 'package:beltofdestiny/palette.dart';
import 'package:beltofdestiny/providers/remote_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class TemperatureBar extends StatelessWidget {
  const TemperatureBar({super.key, required double temperature})
      : _temperature = temperature;

  final double _temperature;

  @override
  Widget build(BuildContext context) {
    RemoteConfig remoteConfig =
        context.read<RemoteConfigProvider>().remoteConfig;

    double normalizedValue = _temperature.normalizeMinMax(
        remoteConfig.lowestTemp, remoteConfig.highestTemp);

    double screenHeight = MediaQuery.of(context).size.height;

    double temperatureBarHeight = screenHeight / 2;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${_temperature.toStringAsFixed(1)}°',
          style: TextStyle(
              color: Palette.eggPlant,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        )
            .animate(
              autoPlay: false,
              // onComplete: (controller) => controller.repeat(reverse: true),
            )
            .tint(
              color: Colors.red,
              duration: .8.seconds,
            ),
        const Gap(10),
        Container(
          height: temperatureBarHeight,
          width: 30,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Palette.eggPlant,
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: double.infinity,
                  width: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.red,
                        Colors.yellow,
                        Colors.green,
                      ],
                      stops: [0, 0.4, .5],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: AnimatedContainer(
                  duration: 300.milliseconds,
                  height:
                      (temperatureBarHeight - (temperatureBarHeight * .05)) *
                          (1 - normalizedValue),
                  width: 17,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Palette.eggPlant,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
