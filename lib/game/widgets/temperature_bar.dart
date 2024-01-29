import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TemperatureBar extends StatelessWidget {
  ///
  /// [percentFilled] should be a value between 0 and 1.
  /// 0 means the bar is empty, 1 means the bar is full
  ///
  const TemperatureBar({super.key, this.percentFilled = 0});

  final double percentFilled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          '200°',
          style: TextStyle(
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
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200 * percentFilled,
              width: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
