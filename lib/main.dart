// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'controllers/game_controller.dart';
// import 'widgets/game_board.dart';
// import 'models/direction.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => GameController(),
//       child: MaterialApp(
//         title: 'Snake Game',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: Colors.green,
//           brightness: Brightness.dark,
//         ),
//         home: GameScreen(),
//       ),
//     );
//   }
// }

// class GameScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Consumer<GameController>(
//           builder: (context, gameController, child) {
//             return Column(
//               children: [
//                 // Encabezado con puntuación
//                 Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Snake Game',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green,
//                         ),
//                       ),
//                       Text(
//                         'Score: ${gameController.score}',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Tablero de juego
//                 Expanded(
//                   child: Center(
//                     child: AspectRatio(
//                       aspectRatio: 1,
//                       child: Stack(
//                         children: [
//                           GameBoard(),
//                           if (gameController.isGameOver)
//                             Container(
//                               color: Colors.black54,
//                               child: Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       'Game Over!',
//                                       style: TextStyle(
//                                         fontSize: 48,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.red,
//                                       ),
//                                     ),
//                                     SizedBox(height: 20),
//                                     Text(
//                                       'Score: ${gameController.score}',
//                                       style: TextStyle(
//                                         fontSize: 24,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     SizedBox(height: 30),
//                                     ElevatedButton(
//                                       onPressed: () {
//                                         gameController.startGame();
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.green,
//                                         padding: EdgeInsets.symmetric(
//                                           horizontal: 40,
//                                           vertical: 15,
//                                         ),
//                                       ),
//                                       child: Text(
//                                         'Play Again',
//                                         style: TextStyle(fontSize: 20),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           if (!gameController.isPlaying &&
//                               !gameController.isGameOver)
//                             Container(
//                               color: Colors.black54,
//                               child: Center(
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     gameController.startGame();
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.green,
//                                     padding: EdgeInsets.symmetric(
//                                       horizontal: 40,
//                                       vertical: 15,
//                                     ),
//                                   ),
//                                   child: Text(
//                                     'Start Game',
//                                     style: TextStyle(fontSize: 20),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Controles
//                 Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       // Botón arriba
//                       IconButton(
//                         onPressed: () {
//                           gameController.changeDirection(Direction.up);
//                         },
//                         icon: Icon(Icons.arrow_drop_up),
//                         iconSize: 64,
//                         color: Colors.white,
//                       ),
//                       // Botones izquierda y derecha
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           IconButton(
//                             onPressed: () {
//                               gameController.changeDirection(Direction.left);
//                             },
//                             icon: Icon(Icons.arrow_left),
//                             iconSize: 64,
//                             color: Colors.white,
//                           ),
//                           SizedBox(width: 100),
//                           IconButton(
//                             onPressed: () {
//                               gameController.changeDirection(Direction.right);
//                             },
//                             icon: Icon(Icons.arrow_right),
//                             iconSize: 64,
//                             color: Colors.white,
//                           ),
//                         ],
//                       ),
//                       // Botón abajo
//                       IconButton(
//                         onPressed: () {
//                           gameController.changeDirection(Direction.down);
//                         },
//                         icon: Icon(Icons.arrow_drop_down),
//                         iconSize: 64,
//                         color: Colors.white,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'controllers/game_controller.dart';
import 'widgets/game_board.dart';
import 'models/direction.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ⬅️ NUEVO: Inicializar Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameController(),
      child: MaterialApp(
        title: 'Snake Game',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          brightness: Brightness.dark,
        ),
        home: GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Consumer<GameController>(
          builder: (context, gameController, child) {
            return Column(
              children: [
                // ⬅️ MODIFICADO: Encabezado con puntuación y high score
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Snake Game',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Score: ${gameController.score}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                'High: ${gameController.highScore}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.yellow[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Tablero de juego
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        children: [
                          GameBoard(),

                          // ⬅️ MODIFICADO: Game Over con indicador de récord
                          // if (gameController.isGameOver)
                          //   Container(
                          //     color: Colors.black54,
                          //     child: Center(
                          //       child: Column(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           Text(
                          //             'Game Over!',
                          //             style: TextStyle(
                          //               fontSize: 16,
                          //               fontWeight: FontWeight.bold,
                          //               color: Colors.red,
                          //             ),
                          //           ),
                          //           // ⬅️ NUEVO: Mensaje especial si es récord
                          //           if (gameController.isNewRecord)
                          //             Column(
                          //               children: [
                          //                 Icon(
                          //                   Icons.emoji_events,
                          //                   color: Colors.yellow,
                          //                   size: 64,
                          //                 ),
                          //                 SizedBox(height: 10),
                          //                 Text(
                          //                   'NEW RECORD!',
                          //                   style: TextStyle(
                          //                     fontSize: 16,
                          //                     fontWeight: FontWeight.bold,
                          //                     color: Colors.yellow,
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           Text(
                          //             'Score: ${gameController.score}',
                          //             style: TextStyle(
                          //               fontSize: 24,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //           SizedBox(height: 10),
                          //           Text(
                          //             'High Score: ${gameController.highScore}',
                          //             style: TextStyle(
                          //               fontSize: 20,
                          //               color: Colors.yellow[700],
                          //             ),
                          //           ),
                          //           SizedBox(height: 30),
                          //           ElevatedButton(
                          //             onPressed: () {
                          //               gameController.startGame();
                          //             },
                          //             style: ElevatedButton.styleFrom(
                          //               backgroundColor: Colors.green,
                          //               padding: EdgeInsets.symmetric(
                          //                 horizontal: 40,
                          //                 vertical: 15,
                          //               ),
                          //             ),
                          //             child: Text(
                          //               'Play Again',
                          //               style: TextStyle(fontSize: 20),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          if (gameController.isGameOver)
                            Container(
                              color: Colors.black87,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Game Over!',
                                      style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Score: ${gameController.score}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                    // ⬅️ NUEVO: Mostrar si es nuevo récord
                                    if (gameController.score >=
                                        gameController.highScore)
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          '🏆 NEW HIGH SCORE! 🏆',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.yellow,
                                          ),
                                        ),
                                      ),
                                    SizedBox(height: 10),
                                    Text(
                                      'High Score: ${gameController.highScore}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.yellow,
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    ElevatedButton(
                                      onPressed: () {
                                        gameController.startGame();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical: 15,
                                        ),
                                      ),
                                      child: Text(
                                        'Play Again',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (!gameController.isPlaying &&
                              !gameController.isGameOver)
                            Container(
                              color: Colors.black54,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (gameController.highScore > 0)
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 20),
                                        child: Text(
                                          'High Score: ${gameController.highScore}',
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.yellow,
                                          ),
                                        ),
                                      ),
                                    ElevatedButton(
                                      onPressed: () {
                                        gameController.startGame();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical: 15,
                                        ),
                                      ),
                                      child: Text(
                                        'Start Game',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // // Controles
                // Padding(
                //   padding: EdgeInsets.all(20),
                //   child: Column(
                //     children: [
                //       IconButton(
                //         onPressed: () {
                //           gameController.changeDirection(Direction.up);
                //         },
                //         icon: Icon(Icons.arrow_drop_up),
                //         iconSize: 64,
                //         color: Colors.white,
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           IconButton(
                //             onPressed: () {
                //               gameController.changeDirection(Direction.left);
                //             },
                //             icon: Icon(Icons.arrow_left),
                //             iconSize: 64,
                //             color: Colors.white,
                //           ),
                //           SizedBox(width: 100),
                //           IconButton(
                //             onPressed: () {
                //               gameController.changeDirection(Direction.right);
                //             },
                //             icon: Icon(Icons.arrow_right),
                //             iconSize: 64,
                //             color: Colors.white,
                //           ),
                //         ],
                //       ),
                //       IconButton(
                //         onPressed: () {
                //           gameController.changeDirection(Direction.down);
                //         },
                //         icon: Icon(Icons.arrow_drop_down),
                //         iconSize: 64,
                //         color: Colors.white,
                //       ),
                //     ],
                //   ),
                // ),

                // En la parte del encabezado
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Snake Game',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            'High Score: ${gameController.highScore}', // ⬅️ NUEVO
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.yellow,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Score: ${gameController.score}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
