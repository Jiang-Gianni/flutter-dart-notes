import 'dart:io';

main() {
  Stream<int> countStream(int end) async* {
    for (int i = 1; i <= end; i++) {
      sleep(Duration(seconds: 2));
      yield i;
    }
  }

  countStream(5).listen((v) {
    print("got ${v}");
  });
}
