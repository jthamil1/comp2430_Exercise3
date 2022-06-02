import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:ball_catch/heartIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ball.dart';
import 'basket.dart';
import 'pauseButton.dart';
import 'pauseScreen.dart';
import 'scoreTxt.dart';

class HomePage extends StatefulWidget
{
  const HomePage({Key? key}) : super(key: key);
  //Creates the state for the homepage (see below)
  @override
  _HomePageState createState() => _HomePageState();
  Widget build(BuildContext context)
  {
    return Container(
    );
  }
}

class _HomePageState extends State<HomePage>
{
  //State variables
  final screenHeight = window.physicalSize.height/window.devicePixelRatio; //Used mostly to shorten the code in certain areas
  final screenWidth = window.physicalSize.width/window.devicePixelRatio;
  final maxInitialVelocity = 0.0035;//A constraint for the initial speed of the ball
  final maxVelocity = 0.0055; //A limit for how fast the ball can go due to gravity
  double playTime = 0.0; //Keeps track of (roughly) how long the player has been playing
  int countdownNum = 3;//Used for the countdown timer that triggers when the game is unpaused
  bool gameOver=false; //A flag for when the player runs out of lives
  bool gameStarted = false; //Checks if the game has started yet (mostly used for pausing)
  bool gamePaused = true; //Checks if the game is paused. used for controlling game loop
  int score=0;//variable to keep track of the score
  int lives =5; //How many lives the player has
  int maxBalls=1; //Max number of balls allowed on the screen at one time
  final gravity = 0.000015;//A constant to represent the downward acceleration for the balls

  var player = Basket(//Player object
      x:0.0,
      y:0.85,
      width: window.physicalSize.width/window.devicePixelRatio/4,
      height: window.physicalSize.height/window.devicePixelRatio/25);
  List<Ball> balls=[];//An array to hold all of the ball objects

  //Functions that handle game states

  void gameStart() {//Used to start the game
    if(gameStarted==false) {//This if statement is here just in case, prevents things from restarting accidentally if I messed up somewhere
      setState(() {//Sets some initial variables
        gameStarted = true;//Marks the game as started
        makeBall();
      });
      //This is the timer that controls most of the game functions.
      //Ticks at least once every ms
      Timer.periodic(const Duration(milliseconds: 1), (mainTimer) {
        if (gamePaused == false) {//Only runs functions when the game isn't paused
            setState((){
              playTime++; //Keeps track of how long the player has been playing (useful for adding more balls)
              if(playTime%2500==0)
              {
                maxBalls++; //The timer isn't perfect, so I've chosen an arbitrary amount of time to wait before adding another ball (roughly every 20 seconds in testing)
              }
            });
            if(lives<=0){//If the player is out of lives
              setState((){
                mainTimer.cancel();//stops this timer
                gameOver=true; //Sets the gameplay flags for end of game
                gamePaused=true;
                gameStarted = false;
              });
            }
            if(balls.length <maxBalls){//If there can be another ball on the screen, creates the ball
              makeBall();
            }
            collisionCheck();//Check for collisions
            moveObjects(); //Calls all of the object moving functions

        }
      });
      countdown();//Calls the countdown function to give you a chance to prepare
    }
  }
  void resetGame(){
    setState((){
      player.x= 0.0;
      score=0;
      playTime=0.0;
      maxBalls=1;
      balls.clear();
      gameOver=false;
      lives=5;
    });
    gameStart();
  }
  void countdown(){
    setState((){//Initial value for the countdown to 3
      countdownNum=3;
    });

    Timer.periodic(const Duration(seconds: 1), (countdownTimer)//Timer that ticks once per second
    {
      setState((){
        countdownNum--;//Decrements the counter by 1
      });
      if(countdownNum<=0)//If the counter reaches 0
      {
        setState((){
          countdownTimer.cancel();//Cancels this timer
          gamePaused=false;//unpauses the game
        });
      }
    });
  }
  void pauseGame() {
    if(gamePaused==false) {//If the game isn't paused already
      setState(() {
        gamePaused = true;//marks the game as being paused
      });
    }
    else{
      countdown();//If the game is already paused, initiates the countdown proccess
    }
  }

  void makeBall(){
    var newBall = Ball(x:0.0,y:-0.6,width: 20.0,height: 20.0); //Creates a ball to be added to the array
    //You cant use instance members in constructors in dart, so I will be re-assigning the x & y values here
    newBall.x= (Random().nextInt(100)-50)/100; //Ball should appear in the middle 50% of the screen horizontally
    newBall.y = (Random().nextInt(30)-80)/100; //Ball should appear near the top of the screen
    var velocities = initialVelocity();//Calculates the balls initial x & y velocities based on a randomly generated angle
    newBall.velocityX = velocities[0];
    newBall.velocityY = velocities[1];
    setState((){
      balls.add(newBall);//Adds the newly created ball to the list
    });


  }
  void moveObjects(){//Used for moving the objects
    setState((){
      player.move();//Moves the player (only moves in the X dimension)
      for(int i = 0;i<balls.length;i++){//Loops through all of the balls on the screen
        balls[i].move();//Moves the ball
        if(balls[i].velocityY<maxVelocity){//Decreases the ball's y velocity as long as it hasn't hit its max (terminal) velocity
          balls[i].velocityY += gravity;
        }
      }
    });

  }

  List<double> initialVelocity(){//Calculates the initial velocity of the ball
    int angle=0;
    //I want the ball to not be able to travel straight down, hence restricting the angle it can travel at
    //When there's only one ball at a time, the ball can initially leave at a more downward angle
    if(maxBalls ==1) {
       angle = Random().nextInt(270) + 45;
    }
    //At 2 balls, they cannot be sent at a downward angle at all (highest they can go is horizontally)
    else if(maxBalls ==2){
      angle = Random().nextInt(180) + 90;
    }
    //At 3 balls and up, they are guaranteed to travel at an upward angle initially, to give the player more time to react
    else{
      angle = Random().nextInt(120) + 120;
    }
    //Uses trigonometry to calculate the x&y velocities based on the initial random angle
    return [maxInitialVelocity*sin(angle*pi/180),maxInitialVelocity* cos(angle*pi/180)];
  }

  //Functions that handle collision
  void collisionCheck(){//This function only contains the if/else statements for detecting collisions. There's a separate function below that handles what to do with the ball (or paddles) when the collision occurs
    //Loop through all balls on screen
    if(balls.isNotEmpty) {
      for (int i = 0; i < balls.length; i++) {
        //Ball collides with player's basket
        if ((balls[i].getLeft() <= player.getRight()+0.001 &&
            balls[i].getRight() >= player.getLeft()-0.001) &&
            ((balls[i].getBottom() >= player.getTop()) &&
                (balls[i].getTop() <= player.getBottom()+0.001))) {
          collisionHandler(collider: 'player', ballID: i);
        }

        //Left wall
        else if (balls[i].getLeft() <= -1) {
          if (balls[i].velocityX < 0) {
            collisionHandler(collider: 'wall', ballID: i);
          }
        }
        //Right wall
        else if (balls[i].getRight() >= 1) {
          if (balls[i].velocityX > 0) {
            collisionHandler(collider: 'wall', ballID: i);
          }
        }
        //Bottom of screen (lost a life)
        else if (balls[i].getBottom() >= 1) {
          collisionHandler(collider: 'escape', ballID: i);
        }
      }
    }
    //========END OF BALL COLLISIONS=========
    //
    //=======PADDLE & WALL COLLISIONS========

    if(((player.getLeft()<=-1)&&(player.velocityX<0))||((player.getRight()>=1)&&(player.velocityX>0))){
      collisionHandler(collider: 'playerAndWall',ballID: -1);
    }
    //====END OF PADDLE & WALL COLLISIONS====
  }
  void collisionHandler({required String collider,required int ballID}) {
    //This function handles the collisions. The type of collision is passed as a string, as well as the index of the ball that has collided with something
    //If the collision is between the player and a wall, ballID is passed as -1 (it's not used either)
    switch (collider) {
      case "player":{//Ball collides with basket
        setState((){
          score++;//Increments the score
          balls.removeAt(ballID);//Removes the ball from the array. The object should be released from memory by the garbage collector
        });
        break;
      }
      case "wall":{//Reverses the X direction of the ball
        setState((){
          balls[ballID].velocityX = -balls[ballID].velocityX;
        });

        break;
      }
      case "escape":{ //Ball reached the bottom of the screen
        setState((){
          lives--; //Decrements the player's life total
          balls.removeAt(ballID);//Removes the ball from the array
        });
        break;
      }
      case "playerAndWall":{//Stops the player's paddle from moving through the walls
        setState((){
          player.velocityX=0.0;
        });
        break;}

      default://This should never execute
        break;
    }
  }


  //The actual building of the screen/widgets
  @override
  Widget build(BuildContext context){
    return RawKeyboardListener(//This section allows the app to be played/tested on the computer
      focusNode: FocusNode(),
      autofocus: false,
      onKey: (event)
      {
        if(event is RawKeyDownEvent){
          if(event.isKeyPressed(LogicalKeyboardKey.arrowRight)){//Right arrow moves the basket right
            setState((){
              player.velocityX=0.008;
            });
          }
          else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)){//Left arrow moves the basket left
            setState((){
              player.velocityX=-0.008;
            });
          }
          else if (event.isKeyPressed(LogicalKeyboardKey.space))//space pauses the game
          {
            pauseGame();
          }
        }
        else if(event is RawKeyUpEvent){//This is to catch if the arrow is released, to stop the paddle from moving constantly
          if(event.logicalKey.keyLabel=='Arrow Left'||event.logicalKey.keyLabel=='Arrow Right'){
            setState((){
              player.velocityX=0;
            });
          }
        }
      },
      child: GestureDetector(//Next, the gesturedetector allows for touchscreen control of the basket
        onHorizontalDragUpdate: (details)
        {
          if(details.delta.dx>0) {//Right
            player.velocityX=0.008;
          }
          else {//swiping left
            setState((){
              player.velocityX=-0.008;
            });
          }
        },
        onHorizontalDragEnd:(details)//Stops basket from moving when the player stops dragging
        {
          setState((){
            player.velocityX=0;
          });
        },
        child: Scaffold(//Main layout for visible widgets
          backgroundColor: Colors.grey[900],//BG colour
          body: Center(//Centers the children within the screen
            child: Stack(//A stack of widgets for easier handling
              children:[
                Container(//This widget displays the background image
                  width: screenWidth,
                  height: screenHeight,
                  decoration: const BoxDecoration(
                       image: DecorationImage(
                        image: AssetImage("Background.png"),
                        fit: BoxFit.fill,
                        ),
                  )
                ),
                PauseButton(x: -0.95, y: -0.99, buttonPressed: (temp)//Creates a pause button
                  { if(countdownNum<=0&&gamePaused==false){//Stops the game from being paused when the countdown is taking place, also when the game is already paused
                     pauseGame();
                  }
                }),
                player.build(context),
                for(int i =0;i<balls.length;i++)//Loops through all active balls
                  balls[i].build(context),//shows the balls

                for (int i =0; i<lives; i++)
                  HeartIcon(x: 0.95-((38/screenWidth)*i), y: -0.9, width: 32, height: 32),
                ScoreTxt(txt: "Score: $score",x:0,y:-0.8),
                if(countdownNum>0)//Only displays the countdown text if it is actively counting down
                  ScoreTxt(txt: '$countdownNum',x:0,y:0),
                if(gamePaused==true)//Handles the pause screen. There are 4 different types of text to be displayed on this screen, hence 4 different conditions
                  if(gameStarted==false&&!gameOver)PauseScreen(gameState: 0,closePlease:(temp){gameStart();})//Game hasn't been started (initial screen)
                  else if (gameOver==true)PauseScreen(gameState: 2, closePlease: (temp){resetGame();},score: score) //Gameover screen
                  else if(countdownNum<=0)PauseScreen(gameState: 1,closePlease:(temp){pauseGame();})//Generic pausing
                ],
            ),
          ),
        ),
      ),
    );
  }
}