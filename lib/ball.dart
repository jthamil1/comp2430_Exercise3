import 'package:flutter/material.dart';
import 'movableObject.dart';

class Ball extends StatelessWidget with Movable //The ball that bounces around
{
   Ball({Key? key, //Constructor. All fields are from the Movable class
     required double x,
     required double y,
     required double width,
     required double height,
     velocityX = 0.0,
     velocityY=0.0,
   }) : super(key: key) {
     this.x=x;
     this.y=y;
     this.width=width;
     this.height=height;
     this.velocityX=velocityX;
     this.velocityY=velocityY;

   }

  @override
  Widget build(BuildContext context)
  {
    return Container(//Displays the actual ball. I've opted for a small image I made for an assignment in a previous course
      alignment: Alignment(x,y),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('Ball.png'),
              fit: BoxFit.fill)
        ),
        width: width,
        height: height,
      ),
    );
  }
}
