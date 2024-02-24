import 'package:beltofdestiny/game/game_config.dart';
import 'package:beltofdestiny/models/remote_config.dart';
import 'package:beltofdestiny/palette.dart';
import 'package:beltofdestiny/providers/remote_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class TemperatureBar extends StatelessWidget {
  const TemperatureBar({super.key, required temperature})
      : _temperature = temperature;

  final double _temperature;

  double _normalizeValue(double value, double low, double high) {
    // Clamp the value between low and high
    double clampedValue = value.clamp(low, high);

    // Normalize the clamped value to a 0-1 range
    double normalizedValue = (clampedValue - low) / (high - low);

    return normalizedValue;
  }

  @override
  Widget build(BuildContext context) {
    RemoteConfig remoteConfig =
        context.read<RemoteConfigProvider>().remoteConfig;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${_temperature.toStringAsFixed(1)}°',
          style: TextStyle(
            color: Palette.eggPlant,
            fontSize: 10,
          ),
        ), // TODO: flash the text as the temperature hits near the top
        const Gap(10),
        Container(
          height: 200,
          width: 18,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Palette.eggPlant,
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: double.infinity,
                  width: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
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
                )
                    .animate(
                      autoPlay: _normalizeValue(
                                  _temperature,
                                  remoteConfig.lowestTemp,
                                  remoteConfig.highestTemp) >
                              0.8
                          ? true
                          : false,
                      onComplete: (controller) => controller.repeat(),
                    )
                    .shimmer(
                      color: Colors.white,
                      duration: 1.5.seconds,
                    ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: AnimatedContainer(
                  duration: 300.milliseconds,
                  height: 180 *
                      (1 -
                          _normalizeValue(
                            _temperature,
                            remoteConfig.lowestTemp,
                            remoteConfig.highestTemp,
                          )),
                  width: 7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Palette.eggPlant,
                  ),
                ),
              ),
            ],
          ),
        )
        // TODO: Animate bar shaking as it gets closer to the top,
      ],
    );
  }
}
