/* Flutter & Dart */
import 'package:flutter/material.dart';
import 'dart:async';

/* Internal Widget */
import 'tap_bounce.dart';

void showTopSnackBar(
  BuildContext context,
  Widget child, {
  Duration showOutAnimationDuration = const Duration(milliseconds: 1200),
  Duration hideOutAnimationDuration = const Duration(milliseconds: 550),
  Duration displayDuration = const Duration(milliseconds: 3000),
  double additionalTopPadding = 0.0,
  VoidCallback onTap,
  OverlayState overlayState,
}) async {
  overlayState ??= Overlay.of(context);
  OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) {
      return TopSnackBar(
        child: child,
        onDismissed: () => overlayEntry.remove(),
        showOutAnimationDuration: showOutAnimationDuration,
        hideOutAnimationDuration: hideOutAnimationDuration,
        displayDuration: displayDuration,
        additionalTopPadding: additionalTopPadding,
        onTap: onTap,
      );
    },
  );

  overlayState.insert(overlayEntry);
}

class TopSnackBar extends StatefulWidget {
  final Widget child;
  final VoidCallback onDismissed;
  final showOutAnimationDuration;
  final hideOutAnimationDuration;
  final displayDuration;
  final additionalTopPadding;
  final VoidCallback onTap;

  TopSnackBar({
    @required this.child,
    @required this.onDismissed,
    @required this.showOutAnimationDuration,
    @required this.hideOutAnimationDuration,
    @required this.displayDuration,
    @required this.additionalTopPadding,
    this.onTap,
  });

  @override
  _TopSnackBarState createState() => _TopSnackBarState();
}

class _TopSnackBarState extends State<TopSnackBar>
    with SingleTickerProviderStateMixin {
  Animation offsetAnimation;
  AnimationController animationController;
  double topPosition;
  StreamSubscription _changeStateStream;

  @override
  void initState() {
    topPosition = widget.additionalTopPadding;
    _setupAndStartAnimation();
    super.initState();
  }

  void _setupAndStartAnimation() async {
    animationController = AnimationController(
      vsync: this,
      duration: widget.showOutAnimationDuration,
      reverseDuration: widget.hideOutAnimationDuration,
    );

    Tween<Offset> offsetTween = Tween<Offset>(
      begin: Offset(0.0, 0.0),
      end: Offset(0.0, 0.0),
    );

    offsetAnimation = offsetTween.animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
        reverseCurve: Curves.linearToEaseOut,
      ),
    )..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          await Future.delayed(widget.displayDuration);
          animationController.reverse();
          if (mounted) {
            setState(() {
              topPosition = 0;
            });
          }
        }

        if (status == AnimationStatus.dismissed) {
          widget.onDismissed.call();
        }
      });

    animationController.forward();
  }

  @override
  void dispose() {
    _changeStateStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedPositioned(
      duration: widget.hideOutAnimationDuration * 1.5,
      curve: Curves.linearToEaseOut,
      bottom: topPosition,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: offsetAnimation as Animation<Offset>,
        child: SafeArea(
          child: TapBounceContainer(
            onTap: () {
              widget.onTap?.call();
              animationController.reverse();
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
