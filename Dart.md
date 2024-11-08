- [**Future**](#future)
- [**Streams**](#streams)
- [**Isolates**](#isolates)


## **Future<T>**

One time asynchronous computation.

- **then((T)=>{})**: executed on success
- **catchError((err)=>{})**: executed on exception
- **timeout(Duration, FutureOr<T> onTimeout)**: executed if the future doesn't return a value before the timeout duration

```dart
void main() {
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
```

**timeout(Duration, FutureOr<T> onTimeout)** doesn't stop the future from resolving and running the **then** function.



## **Streams**

Can be continously fed with data.

**asinc\*** generator:

```dart
  Stream<int> countStream(int end) async* {
    for (int i = 1; i <= end; i++) {
      yield i;
    }
  }

  countStream(10).listen((data) {
    print(data);
  }, onDone: () {
    // Completed
  }, onError: (err) {
    // React to error
  });
```

Types:
- single-subscription: data is buffered waiting for a listener
- broadcast: no buffer, simply pass data to existing listeners


## **Isolates**

Isolates are indipendent thread, each with its resources.

**SendPort** and **ReceivePort** are used to send and receive data. **Isolate.spawn()** to launch an Isolates


```dart
import 'dart:io';
import 'dart:isolate';

main() async {
  var isolate = await Isolate.spawn(hello, "world");
  var isolate2 = await Isolate.spawn(hello, "galaxy");

  isolate.kill(priority: Isolate.immediate);
  // isolate2.kill(priority: Isolate.beforeNextEvent);
  print("pre sleep");
  sleep(Duration(seconds: 5));
}

void hello(String value) {
  sleep(Duration(seconds: 3));
  print("Hello ${value}");
}
```
