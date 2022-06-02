import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/services.dart';

class PauseScreen extends StatelessWidget //This class manages the overlay that happens when the game is paused
{
  final ValueChanged<bool> closePlease; //callback function to tell the homepage to stop drawing this screen. Asking politely is imperative to its functions
  final int score;
  final int gameState; /*Used to determine what message(s) to display:
  0: Game hasn't started (newGame message)
  1: Game is in progress, and just paused
  2: Message that displays when you've lost the game
  */
  //These strings are used in the widget build section (holds the strings to actually display)
  String mainString ='';
  String smallString='';

  //These strings are the possible messages to display
  final String newGame = 'Welcome to Ball Catch! Try to stop as many of the balls from reaching the bottom as you can! Once you lose your 3 lives, it\'s game over!';
  final String gameOver = 'Game Over! \nYour Score: ';
  final String playAgain = 'Play again? (tap anywhere to continue)';
  final String tapToContinue = 'Tap anywhere to continue (Or press Space)';
  final String isPaused = 'P A U S E D';

  PauseScreen({Key? key, required this.gameState,required this.closePlease, this.score=0}) : super(key: key){//Constructor
    switch(gameState)//Switch statement to determine which strings to display
    {
      case (0):{//New game
        mainString= newGame;
        smallString = tapToContinue;
        break;}
      case (1):{//Game Paused
        mainString= isPaused;
        smallString = tapToContinue;
        break;}
      case (2):{//Game over
        mainString= '$gameOver$score';
        smallString = playAgain;
        break;}
      default:{//Shouldn't happen
        mainString= "Hmm, something's wrong";
        smallString = 'Oh well, tap to continue';
        break;}
    }
  }


  @override
  Widget build(BuildContext context)
  {
    return RawKeyboardListener(//Used to detect the 'space' key, which should unpause the game
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event){
      if(event.isKeyPressed(LogicalKeyboardKey.space)){
        closePlease(true);//Should tell the homepage to close this menu
        }
      },
      child: GestureDetector(//Used to detect a tap, which should also close the menu
          onTap: (){closePlease(true);},
      child: Container(
        alignment: const Alignment(0,0),
        //All of the below is just to display the text
        child: Container(
            color: Colors.grey[400],
            height: window.physicalSize.height*.75/(window.devicePixelRatio),
            width: window.physicalSize.width*.75/(window.devicePixelRatio),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[Text(
                    mainString,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black
                  )
              ),
                  const SizedBox(height: 10),//Just here to space things out
                  Text(
                    smallString,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[900]
                        )
                      ),
                  ]
              ),
          ),
        )
      )
    )
    );
  }
}