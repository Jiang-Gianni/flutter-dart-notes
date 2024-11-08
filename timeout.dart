// https://api.flutter.dev/flutter/dart-async/Future/timeout.html
import 'dart:async';

void main() async {
  String result;
  result = await waitTask("completed").timeout(const Duration(seconds: 10));
  print(result); // Prints "completed" after 5 seconds.

  result = await waitTask("completed")
      .timeout(const Duration(seconds: 1), onTimeout: () => "timeout");
  print(result); // Prints "timeout" after 1 second.

  result = await waitTask("first")
      .timeout(const Duration(seconds: 2), onTimeout: () => waitTask("second"));
  print(result); // Prints "second" after 7 seconds.

  try {
    await waitTask("completed").timeout(const Duration(seconds: 2));
  } on TimeoutException {
    print("throws"); // Prints "throws" after 2 seconds.
  }

  var printFuture = waitPrint();
  await printFuture.timeout(const Duration(seconds: 2), onTimeout: () {
    print("timeout"); // Prints "timeout" after 2 seconds.
  });
  await printFuture; // Prints "printed" after additional 3 seconds.

  try {
    await waitThrow("error").timeout(const Duration(seconds: 2));
  } on TimeoutException {
    print("throws"); // Prints "throws" after 2 seconds.
  }
  // StateError is ignored
}

/// Returns [string] after five seconds.
Future<String> waitTask(String string) async {
  await Future.delayed(const Duration(seconds: 5));
  return string;
}

/// Prints "printed" after five seconds.
Future<void> waitPrint() async {
  await Future.delayed(const Duration(seconds: 5));
  print("printed");
}

/// Throws a [StateError] with [message] after five seconds.
Future<void> waitThrow(String message) async {
  await Future.delayed(const Duration(seconds: 5));
  throw Exception(message);
}

void TimeoutTest() {
  bool toPrint = true;

  void onSuccess(String v) {
    print("onSuccess");
    toPrint = !toPrint;
    print("toPrint is ${toPrint}");
    if (toPrint) {
      print(v);
    }
  }

  void onError(dynamic err) {
    print("onError");
    toPrint = !toPrint;
    print("toPrint is ${toPrint}");
    print("an error");
  }

  void onTimeout() {
    print("onTimeout");
    toPrint = !toPrint;
    print("toPrint is ${toPrint}");
    print("over");
  }

  Future<String> myFuture() {
    print("The future is");
    return Future.delayed(Duration(seconds: 2)).then(
      (value) => "now",
      // (value) => throw Exception,
    );
  }

  myFuture()
      .then(onSuccess)
      .catchError(onError)
      .timeout(Duration(seconds: 1), onTimeout: onTimeout);
}
