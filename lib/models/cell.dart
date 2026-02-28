class Cell {
  int value; // 0 = empty
  bool given;
  final Set<int> notes = {};

  Cell({this.value = 0, this.given = false});

  bool get isEmpty => value == 0;
}
