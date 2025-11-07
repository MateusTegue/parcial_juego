import 'dart:math';

class Food {
  late int x;
  late int y;

  Food(int gridWidth, int gridHeight) {
    generateNewPosition(gridWidth, gridHeight);
  }

  void generateNewPosition(int gridWidth, int gridHeight) {
    final random = Random();
    x = random.nextInt(gridWidth);
    y = random.nextInt(gridHeight);
  }

  List<int> get position => [x, y];
}
