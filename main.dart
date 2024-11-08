import 'dart:io';
import 'dart:isolate';

main() async {
  var isolate = await Isolate.spawn(hello, "world");
  print(isolate);
  var isolate2 = await Isolate.spawn(hello, "galaxy");
  print(isolate2);

  isolate.kill(priority: Isolate.immediate);
  // isolate2.kill(priority: Isolate.beforeNextEvent);
  print("pre sleep");
  sleep(Duration(seconds: 5));
}

void hello(String value) {
  sleep(Duration(seconds: 3));
  print("Hello ${value}");
}
