import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../models/direction.dart';
import 'snake_pixel.dart';
import 'food_pixel.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(
      builder: (context, controller, child) {
        return GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.delta.dy > 0) {
              controller.changeDirection(Direction.down);
            } else if (details.delta.dy < 0) {
              controller.changeDirection(Direction.up);
            }
          },
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx > 0) {
              controller.changeDirection(Direction.right);
            } else if (details.delta.dx < 0) {
              controller.changeDirection(Direction.left);
            }
          },
          child: Container(
            color: Colors.black,
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: GameController.gridWidth * GameController.gridHeight,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: GameController.gridWidth,
              ),
              itemBuilder: (context, index) {
                int x = index % GameController.gridWidth;
                int y = index ~/ GameController.gridWidth;

                // Dibujar la serpiente
                bool isSnakeBody = false;
                bool isHead = false;
                for (int i = 0; i < controller.snake.body.length; i++) {
                  if (controller.snake.body[i][0] == x &&
                      controller.snake.body[i][1] == y) {
                    isSnakeBody = true;
                    isHead = i == 0;
                    break;
                  }
                }

                // Dibujar la comida
                bool isFood = controller.food.x == x && controller.food.y == y;

                if (isSnakeBody) {
                  return SnakePixel(isHead: isHead); // Ahora sí funcionará
                } else if (isFood) {
                  return FoodPixel();
                } else {
                  return Container(
                    margin: EdgeInsets.all(1),
                    color: Colors.grey[900],
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
