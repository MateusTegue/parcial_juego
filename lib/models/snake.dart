import 'direction.dart';

class Snake {
  List<List<int>> body;
  Direction currentDirection;

  Snake()
    : body = [
        [10, 15],
        [10, 16],
        [10, 17],
      ],
      currentDirection = Direction.up;

  void move() {
    List<int> newHead = [...body.first];

    switch (currentDirection) {
      case Direction.up:
        newHead[1] -= 1;
        break;
      case Direction.down:
        newHead[1] += 1;
        break;
      case Direction.left:
        newHead[0] -= 1;
        break;
      case Direction.right:
        newHead[0] += 1;
        break;
    }

    body.insert(0, newHead);
    body.removeLast();
  }

  void grow() {
    List<int> newHead = [...body.first];

    switch (currentDirection) {
      case Direction.up:
        newHead[1] -= 1;
        break;
      case Direction.down:
        newHead[1] += 1;
        break;
      case Direction.left:
        newHead[0] -= 1;
        break;
      case Direction.right:
        newHead[0] += 1;
        break;
    }

    body.insert(0, newHead);
  }

  bool checkCollisionWithWall(int gridWidth, int gridHeight) {
    List<int> head = body.first;
    return head[0] < 0 ||
        head[0] >= gridWidth ||
        head[1] < 0 ||
        head[1] >= gridHeight;
  }

  bool checkCollisionWithSelf() {
    List<int> head = body.first;
    for (int i = 1; i < body.length; i++) {
      if (body[i][0] == head[0] && body[i][1] == head[1]) {
        return true;
      }
    }
    return false;
  }

  void changeDirection(Direction newDirection) {
    // Evitar que la serpiente vaya en dirección opuesta
    if ((currentDirection == Direction.up && newDirection == Direction.down) ||
        (currentDirection == Direction.down && newDirection == Direction.up) ||
        (currentDirection == Direction.left &&
            newDirection == Direction.right) ||
        (currentDirection == Direction.right &&
            newDirection == Direction.left)) {
      return;
    }
    currentDirection = newDirection;
  }
}
