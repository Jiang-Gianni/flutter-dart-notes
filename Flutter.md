- [**FutureBuilder** (Widget)](#futurebuilder-widget)

Widgets are immutable and need to be rebuilt (if needed) in case of an application state change using **setState(){}**

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
