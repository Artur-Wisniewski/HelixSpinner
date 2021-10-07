import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Double Helix Spinner',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 100),
                HelixSpinner(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HelixSpinner extends StatefulWidget {
  const HelixSpinner({Key? key}) : super(key: key);

  @override
  _HelixSpinnerState createState() => _HelixSpinnerState();
}

enum AniProps { scale, color, positionHeight }

class _HelixSpinnerState extends State<HelixSpinner> with AnimationMixin {
  List<TimelineTween<AniProps>> tweens = [];
  List<TimelineTween<AniProps>> reverseTweens = [];
  List<CustomAnimationControl> controls = [];
  List<CustomAnimationControl> reverseTweensControls = [];

  static const Curve _curve = Cubic(0.42, 0, 0.58, 1);

  TimelineTween<AniProps> createTween({
    double distance = 50,
    required Color color1,
    required Color color2,
    required Color color3,
    Duration duration = const Duration(milliseconds: 600),
  }) =>
      TimelineTween<AniProps>()
        ..addScene(
          begin: Duration.zero,
          duration: duration,
          curve: Curves.easeInCirc,
        )
            .animate(AniProps.scale, tween: Tween<double>(begin: 1.0, end: 0.3))
            .animate(AniProps.color,
                tween: ColorTween(begin: color1, end: color2))
        ..addScene(begin: Duration.zero, duration: duration * 2, curve: _curve)
            .animate(AniProps.positionHeight,
                tween: Tween<double>(begin: -distance, end: distance))
        ..addScene(
          begin: duration,
          duration: duration,
          curve: Curves.easeOutCirc,
        )
            .animate(AniProps.color,
                tween: ColorTween(begin: color2, end: color1))
            .animate(AniProps.scale, tween: Tween<double>(begin: 0.3, end: 1.0))
        //Comeback
        ..addScene(
          begin: duration * 2,
          duration: duration,
          curve: Curves.easeInCirc,
        )
            .animate(AniProps.color,
                tween: ColorTween(begin: color1, end: color3))
            .animate(AniProps.scale, tween: Tween<double>(begin: 1.0, end: 1.6))
        ..addScene(
          begin: duration * 2,
          duration: duration * 2,
          curve: _curve,
        ).animate(AniProps.positionHeight,
            tween: Tween<double>(begin: distance, end: -distance))
        ..addScene(
          begin: duration * 3,
          duration: duration,
          curve: Curves.easeOutCirc,
        )
            .animate(AniProps.color,
                tween: ColorTween(begin: color3, end: color1))
            .animate(AniProps.scale,
                tween: Tween<double>(begin: 1.6, end: 1.0));

  TimelineTween<AniProps> createReverseTween({
    double distance = 50,
    required Color color1,
    required Color color2,
    required Color color3,
    Duration duration = const Duration(milliseconds: 600),
  }) =>
      TimelineTween<AniProps>()
        ..addScene(
          begin: Duration.zero,
          duration: duration,
          curve: Curves.easeInCirc,
        )
            .animate(AniProps.color,
                tween: ColorTween(begin: color1, end: color3))
            .animate(AniProps.scale, tween: Tween<double>(begin: 1.0, end: 1.6))
        ..addScene(
          begin: Duration.zero,
          duration: duration * 2,
          curve: _curve,
        ).animate(AniProps.positionHeight,
            tween: Tween<double>(begin: distance, end: -distance))
        ..addScene(
          begin: duration,
          duration: duration,
          curve: Curves.easeOutCirc,
        )
            // .animate(AniProps.positionHeight,
            //     tween: Tween<double>(begin: 0.0, end: -distance))
            .animate(AniProps.color,
                tween: ColorTween(begin: color3, end: color1))
            .animate(AniProps.scale, tween: Tween<double>(begin: 1.6, end: 1.0))
        ..addScene(
          begin: duration * 2,
          duration: duration,
          curve: Curves.easeInCirc,
        )
            .animate(AniProps.scale, tween: Tween<double>(begin: 1.0, end: 0.3))
            .animate(AniProps.color,
                tween: ColorTween(begin: color1, end: color2))
        ..addScene(begin: duration * 2, duration: duration * 2, curve: _curve)
            .animate(AniProps.positionHeight,
                tween: Tween<double>(begin: -distance, end: distance))
        ..addScene(
          begin: duration * 3,
          duration: duration,
          curve: Curves.easeOutCirc,
        )
            // .animate(AniProps.positionHeight,
            //     tween: Tween<double>(begin: 0.0, end: distance))
            .animate(AniProps.color,
                tween: ColorTween(begin: color2, end: color1))
            .animate(AniProps.scale, tween: Tween<double>(begin: 0.3, end: 1.0))
      //Comeback
      ;

  @override
  void initState() {
    for (int i = 0; i < 12; i++) {
      tweens.add(createTween(
        distance: 30,
        color1: const Color(0xFFFEC8AA).withOpacity(0.9),
        color2: const Color(0xFFFEC8AA).withOpacity(0.000),
        color3: const Color(0xFFF5A7CB),
      ));
      controls.add(CustomAnimationControl.stop);
      reverseTweens.add(createReverseTween(
        distance: 30,
        color1: const Color(0xffFD5E7C).withOpacity(0.9),
        color2: const Color(0xffFD5E7C).withOpacity(0.000),
        color3: const Color(0xffFC5B92),
      ));
      reverseTweensControls.add(CustomAnimationControl.stop);
    }
    SchedulerBinding.instance!
        .addPostFrameCallback((timeStamp) => playWithShift());
    //size = Tween<double>(begin: 0.0, end: 100.0).animate(controller);
    //enableDeveloperMode(controller); // enable developer mode
    controller.forward();
    super.initState();
  }

  Future<void> playWithShift() async {
    for (int i = 0; i < controls.length; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      controls[i] = CustomAnimationControl.loop;
      reverseTweensControls[i] = CustomAnimationControl.loop;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < tweens.length; i++) ...[
          Stack(
            children: [
              CustomAnimation<TimelineValue<AniProps>>(
                developerMode: false,
                control: reverseTweensControls[i],
                tween: reverseTweens[i],
                // provide tween
                duration: reverseTweens[i].duration,
                // total duration obtained from TimelineTween
                builder: (context, child, value) {
                  return Transform.translate(
                    offset: Offset(0, value.get(AniProps.positionHeight)),
                    // use animated value for x-coordinate
                    child: Transform.scale(
                      scale: value.get(AniProps.scale),
                      child: Container(
                        decoration: BoxDecoration(
                          color: value.get(AniProps.color),
                          shape: BoxShape.circle,
                        ),
                        width: 12,
                        height: 12,
                      ),
                    ),
                  );
                },
              ),
              CustomAnimation<TimelineValue<AniProps>>(
                developerMode: false,
                control: controls[i],
                tween: tweens[i],
                // provide tween
                duration: tweens[i].duration,
                // total duration obtained from TimelineTween
                builder: (context, child, value) {
                  return Transform.translate(
                    offset: Offset(0, value.get(AniProps.positionHeight)),
                    // use animated value for x-coordinate
                    child: Transform.scale(
                      scale: value.get(AniProps.scale),
                      child: Container(
                        decoration: BoxDecoration(
                          color: value.get(AniProps.color),
                          shape: BoxShape.circle,
                        ),
                        width: 12, // get animated width value
                        height: 12, // get animated height value
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(width: 10),
        ]
      ],
    );
  }
}
