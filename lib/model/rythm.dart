typedef Rythm = (int, int);

extension RythmX on Rythm {
  int get workMinutes => $1;
  int get restMinutes => $2;
}
