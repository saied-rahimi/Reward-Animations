import 'package:flutter/material.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage>
    with TickerProviderStateMixin {
  int iconsLength = 10;
  final List<Animation<Offset>> _moveAroundAnimations = [];
  final List<AnimationController> _moveAroundControllers = [];
  final List<Animation<Offset>> _moveUpAnimations = [];
  final List<AnimationController> _moveUpControllers = [];
  //animation angles
  final List<double> firstAngleX = [-2, 1, 1.6, -1, 0.5, -0.5, 0, 1.5, 2.3, -2];
  final List<double> firstAngleY = [1, -2, 1, -1.5, -0.1, -0.1, 1, 0, 0, 1.5];
  final List<double> secondAngleX = [
    8.8,
    5.8,
    5.3,
    7.8,
    6.4,
    7.3,
    6.8,
    5.2,
    4.4,
    9
  ];
  final List<double> secondAngleY = [
    15.8,
    12.8,
    15.8,
    13.3,
    14.8,
    14.6,
    15.8,
    14.8,
    14.8,
    16.4
  ];
  @override
  void initState() {
    super.initState();
    //generating controller for move around animations
    List.generate(
      iconsLength,
      (index) => _moveAroundControllers.add(
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 500),
        ),
      ),
    );
    //generating controller for move around controllers
    List.generate(
      iconsLength,
      (index) => _moveAroundAnimations.add(
        Tween<Offset>(
          begin: const Offset(0, 0),
          end: Offset(firstAngleX[index], firstAngleY[index]),
        ).animate(
          CurvedAnimation(
            parent: _moveAroundControllers[index],
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
//generating controller for move up controllers
    List.generate(
      iconsLength,
      (index) => _moveUpControllers.add(
        AnimationController(
          vsync: this,
          duration:
              const Duration(milliseconds: 500), // Adjust duration as needed
        ),
      ),
    );
    //generating controller for move around animations
    List.generate(
      iconsLength,
      (index) => _moveUpAnimations.add(
        Tween<Offset>(
          begin: const Offset(0, 0), // Start from the left
          end: Offset(
              secondAngleX[index], -secondAngleY[index]), // Move to the top
        ).animate(
          CurvedAnimation(
            parent: _moveUpControllers[index],
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    //dispose controllers
    for (int i = 0; i > iconsLength; i++) {
      _moveAroundControllers[i].dispose();
      _moveUpControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text("animated Reward"), actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Icon(Icons.attach_money),
            ),
          ]),
          body: Center(
              child: ElevatedButton(
                  onPressed: () {
                    for (int i = 0; i < iconsLength; i++) {
                      _moveAroundControllers[i].addStatusListener((status) {
                        if (status == AnimationStatus.completed) {
                          // When animation to the left completes, start animation to the top
                          _moveUpControllers[i].forward();
                        }
                      });
                      _moveAroundControllers[i].forward();
                    }

                    // Start the animation to the left
                    // _controllerToLeft.forward();
                  },
                  child: const Text("Animate"))),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              for (int i = 0; i < iconsLength; i++) {
                _moveAroundControllers[i].reset();
                _moveUpControllers[i].reset();
              }
            },
            child: const Icon(Icons.restart_alt_outlined),
          ),
        ),
        Center(
          child: Stack(
              children: List.generate(
            iconsLength,
            (index) => Center(
              child: SlideTransition(
                position: _moveAroundAnimations[index],
                child: SlideTransition(
                    position: _moveUpAnimations[index],
                    child: const Icon(Icons.attach_money)),
              ),
            ),
          )),
        ),
      ],
    );
  }
}
