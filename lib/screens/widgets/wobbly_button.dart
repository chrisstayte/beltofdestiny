import 'dart:math';

import 'package:beltofdestiny/palette.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

class WobblyButton extends StatefulWidget {
  final Widget child;

  final VoidCallback? onPressed;
  final Color? buttonBackgroundColor;
  final bool willWobble;

  const WobblyButton({
    super.key,
    required this.child,
    this.onPressed,
    this.buttonBackgroundColor,
    bool? willWobble,
  }) : willWobble = willWobble ?? true;

  @override
  State<WobblyButton> createState() => _WobblyButtonState();
}

class _WobblyButtonState extends State<WobblyButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentButtonTheme = context.nesThemeExtension<NesButtonTheme>();

    return MouseRegion(
      onEnter: (event) {
        if (widget.willWobble) _controller.repeat();
      },
      onExit: (event) {
        _controller.stop(canceled: false);
        _controller.reset();
      },
      child: RotationTransition(
        turns: _controller.drive(const _MySineTween(0.005)),
        child: Theme(
          data: flutterNesTheme(
            nesButtonTheme: currentButtonTheme.copyWith(
              primary: widget.buttonBackgroundColor ?? Palette.fountainBlue,
            ),
          ),
          child: NesButton(
            type: NesButtonType.primary,
            onPressed: widget.onPressed,
            child: DefaultTextStyle(
              style:
                  Theme.of(context).textTheme.bodyMedium ?? const TextStyle(),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

class _MySineTween extends Animatable<double> {
  final double maxExtent;

  const _MySineTween(this.maxExtent);

  @override
  double transform(double t) {
    return sin(t * 2 * pi) * maxExtent;
  }
}
