
Implements a library to create, read, write, modify and visualize an AutoCAD DXF (Drawing Interchange Format, or Drawing Exchange Format) by AutoDesk

## Features

The library can create, read, write, modify and visualize an AutoCAD DXF

## Installing

In order to use this dxf_viewer library, follow the steps above:
<ol>
  <li>Add this package to your package's pubspec.yaml file as described on the installation tab</li>
  <li>Import the library</li>
</ol>

```dart

  import 'package:dxf_viewer/dxf_viewer.dart';

```

## Usage

Define a Stateful Widget that load and then show a DXF

```dart

  class _MyAppState extends State<MyApp> {
    DxfViewer? dxf;
    @override
    void initState() {
      dxf = DxfViewer(file: File('test1.dxf'));
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        // Root widget
        home: Scaffold(
          appBar: AppBar(
            title: const Text('My Home Page'),
          ),
          body: Center(
            child: Builder(
              builder: (context) {
                return Column(
                  children: [
                    dxf ?? const Text('Hello, World!'),
                  ],
                );
              },
            ),
          ),
        ),
      );
    }
  }

```

See also <a href="https://github.com/micruo/dxf_viewer/tree/main/example">directory</a> for further examples.
 
## Features and bugs 

Note that not all the DXF entities' drawing are implemented yet.

Please file feature requests and bugs at the <a href="https://github.com/micruo/dxf_viewer/issues">issue tracker</a>.
