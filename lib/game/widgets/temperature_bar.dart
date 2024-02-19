import 'package:beltofdestiny/game/game_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${_temperature.toStringAsFixed(1)}°',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
        const Gap(10),
        Container(
          height: 200,
          width: 18,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
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
                                  _temperature, lowestTemp, highestTemp) >
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
                            lowestTemp,
                            highestTemp,
                          )),
                  width: 7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
