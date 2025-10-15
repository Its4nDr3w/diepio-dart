class LevelSystem {
  int level;
  double exp;
  double expToNext;

  LevelSystem({this.level = 1, this.exp = 0, this.expToNext = 1000});

  void addExp(double amount) {
    exp += amount;
    while (exp >= expToNext) {
      exp -= expToNext;
      level++;
      expToNext = 500.0 * level;
    }
  }
}
