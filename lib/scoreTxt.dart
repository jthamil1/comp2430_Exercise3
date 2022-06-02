import 'package:flutter/material.dart';

class ScoreTxt extends StatelessWidget {//Used for displaying text (not just scores, also the countdown timer)
  final String txt;//Text to be displayed
  final double x;//Positions
  final double y;
  const ScoreTxt({//Constructor
    required this.txt,
    required this.x,
    required this.y,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Container(//Used for displaying the widget
      alignment:  Alignment(x,y),
      child: Text(
            txt,
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              fontSize: 34,
              color: Colors.black
            ),
        ),
    );
  }
}
