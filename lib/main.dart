import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SnakePage(),
    );
  }
}

class SnakePage extends StatefulWidget {
  @override
  _SnakePageState createState() => _SnakePageState();
}

class _SnakePageState extends State<SnakePage> {
  List snakePosition = [];
  static var randomNumber = Random();
  int food = randomNumber.nextInt(700);

  void startGame() {
    snakePosition = [45, 65, 85, 105];
    const duration = const Duration(milliseconds: 300);
    Timer.periodic(duration, (Timer timer) {
      updateSnake();
      if (gameOver()) {
        timer.cancel();
        _showGameOverScreen();
      }
    });
  }

  var direction = "down";
  void updateSnake() {
    setState(() {
      switch (direction) {
        case "up":
          {
            if (snakePosition.last < 20) {
              snakePosition.add(snakePosition.last - 20 + 600);
            } else {
              snakePosition.add(snakePosition.last - 20);
            }
          }

          break;
        case "down":
          {
            if (snakePosition.last > 580) {
              snakePosition.add(snakePosition.last + 20 - 600);
            } else {
              // print("position ${snakePosition.last}");

              snakePosition.add(snakePosition.last + 20);
            }
          }
          break;
        case "right":
          {
            if ((snakePosition.last + 1) % 20 == 0) {
              snakePosition.add(snakePosition.last + 1 - 20);
            } else {
              snakePosition.add(snakePosition.last + 1);
            }
          }
          break;
        case "left":
          {
            if (snakePosition.last % 20 == 0) {
              snakePosition.add(snakePosition.last - 1 + 20);
            } else {
              snakePosition.add(snakePosition.last - 1);
            }
          }
          break;

        default:
      }
      if (snakePosition.last == food) {
        generateNewFood();
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  _showGameOverScreen() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Game Over"),
            content: Text("You're score : " + snakePosition.length.toString()),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    startGame();
                    Navigator.of(context).pop();
                  },
                  child: Text("Play Again"))
            ],
          );
        });
  }

  bool gameOver() {
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          count++;
        }
        if (count == 2) {
          return true;
        }
      }
    }
    return false;
  }

  generateNewFood() {
    food = randomNumber.nextInt(700);
  }

  @override
  Widget build(BuildContext context) {
    int numberOfSquares = 600;
    return Scaffold(
      appBar: AppBar(
        title: Text("Hungry SNAKE"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
              child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    print(" details value ${details.delta.dy}");
                    if (direction != "up" && details.delta.dy > 0) {
                      direction = "down";
                      print(direction);
                    }
                    if (direction != "down" && details.delta.dy < 0) {
                      direction = "up";
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (direction != "left" && details.delta.dx > 0) {
                      direction = "right";
                    }
                    if (direction != 'right' && details.delta.dx < 0) {
                      direction = "left";
                    }
                  },
                  child: Container(
                      child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: numberOfSquares,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 20),
                          itemBuilder: (context, index) {
                            if (snakePosition.contains(index)) {
                              return Center(
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }
                            if (index == food) {
                              return Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                padding: EdgeInsets.all(2),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    color: Colors.grey[800],
                                  ),
                                ),
                              );
                            }
                          })))),
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white)),
            child: Center(
              child: GestureDetector(
                onTap: startGame,
                child: Text(
                  "s t a r t ",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
