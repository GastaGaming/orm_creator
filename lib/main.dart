import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import 'src/const.dart';
import 'src/orm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Orm Texture tool',
      theme: cPolygonOasisTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        //'/settings': (context) => SettingsPage(),
        //'/about': (context) => AboutPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _brogressAnimationController;

  bool _recursive = false;

  final _inputTextFieldController = TextEditingController();
  String? _selectedRootPath;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    _brogressAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    _brogressAnimationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _brogressAnimationController.dispose();
    super.dispose();
  }

  bool checkIfSelectedRootPathIsValid() {
    if (_selectedRootPath == null) {
      return false;
    } else {
      if (Directory(_selectedRootPath!).existsSync() == true) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        // add settings icon
        actions: [
          IconButton(
            highlightColor: kPolygonOasisBlueMaterial.shade500,
            hoverColor: kPolygonOasisBlueMaterial.shade100,
            icon: const Icon(Icons.settings),
            onPressed: () => _key.currentState!.openEndDrawer(),
          ),
        ],
        title: const KLogoAndText(),
      ),
      //drawer with settings icon

      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: kColorMainDarkBg,
              ),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: GoogleFonts.audiowide().fontFamily,
                    fontSize: 24,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Recursive'),
              trailing: Switch(
                value: _recursive,
                onChanged: (value) {
                  setState(() {
                    _recursive = value;
                  });
                },
                activeTrackColor: kPolygonOasisBlueMaterial.shade100,
                activeColor: kPolygonOasisBlueMaterial.shade500,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TextField(
                      controller: _inputTextFieldController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.folder_open),
                        border: OutlineInputBorder(),
                        hintText: "Input folder",
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedRootPath = value;
                          var cursorPosition =
                              _inputTextFieldController.selection;
                          _inputTextFieldController.text = value;
                          _inputTextFieldController.selection = cursorPosition;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                    side: BorderSide())),
                      ),
                      onPressed: () async {
                        String? selectedPath =
                            await FilePicker.platform.getDirectoryPath();
                        if (selectedPath != null) {
                          setState(() {
                            _selectedRootPath = selectedPath;
                            _inputTextFieldController.text = selectedPath;
                          });
                        }
                      },
                      icon: const Icon(Icons.folder),
                      label: const Text("Select folder"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _selectedRootPath != null
            ? (() {
                if (_recursive) {
                  recursiveORMgenerator(Directory(_selectedRootPath!), context);
                } else {
                  oRMgeneration(Directory(_selectedRootPath!), context);
                }
              })
            : null,
        label: const Text('Generate ORM Textures'),
        icon: const Icon(Icons.texture_sharp),
        backgroundColor: checkIfSelectedRootPathIsValid()
            ? kPolygonOasisBlueMaterial
            : Colors.grey,
      ),
    );
  }
}
