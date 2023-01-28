import 'package:flutter/material.dart';
import 'semiCircle.dart';

class IndicationCircle extends StatelessWidget {
  // final VoidCallback  onPressed;
  final Color successColor;
  final Color failColor;
  final double diameter;
  final double outlineWidth;
  final double successPercentage;
  final String mainText;
  final String subText;
   const IndicationCircle({super.key,
    required this.diameter,
    required this.mainText,
    required this.subText,
    // required this.onPressed,
    required this.successColor,
    required this.failColor,
     required this.outlineWidth,
    required  this.successPercentage,
  });




  @override
  Widget build(BuildContext context) {

      return Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          SizedBox(
            width: diameter,
            height: diameter,
            child: CustomPaint(
              foregroundPainter: SemiCircle(
                // fillColor: Colors.transparent,
                fillColor: successColor.withOpacity(0.1),
                lineColor: successColor.withOpacity(0.8),
                completePercent: successPercentage,
                width: outlineWidth,
              ),
            ),
          ),
          Container(
            // shape: const CircleBorder(),
            constraints: BoxConstraints.tightFor(
              width: diameter,
              height: diameter,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    mainText,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    subText,
             style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ),
        ],
      );

  }
}
