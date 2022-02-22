import 'dart:io';

import 'package:file_drag_and_drop/drag_container_listener.dart';
import 'package:file_drag_and_drop/file_drag_and_drop_channel.dart';
import 'package:file_drag_and_drop/file_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lottie/lottie.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dragAndDropChannel.initializedMainView();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lottie Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Powered by phoenixsky'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin
    implements DragContainerListener {
  List<DragFileResult> fileResults = [];
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    dragAndDropChannel.addListener(this);
  }

  @override
  void dispose() {
    dragAndDropChannel.removeListener(this);
    _controller.dispose();
    super.dispose();
  }

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: [
        MaterialButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Color"),
                    content: ColorPicker(
                      pickerColor: pickerColor,
                      onColorChanged: changeColor,
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        child: const Text('Got it'),
                        onPressed: () {
                          setState(() => currentColor = pickerColor);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          },
          child: const Text(
            "自定义背景色",
            style: TextStyle(color: Colors.white),
          ),
        )
      ]),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Container(
          color: currentColor,
          width: 225,
          height: 400,
          // width: 900,
          // height: 1600,
          alignment: Alignment.topLeft,
          child: (fileResults.isNotEmpty &&
                  (fileResults.first.fileExtension == "json" ||
                      fileResults.first.fileExtension == "zip"))
              ? Lottie.file(
                  File(fileResults.first.path),
                  fit:BoxFit.fill,
                  onLoaded: (composition)=>{
                    print('hasImages${composition.hasImages}')
                  },
                  errorBuilder: (context, error, stackTrace) => Text(error.toString()),
                  // controller: _controller,
                )
              : Lottie.network(
                  'https://gitee.com/mirrors_xvrh/lottie-flutter/raw/master/example/assets/LottieLogo1.json',
                  // controller: _controller,
                ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void draggingFileEntered() {
    print("flutter: draggingFileEntered");
  }

  @override
  void draggingFileExit() {
    print("flutter: draggingFileExit");
  }

  @override
  void performDragFileOperation(List<DragFileResult> fileResults) {
    print("flutter: performDragFileOperation");
    print(fileResults);
    setState(() {
      this.fileResults = fileResults;
    });
  }

  @override
  void prepareForDragFileOperation() {
    print("flutter: prepareForDragFileOperation");
  }
}
