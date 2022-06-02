import 'package:flutter/material.dart';
import 'movableObject.dart';

class Basket extends StatelessWidget with Movable //Class that handles the player's basket
{
  Basket//constructor (all fields inherited from the Movable() class)
  ({Key? key,
    //position
    required double x,
    required double y,
    //Size
    required double width,
    required double height,
    //Velocity in the X direction (for moving)
    velocityX=0.0
  }) : super(key: key) {
    this.x=x;
    this.y=y;
    this.width=width;
    this.height=height;
    this.velocityX=velocityX;
  }

  @override
  Widget build(BuildContext context)
  {
    return Container(//Very simple, just a container with an image decoration
      alignment: Alignment(x,y),
      child: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("Basket.png"),
            fit: BoxFit.fill
          )
        ),
      ),
    );
  }
}