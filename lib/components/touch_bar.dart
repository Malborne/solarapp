import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:solar/components/tappedContainer.dart';

class TouchBar extends StatefulWidget {
  final Color color;
  final int count;
  final List<GlobalKey> keys;
  final List<String> names;
  final double screenWidth;
  final void Function(int index) stateChanged;
  const TouchBar({super.key, required this.color,required this.count,required this.keys,required this.names,required this.screenWidth,required this.stateChanged});

  @override
  State<TouchBar> createState() => _TouchBarState();
}

class _TouchBarState extends State<TouchBar> {
  double _width = 50;
  String _text = 'Day';
  bool _showText = true;
  int animationDuration = 3;
  int lastPosition = 0;
  final double _height = 33;

  // double _xTranslate =  -150.32;
  late double _xTranslate;

  Color _color = Colors.black;
  bool shouldScaleDown = true; // change value when needed
  final BorderRadiusGeometry _borderRadius = BorderRadius.circular(25);

  @override
  void initState() {
    super.initState();
    // _xTranslate = 0;
    _xTranslate = -(widget.screenWidth / 2 - 48);
  }

  @override
  Widget build(BuildContext context) {
    // print('widget rebuilt with index: $lastPosition');
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // print('Post callback');
      try {
        RenderBox box = widget.keys[lastPosition].currentContext!
            .findRenderObject() as RenderBox;
        Offset position =
            box.localToGlobal(Offset.zero); //this is global position
        setState(() {
          double x = position.dx;
          _width = box.size.width;
          double scrWidth = MediaQuery.of(context).size.width;
          double translation = x - scrWidth / 2 + _width / 2;
          // print('translation: $translation');
          animationDuration = 1; //To move instantly without animation
          // _color = Colors.transparent;
          _xTranslate = translation;
        });
      } on TypeError catch (e) {
        // Do nothing
      }
    });
    // print('width: ${-(widget.screenWidth/2-widget.count*7)}');
    return Material(
      elevation: 1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      color: Colors.transparent,
      child: Container(
        width: 0.95 * MediaQuery.of(context).size.width,
        height: 45,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(25),
          // side: const BorderSide(color: Colors.red),
        ),
        child: Stack(
            children: [

              Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(widget.count,(index){
                      return TappedContainer(
                          key: widget.keys[index],
                          // width: 45,
                          child: Center(child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(widget.names[index]),
                          )),
                          onTapDown: (details){
                            RenderBox box = widget.keys[index].currentContext!.findRenderObject() as RenderBox;
                            Offset position = box.localToGlobal(Offset.zero); //this is global position
                            double x = position.dx;

                        widget.stateChanged(index);
                            setState(() {
                              lastPosition = index;
                          _showText = false;
                          _text = widget.names[index];
                          _color = Colors.black.withOpacity(0.5);
                          _width = box.size.width;
                          double scrWidth = MediaQuery.of(context).size.width;
                          double translation = x - scrWidth / 2 + _width / 2;
                          // print('translation: $translation');
                          animationDuration = 500;
                          _xTranslate = translation;
                        });
                          });
                    } )

                ),
              ),
              Center(
                child: AnimatedContainer(
                  // Use the properties stored in the State class.
                  transform: (shouldScaleDown
                  ? Matrix4.translationValues(_xTranslate, 0, 0.0)
                  : Matrix4.identity()),
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                color: _color, //to hide it in the beginning
                borderRadius: _borderRadius,
              ),
              // Define how long the animation should take.
              duration: Duration(milliseconds: animationDuration),
              // Provide an optional curve to make the animation feel smoother.
              curve: Curves.fastOutSlowIn,
              onEnd: () {
                setState(() {
                  _showText = true;
                  _color = Colors.black;
                  animationDuration = 500;
                });
              },
              child: Center(
                  child: Text(
                _showText ? _text : '',
                style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),)),
                ),
              ),
            ]

        ),
      ),
    );
  }
}
