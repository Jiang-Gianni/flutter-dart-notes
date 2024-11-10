- [**FutureBuilder** (Widget)](#futurebuilder-widget)
- [**initState**](#initstate)
- [**FutureBuilder**](#futurebuilder)
- [**Theme**](#theme)
- [**Navigator**](#navigator)
- [**Widget testing**](#widget-testing)
- [**Flutter Driver**](#flutter-driver)
- [**url\_launcher**](#url_launcher)
- [**google\_maps\_flutter**](#google_maps_flutter)

Widgets are immutable and need to be rebuilt (if needed) in case of an application state change using **setState(){}**

In Flutter there are 3 types of trees: **Widget** (inexpensive), **Element** and **RenderObject** (expensive)

## **FutureBuilder** (Widget)

```dart
FutureBuilder(
    future: fetchNewsTitles(),
    builder: (context, snapshot) {

    // Check if async function is completed
    if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
        // Build UI for error
        } else if (snapshot.hasData) {
        // Build UI for fetched data
        }
    }
}
)
```

## **initState**

Override **initState** function to prefetch some data from API.

```dart
List<Movie> movies = [];
@override
void initState() {
 super.initState();
 fetchTrendingMovies().then((response) => setState(() {
    movies = response?.movies ?? [];
 }));
}
```


## **FutureBuilder**

```dart
FutureBuilder(
 future: fetchTrendingMovies(),
 builder: (context, snapshot) {
    List<Movie> movies = snapshot.data;
    if (!snapshot.hasData) {
        return Center(
            child: CircularProgressIndicator(),
        );
    }
    return ListView.builder(...)
 },
)
```

- **snapshot.data**: null when the data is yet to be received
- **snapshot.hasData**

**FutureBuilder** should be used to display data only and should not be mixed with other async calls since the future fires every rebuild.


## **Theme**

```dart
// In top of tree
MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
    primarySwatch: Colors.blue,
    textTheme: TextTheme(
            headline1: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26.0,
            ),
        ),
    ),
    home: const MyHomePage(title: 'Flutter Demo Home Page'),
)
// In any descendant Widget
var textStyle = Theme.of(context).primaryTextTheme.headline1;
Text(
    'This text has the headline1 style',
    style: textStyle,
),
```

For dark mode:
```dart
MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
        // ...
    ),
    darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
        backgroundColor: Colors.black,
        // ...
    ),
    themeMode: ThemeMode.dark, // or ThemeMode.system
    home: const MyHomePage(title: 'Flutter Demo Home Page'),
)
```


## **Navigator**

The screens are called routes. The names of the routes can be defined as routes parameters or with the **onGenerateRoute** parameter.


```dart
MaterialApp(
 title: 'Flutter Demo',
 // Accepts a static map
 routes: {
    // Cannot pass arguments in routes
    '/': (context) => DefaultPage(),
    '/page1': (context) => Page1(),
    '/page2': (context) => Page2(),
    '/page3': (context) => Page3(),
 },
 // Can pass parameters
 onGenerateRoute: (settings) {
 final route = settings.name;
 final args = settings.args;
 // Return appropriate page according to route and args
 },
 initialRoute: '/',
 home: const MyHomePage(title: 'Flutter Demo Home Page'),
)
```

- **Navigator.push**

```dart
Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => NewPage(),
    ),
);
```

- **Navigator.pop**

```dart
Navigator.pop(context);
Navigator.pop(context, resultData);
```

The second parameter **resultData** can be passed back to the previous page

- **Navigator.pushReplacement**

Push new page + remove current page

```dart
Navigator.pushReplacement(
    context,
    MaterialPageRoute(
        builder: (context) => NewPage(),
    ),
);
```

- **Navigator.pushAndRemoveUntil**

Push new page + remove multiple pages

```dart
// This removes all the routes before it on the stack
Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
        builder: (context) => NewPage(),
    ),
    (Route<dynamic> route) => false,
);
```

- **Navigator.popUntil**

Remove multiple pages

```dart
Navigator.popUntil(context, ModalRoute.withName('/oldScreen'));
```


## **Widget testing**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/main.dart';

void main() {
  testWidgets(
    'Test description',
    (WidgetTester tester) async {
      // Write your test here
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text('Hi there!'),
            ),
          ),
        ),
      );
      var finder = find.byType(Text);
    },
  );
}
```

**Find** widgets here [**Link**](https://docs.flutter.dev/cookbook/testing/widget/finders)

- **find.byType**
- **find.text**
- **find.byKey** (widgets can be assigned the **key** property)
- **find.descendant** and **find.ancestor**

To simulate pressing a button:
```dart
var finder = find.byIcon(Icons.add);
await tester.tap(finder);
```

**setState()** marks the Widget to be rebuilt but doesn't rebuild the widget test tree

TL;DR: **pump()** triggers a new frame (rebuilds the Widget), **pumpWidget()** sets the root Widget and then triggers a new frame, and **pumpAndSettle()** calls **pump()** until the Widget does not request new frames anymore (usually when animations are running).

Therefore if a press of a button triggers **setState()**:

```dart
var finder = find.byIcon(Icons.add);
 await tester.tap(finder);
 await tester.pump();
 // await tester.pump(Duration(seconds: 1));
```

To simulate dragging an item:

```dart
var finder = find.byIcon(Icons.add);
var moveBy = Offset(100, 100);

var slopeX = 1.0;
var slopeY = 1.0;
await tester.drag(finder, moveBy, touchSlopX: slopeX, touchSlopY: slopeY);

await tester.dragFrom(dragFrom, moveBy, touchSlopX: slopeX, touchSlopY: slopeY);

var dragDuration = Duration(seconds: 1);
await tester.timedDrag(finder, moveBy, dragDuration);
```


## **Flutter Driver**

Similar to Selenium

```dart
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
void main() {
 enableFlutterDriverExtension();
 runApp(MyApp());
}
class MyApp extends StatelessWidget {
 …
}
class MyWidget extends StatelessWidget {
 …
}
final txtUsername = find.byType(Text);
final btnAddition = find.byType(FloatingActionButton);
FlutterDriver driver;
setUpAll(()) async {
 driver = await FlutterDriver.connect();
};
tearDownAll(()) async {
 if (driver != null) {
 driver.close();
 }
}
test ('Should enter username and press button', ()async {
 await driver.tap(txtUsername);
 await driver.enterText("Martha Kent")
 await driver.tap(btnAddition);
 await driver.waitFor(find.text("Welcome"));
});
```

```bash
 flutter drive --target=test_driver/main.dart
```


## **url_launcher**

```dart
import 'package:url_launcher/url_launcher.dart';
const String _url = ...; //SEE EXAMPLES BELOW
void launchUrl() async {
 var result = await launch(_url);
}
```

- **web link**
```dart
const String _url = 'https://flutter.dev';
```

- **mail**
```dart
const String _url = 'mailto:<emailaddress>?subject=<subject>&body=<body>';
```

- **phone**
```dart
const String _url = 'tel:<phone number>';
```

- **sms**
```dart
const String _url = 'sms:<phone number>';
```

## **google_maps_flutter**
```dart
class MapDemo extends StatefulWidget {
    const MapDemo({Key? key}) : super(key: key);
    @override
    _MapDemoState createState() => _MapDemoState();
}
class _MapDemoState extends State<MapDemo> {
    late GoogleMapController controller;
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: GoogleMap(
                initialCameraPosition: CameraPosition(...),
                onMapCreated: (c) {
                    controller = c;
                },
            ),
        );
    }
}
```