import 'package:flutter/material.dart';

class HeartIcon extends StatelessWidget //The Icons that represent the number of lives
{
  final double x;
  final double y;
  final double height;
  final double width;
  const HeartIcon({Key? key, //Constructor.
    required this.x,
    required this.y,
    required this.width,
    required this.height,

  }) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Container(//Displays the heart icons
      alignment: Alignment(x,y),
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('Heart.png'),
                fit: BoxFit.fill)
        ),
        width: width,
        height: height,
      ),
    );
  }
}
