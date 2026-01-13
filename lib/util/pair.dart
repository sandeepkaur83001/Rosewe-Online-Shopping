class Pair<T, U> {
  final T? first;
  final U? second;

  Pair(this.first, this.second);
}

class ResposePair<T, U, V> {
  final T? status;
  final U? message;
  final V? body;

  ResposePair(this.status, this.message, this.body);
}
