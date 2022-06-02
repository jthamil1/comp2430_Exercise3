import 'dart:ui';

class Movable //Class to be used as a mixin, contains members & functions common to all of the movable objects
{
  //Position
  double x=0;
  double y=0;
  //Velocities
  double velocityX=0;
  double velocityY=0;
  //dimensions
  double width=0;
  double height=0;

  double normalizeDim(double num)//Used for calculating things like size (size is normally represented as a number of pixels, position represented as a fractional distance from the center of the screen)
  {
    return (num/(window.physicalSize.height/window.devicePixelRatio));
  }
  void move(){//Simple function for moving the object
    x+=velocityX;
    y+=velocityY;
  }

  //The below getters are used to calculate places on the object, which is required for handling the collisions.
  //Note: I'm not sure if it's because of the Center Widget being used to contain the other widgets on the homepage, or another reason,
  //But the x & y values for the objects change depending on where the object is on the screen
  //For example, if the paddle is touching the top of the screen, paddle.y will be -1, which would lead one to assume that paddle.y is the top of the paddle
  //However, when the paddle is touching the bottom of the screen, paddle.y will be 1 (instead of paddle.y +height =1). This was incredibly awkward to deal with,
  //but the equations below work to mitigate this and return usable numbers
  double getTop(){
    return ((1-normalizeDim(height))*y)-normalizeDim(height);
  }
  double getBottom(){
    return getTop()+(2*normalizeDim(height));
  }
  double getLeft(){
    return ((1-normalizeDim(width))*x)-normalizeDim(width);
  }
  double getRight(){
    return getLeft()+(2*normalizeDim(width));
  }
  double getMid(){
    return getTop()+(normalizeDim(height));
  }

}