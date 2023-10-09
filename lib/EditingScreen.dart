import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:from_css_color/from_css_color.dart';
import 'package:hive/hive.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixel/HomeScreen.dart';
import 'package:pixel/ImageModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditingScreen extends StatefulWidget {
  File imageFile;

  EditingScreen({super.key, required this.imageFile});

  @override
  _EditingScreenState createState() => _EditingScreenState();
}

class ColorCode {
  int r, g, b;

  ColorCode(this.r, this.g, this.b);

  int getR() {
    return r;
  }

  int getG() {
    return g;
  }

  int getB() {
    return b;
  }
}

class Palette {
  String qnt;
  double x;
  double y;

  Palette({required this.qnt, required this.x, required this.y});

  factory Palette.fromMap(String data) {
    final parts = data.split(',');
    return Palette(
      qnt: parts[0],
      x: double.parse(parts[1]),
      y: double.parse(parts[2]),
    );
  }

  String toMap() {
    return '$qnt,$x,$y';
  }
}

late BuildContext _dialogContext;

class AddPalette {
  String name;
  AddPalette({required this.name});
}

class ColorPalette {
  List<colorList> colorlist = [];
  bool indexFind;
  ColorPalette({
    required this.colorlist,
    required this.indexFind,
  });
}

class colorList {
  late String colorcode;
  late int status;
  colorList({
    required this.colorcode,
    required this.status,
  });
}

class pixelcolor {
  String colorcodes;
  // late int status;
  pixelcolor({
    required this.colorcodes,
  });
}

class _EditingScreenState extends State<EditingScreen> {
  Box<dynamic>? _imageBox;
  List<CropDetails> crop_details = [];
  List<ViewCustom> color_details = [];
  List<ViewCustom> _pixelDetails = [];
  int total_Pixel = 0;

  int twoButtonTndex = 0;
  File? image_;

  bool isLoading = false;

  List<File> images = [];

  File? croped_image;
  File? picked_image;
  bool colorcheck = false;
  bool croped = false;
  bool colorsChanged = false;
  int a = 0, b = 0;
  int f = 0;

  int xWidth = 0;
  int yHeight = 0;
  int z = 0;
  int c1 = 0,
      c2 = 0,
      c3 = 0,
      c4 = 0,
      c5 = 0,
      c6 = 0,
      c7 = 0,
      c8 = 0,
      c9 = 0,
      c10 = 0,
      c11 = 0,
      c12 = 0,
      c13 = 0,
      c14 = 0,
      c15 = 0,
      c16 = 0,
      c17 = 0,
      c18 = 0,
      c19 = 0,
      c20 = 0,
      c21 = 0,
      c22 = 0,
      c23 = 0,
      c24 = 0;

  int _selectedIndex = -1;
  int _pixelIndex = -1;

  bool _isPixelated = false;
  bool _isPixeArt = false;

  int? _imageWidth;
  int? _imageHeight;

  void addPalette(String name, double x, double y) {
    setState(() {
      palette.add(
        Palette(
          // qnt: nameController.text,
          // x: double.parse(xController.text),
          // y: double.parse(yController.text),
          qnt: name,
          x: x,
          y: y,
        ),
      );
      palette.add(
        Palette(
          // qnt: nameController.text,
          // x: double.parse(xController.text),
          // y: double.parse(yController.text),
          qnt: name,
          x: x,
          y: y,
        ),
      );
      // palette.add(Palette(qnt: '...', x: 0.0, y: 0.0));
      savePalette();
    });
  }

  void savePalette() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> paletteData = palette.map((p) => p.toMap()).toList();
    await prefs.setStringList('palette', paletteData);
  }

  void deletePalette(int index) {
    setState(() {
      palette.removeAt(index);
      savePalette();
    });
  }

  void removeLast() {
    setState(() {
      palette.removeLast();
      savePalette();
    });
  }

  void loadPalette() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? paletteData = prefs.getStringList('palette');
    if (paletteData != null) {
      setState(() {
        palette = paletteData.map((data) => Palette.fromMap(data)).toList();
      });
    }
  }

  void navigateToSavedImagesScreen() {
    // Navigator.pop(context); //going to widget

    // this is going to home page
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomePage()),
    // );
    Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()))
        .then((_) => Navigator.pop(context));
  }

  // Future<void> retrieveImages() async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final files = directory.listSync();
  //
  //   setState(() {
  //     images = files
  //         .where(
  //             (file) => file.path.endsWith('.png')) // Filter by image extension
  //         .map((file) => File(file.path))
  //         .toList();
  //   });
  // }

  Future<void> _saveLocally(fileName) async {
    final storeImage = image_!.path.toString();
    print("FileName ${image_!.path.toString()}");

    final imageData = ImageModel(
        image: storeImage,
        // cropDetails: [
        //   CropDetails(cropName: 'C', xx: 1, yy: 2),
        // ],
        // colorDetails: [
        //   ColorDetails(colorName: 'c'),
        //   ColorDetails(colorName: 'd'),
        // ],
        cropDetails: crop_details,
        colorDetails: color_details,
        imageName: fileName);
    _imageBox?.add(imageData);
    setState(() {});
    print("Added to HiveDB ${_imageBox!.length}");
    Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
    print(storeImage.length);
  }

  // Future<void> _saveLocally() async {
  //   if (image_ != null) {
  //     final saveimage = File(image_!.path);
  //     final directory = await getApplicationDocumentsDirectory();
  //     final filename = '${DateTime.now().millisecondsSinceEpoch}.png';
  //     final savedImage = await saveimage.copy('${directory.path}/$filename');
  //
  //     setState(() {
  //       // images.add(savedImage);
  //       // print("lenth is ${images.length}");
  //       navigateToSavedImagesScreen();
  //       Fluttertoast.showToast(
  //           msg: "Success",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.CENTER,
  //           timeInSecForIosWeb: 1,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //     });
  //   }
  // }

  void showProgressDialog(BuildContext _dialogContext) {
    print("loading on");
    showDialog(
      context: _dialogContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 20.0),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }

  void hideProgressDialog(BuildContext _dialogContext) {
    print("loading off");
    Navigator.of(_dialogContext, rootNavigator: true).pop();
  }

  void getImageDimensions(File file) async {
    Image image = Image.file(file);
    image.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      _imageWidth = info.image.width;
      _imageHeight = info.image.height;
      // Do something with the image dimensions here, such as
      // passing them to another function for processing.
    }));
  }

  List<Palette> palette = [];

  final nameController = TextEditingController();
  final xController = TextEditingController();
  final yController = TextEditingController();

  List<colorList> _selectedColors = [];

  List<colorList> tempColors = [
    colorList(colorcode: "#0cb4a3", status: 1),
    colorList(colorcode: "#0f735b", status: 1),
    colorList(colorcode: "#439f4c", status: 1),
    colorList(colorcode: "#a8d497", status: 1),
    colorList(colorcode: "#e9e778", status: 1),
    colorList(colorcode: "#f3d922", status: 1),
    colorList(colorcode: "#f19d20", status: 1),
    colorList(colorcode: "#ef7439", status: 1),
    colorList(colorcode: "#e41f28", status: 1),
    colorList(colorcode: "#ac2126", status: 1),
    colorList(colorcode: "#f6d1cb", status: 1),
    colorList(colorcode: "#dfa2b2", status: 1),
    colorList(colorcode: "#99497e", status: 1),
    colorList(colorcode: "#7f6fae", status: 1),
    colorList(colorcode: "#19598b", status: 1),
    colorList(colorcode: "#2496cc", status: 1),
    colorList(colorcode: "#82c8d4", status: 1),
    colorList(colorcode: "#6d3421", status: 1),
    colorList(colorcode: "#b88874", status: 1),
    colorList(colorcode: "#ebdac6", status: 1),
    colorList(colorcode: "#f0f0f0", status: 1),
    colorList(colorcode: "#c1c6ca", status: 1),
    colorList(colorcode: "#81898b", status: 1),
    colorList(colorcode: "#262729", status: 1),
  ];

  List<colorList> tempColor1 = [
    colorList(colorcode: "#0cb4a3", status: 1),
    colorList(colorcode: "#0f735b", status: 1),
    colorList(colorcode: "#439f4c", status: 1),
    colorList(colorcode: "#a8d497", status: 1),
    colorList(colorcode: "#e9e778", status: 1),
    colorList(colorcode: "#f3d922", status: 1),
    colorList(colorcode: "#f19d20", status: 1),
    colorList(colorcode: "#ef7439", status: 1),
    colorList(colorcode: "#e41f28", status: 1),
    colorList(colorcode: "#ac2126", status: 1),
    colorList(colorcode: "#f6d1cb", status: 1),
    colorList(colorcode: "#dfa2b2", status: 1),
    colorList(colorcode: "#99497e", status: 1),
    colorList(colorcode: "#7f6fae", status: 1),
    colorList(colorcode: "#19598b", status: 1),
    colorList(colorcode: "#2496cc", status: 1),
    colorList(colorcode: "#82c8d4", status: 1),
    colorList(colorcode: "#6d3421", status: 1),
    colorList(colorcode: "#b88874", status: 1),
    colorList(colorcode: "#ebdac6", status: 1),
    colorList(colorcode: "#f0f0f0", status: 1),
    colorList(colorcode: "#c1c6ca", status: 1),
    colorList(colorcode: "#81898b", status: 1),
    colorList(colorcode: "#262729", status: 1),
  ];

  List<ColorPalette> colorpalet = [];
  List<colorList> colorpalet1 = [];

  @override
  void dispose() {
    // _imageBox?.close();
    //
    // if (mounted) {
    //   // Access the context only if the widget is still mounted
    //   // Perform any necessary cleanup or cancel any active work
    // }

    nameController.dispose();
    xController.dispose();
    yController.dispose();

    super.dispose();
  }

  void _selectColor(int index) {
    // print(
    //     "${_selectedColors[index].colorcode} \t ${_selectedColors[index].status}");
    // print("color selected ${_selectedColors.length}");

    setState(() {
      if (_selectedColors[index].status == 0) {
        _selectedColors[index].status = 1;
        // colorcheck = true;
      } else {
        _selectedColors[index].status = 0;
        // colorcheck = false;
      }
    });
    print(
        "${_selectedColors[index].colorcode} \t ${_selectedColors[index].status}");
  }

  Future<void> openImageBox() async {
    // Open the image box
    // _imageBox = await Hive.openBox<dynamic>('images');
    _imageBox = Hive.box<dynamic>('images');
    f = _imageBox!.isEmpty ? 0 : _imageBox!.length;
    print("value of ${f}");
    a = f + 1;
    b = f + 1;
  }

  @override
  void initState() {
    super.initState();
    openImageBox();
    loadPalette();
    // retrieveImages();
    picked_image = File(widget.imageFile.path);
    palette.add(Palette(qnt: "1", x: 1, y: 1));
    palette.add(Palette(qnt: "0", x: 0, y: 0));

    colorpalet.add(ColorPalette(colorlist: tempColors, indexFind: true));
    colorpalet.add(ColorPalette(colorlist: tempColors, indexFind: true));

    print("Size ${colorpalet.length}");
    print("Size ${colorpalet[0].indexFind}");
    setState(() {
      image_ = picked_image;
    });
  }

  _showDialog() {
    final ValueNotifier<int?> selectedXAxis = ValueNotifier<int?>(null);
    final ValueNotifier<int?> selectedYAxis = ValueNotifier<int?>(null);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            side: BorderSide(width: 3.0, color: Colors.red),
          ),
          title: const Text("Add Palette"),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ValueListenableBuilder<int?>(
                        valueListenable: selectedXAxis,
                        builder: (context, value, _) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: DropdownButton<int>(
                              value: value,
                              hint: const Text('Column'),
                              onChanged: (newValue) {
                                selectedXAxis.value = newValue;
                              },
                              items: const <DropdownMenuItem<int>>[
                                DropdownMenuItem<int>(
                                  value: 1,
                                  child: Text('1'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 2,
                                  child: Text('2'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 3,
                                  child: Text('3'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 4,
                                  child: Text('4'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 6,
                                  child: Text('6'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 8,
                                  child: Text('8'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 10,
                                  child: Text('10'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 12,
                                  child: Text('12'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ValueListenableBuilder<int?>(
                        valueListenable: selectedYAxis,
                        builder: (context, value, _) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: DropdownButton<int>(
                              value: value,
                              hint: const Text('Row'),
                              onChanged: (newValue) {
                                selectedYAxis.value = newValue;
                              },
                              items: const <DropdownMenuItem<int>>[
                                DropdownMenuItem<int>(
                                  value: 1,
                                  child: Text('1'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 2,
                                  child: Text('2'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 3,
                                  child: Text('3'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 4,
                                  child: Text('4'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 6,
                                  child: Text('6'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 8,
                                  child: Text('8'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 10,
                                  child: Text('10'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 12,
                                  child: Text('12'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Card(
                elevation: 4, // Controls the shadow depth
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8), // Controls the corner radius
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.all(8), // Adjust the padding as needed
                  child: Image.asset(
                    'assets/images/setting_lines.png', // Replace with your image path
                    width: 100,
                    height: 100,
                  ),
                ),
              ),

              // Image.asset(
              //   'assets/images/setting_lines.png', // Replace with your image path
              //   width: 100,
              //   height: 100,
              // ),
            ],
          ),
          actions: <Widget>[
            SizedBox(
              width: 80,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
            ),
            SizedBox(
              width: 80,
              child: ElevatedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  side: const BorderSide(width: 1, color: Colors.red),
                ),
                onPressed: () {
                  setState(() {
                    /////////////
                    palette.removeLast();
                    addPalette(
                      // nameController.text.toString(),
                      "1",
                      selectedXAxis.value?.toDouble() ?? 0.0,
                      selectedYAxis.value?.toDouble() ?? 0.0,
                    );
                  });
                  ///////////////
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _showColorDialog() {
    int dublicate = 0;
    print(colorcheck);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateInnner) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                side: BorderSide(width: 3.0, color: Colors.red),
              ),
              title: const Text("Pick a color"),
              content: Container(
                width: double.maxFinite,
                height: 280,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    childAspectRatio: 1,
                  ),
                  itemCount: tempColor1.length,
                  itemBuilder: (BuildContext context, int index) {
                    // final color =
                    //     fromCssColor(colorpalet[0].colorlist[index].colorcode);
                    // print(colorpalet[0].colorlist[index].status);
                    // print(colorpalet[0].colorlist[index].colorcode);
                    return GestureDetector(
                      onTap: () => setStateInnner(() {
                        _selectColor(index);
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          color: fromCssColor(tempColor1[index].colorcode),
                          // border: Border.all(
                          //   color: _selectedColors[index].status == 1
                          //       ? Colors.red
                          //       : fromCssColor(tempColor1[index].colorcode),
                          //   // : Colors.grey,
                          //   width: 2,
                          // ),
                        ),
                        child: Center(
                          child: _selectedColors[index].status == 1
                              ? Icon(Icons.check,
                                  color: (_selectedColors[index]
                                              .colorcode
                                              .toString() ==
                                          "#262729"
                                      ? Colors.grey
                                      : Colors.black))
                              : const Icon(Icons.check,
                                  color: Colors.transparent),
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: <Widget>[
                SizedBox(
                  width: 80,
                  child: ElevatedButton(
                    child: const Text('Cancel'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop([]);
                    },
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: ElevatedButton(
                    child: const Text(
                      'Ok',
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        side: const BorderSide(width: 1, color: Colors.red)),
                    onPressed: () {
                      setState(() {
                        colorpalet1 = colorpalet.last.colorlist;
                        colorpalet.removeLast();
                        List<colorList> addColors = [];
                        for (int i = 0; i < _selectedColors.length; i++) {
                          addColors.add(colorList(
                              colorcode: _selectedColors[i].colorcode,
                              status: _selectedColors[i].status));
                          if (_selectedColors[i].status == 0) {
                            dublicate++;
                          }
                        }
                        print(dublicate);
                        if (dublicate == 24) {
                          colorpalet.add(ColorPalette(
                              colorlist: colorpalet1, indexFind: false));
                          colorpalet.add(ColorPalette(
                              colorlist: colorpalet1, indexFind: false));
                          colorpalet.removeLast();
                          Fluttertoast.showToast(
                              msg: "Select the color",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          colorpalet.add(ColorPalette(
                              colorlist: addColors, indexFind: false));
                          colorpalet.add(ColorPalette(
                              colorlist: addColors, indexFind: false));
                        }
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Color getColorFromString(String colorString) {
    if (colorString.startsWith('#') &&
        (colorString.length == 7 || colorString.length == 9)) {
      String hexValue = colorString.replaceAll('#', '');
      int value = int.parse(hexValue, radix: 16);
      return Color(value);
    } else {
      // Handle invalid color string here
      return Colors.black; // Default to black color if string is invalid
    }
  }

  Future<void> _Selectedcolor_Extract() async {
    print(" value of Z is ${z}");

    print(" value of size is ${colorpalet[z].colorlist.length}");

    total_Pixel = c1 +
        c2 +
        c3 +
        c4 +
        c5 +
        c6 +
        c7 +
        c8 +
        c9 +
        c10 +
        c11 +
        c12 +
        c13 +
        c14 +
        c15 +
        c16 +
        c17 +
        c18 +
        c19 +
        c20 +
        c21 +
        c22 +
        c23 +
        c24;
    int colorLength = colorpalet[z].colorlist.length;
    // List<viewCustom> _pixelDetails = [];
    _pixelDetails.clear();

    for (var i = 0; i < colorLength; i++) {
      if (colorpalet[z].colorlist[i].status == 1) {
        // print(" color is  ${colorpalet[z].colorlist[i].colorcode.runtimeType}");
        // _pixelDetails.add(colorpalet[z].colorlist[i].colorcode);
        // print(
        //     "checking... ${colorpalet[z].colorlist[i].colorcode.runtimeType}");
        String colorcountadd = colorpalet[z].colorlist[i].colorcode;
        print("colorecountadd  ${colorcountadd}");

        switch (colorcountadd) {
          case "#0cb4a3":
            // Perform specific actions for color code #808080
            //   print("Color code #808080 count: $count");
            //   gray++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c1));
            break;
          case "#0f735b":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   orange1++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c2));
            break;
          case "#439f4c":
            // Perform specific actions for color code #808080
            //   print("Color code #808080 count: $count");
            //   green1++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c3));
            break;
          case "#a8d497":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   brown++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c4));
            break;
          case "#e9e778":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   darkG++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c5));
            break;
          case "#f3d922":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   black++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c6));
            break;
          case "#f19d20":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   white++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c7));
            break;
          case "#ef7439":
            // Perform specific actions for color code #808080
            //   print("Color code #808080 count: $count");
            //   gray++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c8));
            break;
          case "#e41f28":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   orange1++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c9));
            break;
          case "#ac2126":
            // Perform specific actions for color code #808080
            //   print("Color code #808080 count: $count");
            //   green1++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c10));
            break;
          case "#f6d1cb":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   brown++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c11));
            break;
          case "#dfa2b2":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   darkG++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c12));
            break;
          case "#99497e":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   black++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c13));
            break;

          case "#7f6fae":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   white++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c14));
            break;
          case "#19598b":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   white++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c15));
            break;
          case "#2496cc":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   darkG++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c16));
            break;
          case "#82c8d4":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   black++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c17));
            break;
          case "#6d3421":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   white++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c18));
            break;
          case "#b88874":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   white++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c19));
            break;
          case "#ebdac6":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   white++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c20));
            break;
          case "#f0f0f0":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   white++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c21));
            break;
          case "#c1c6ca":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   white++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c22));
            break;
          case "#81898b":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   white++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c23));
            break;
          case "#262729":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   white++;
            _pixelDetails.add(ViewCustom(
                addViewColor: colorpalet[z].colorlist[i].colorcode,
                color_count: c24));
            break;
        }
        // _pixelDetails.add(viewCustom(
        //     addViewColor: colorpalet[z].colorlist[i].colorcode,
        //     color_count: 5));
      }
    }

    color_details.clear();
    for (var k = 0; k < _pixelDetails.length; k++) {
      if (_pixelDetails[k].color_count > 0) {
        color_details.add(ViewCustom(
            addViewColor: _pixelDetails[k].addViewColor,
            color_count: _pixelDetails[k].color_count.toInt()));
      }
    }
    print(" value of color size is  ${_pixelDetails.length}");
    print(" above  Zero color size  ${color_details.length}");

    for (var l = 0; l < color_details.length; l++) {
      // print(" above  Zero color is  ${color_details[l].colorName}");
    }
  }

  void _saveExitDialog(BuildContext context) {
    String fileName = '';
    bool showError = false;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                side: BorderSide(width: 3.0, color: Colors.red),
              ),
              title: const Text(
                'Enter The File Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        fileName = value;
                        showError = false;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'File Name',
                      errorText: showError ? 'File name cannot be empty' : null,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Text(
                  //   showError ? 'File name cannot be empty' : '',
                  //   style: TextStyle(
                  //     color: Colors.red,
                  //   ),
                  // ),
                ],
              ),
              actions: <Widget>[
                SizedBox(
                  width: 80,
                  child: ElevatedButton(
                    child: const Text('Cancel'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: ElevatedButton(
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        side: const BorderSide(width: 1, color: Colors.red)),
                    onPressed: () {
                      if (fileName.isEmpty) {
                        setState(() {
                          showError = true;
                        });
                      } else {
                        _saveLocally(fileName);
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.pop(
                            context); // Return to the first home screen
                      }
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  _viewColorDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateInnner) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                side: BorderSide(width: 3.0, color: Colors.red),
              ),
              title: const Text("Pixel Details"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Total Pixel ${total_Pixel}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 290,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0,
                        childAspectRatio: 1,
                      ),
                      itemCount: _pixelDetails.length,
                      itemBuilder: (BuildContext context, int index) {
                        // final color =
                        //     fromCssColor(colorpalet[0].colorlist[index].colorcode);
                        // print(colorpalet[0].colorlist[index].status);
                        // print(colorpalet[0].colorlist[index].colorcode);
                        return GestureDetector(
                          onTap: () => setStateInnner(() {
                            // _selectColor(index);
                          }),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              color: fromCssColor(
                                  _pixelDetails[index].addViewColor),
                              border: Border.all(color: Colors.transparent),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${_pixelDetails[index].color_count}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: (_pixelDetails[index]
                                                .addViewColor
                                                .toString() ==
                                            "#262729"
                                        ? Colors.grey
                                        : Colors.black),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Ok',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 20.0),
                Text("Please wait a moment..."),
              ],
            ),
          ),
        );
      },
    );
  }

  void _hideProgressDialog(BuildContext context) {
    Navigator.of(context).pop(); // Close the dialog
  }

  //Custom Crop Design

  // Future<void> _cropImage(
  //     String name, double aspectRatioX, double aspectRatioY) async {
  //   xWidth = aspectRatioX.toInt();
  //   yHeight = aspectRatioY.toInt();
  //
  //   final croppedImage = await ImageCropper().cropImage(
  //     sourcePath: picked_image!.path,
  //     aspectRatio: CropAspectRatio(
  //       ratioX: aspectRatioX,
  //       ratioY: aspectRatioY,
  //     ),
  //     androidUiSettings: AndroidUiSettings(
  //       // cropGridColor: Colors.black,
  //       // cropFrameColor: Colors.black,
  //       cropGridRowCount: yHeight - 1,
  //       cropGridColumnCount: xWidth - 1,
  //       cropFrameStrokeWidth: 1,
  //       cropFrameColor: Colors.white,
  //       activeControlsWidgetColor: Colors.red,
  //       toolbarTitle: 'CropImage', // Set the screen title to "CropYourOwn"
  //       toolbarWidgetColor: Colors.red, // Set the toolbar widget color
  //       toolbarColor: Colors.white, // Set the app bar color to red
  //       statusBarColor: Colors
  //           .transparent, // Set the status bar color to red (Android only)
  //     ),
  //     iosUiSettings: const IOSUiSettings(
  //       title: 'CropYourOwn', // Set the screen title to "CropYourOwn"
  //       doneButtonTitle: 'Crop', // Set the done button title
  //       cancelButtonTitle: 'Cancel', // Set the cancel button title
  //       // doneButtonColor: Colors.red, // Set the done button color to red
  //       // cancelButtonColor: Colors.red, // Set the cancel button color to red
  //     ),
  //   );
  //
  //   if (croppedImage != null) {
  //     // Do something with the cropped image
  //     print("call-2");
  //
  //     getImageDimensions(croppedImage);
  //
  //     setState(() {
  //       image_ = croppedImage;
  //       croped_image = croppedImage;
  //       setState(() {
  //         croped = true;
  //       });
  //     });
  //   }
  // }

  //Default Design

  Future<void> _cropImage(
      String name, double aspectRatioX, double aspectRatioY) async {
    print("call-1");

    xWidth = aspectRatioX.toInt();
    yHeight = aspectRatioY.toInt();

    crop_details.clear();

    crop_details
        .add(CropDetails(cropName: name, xx: aspectRatioX, yy: aspectRatioY));
    print("ABOVESIZE");
    print(crop_details.length);
    // print(crop_details[0].xx);
    if (picked_image == null) return;

    final croppedImage = await ImageCropper().cropImage(
      sourcePath: picked_image!.path,
      aspectRatio: CropAspectRatio(
        ratioX: aspectRatioX,
        ratioY: aspectRatioY,
      ),
    );

    if (croppedImage != null) {
      print("call-2");

      getImageDimensions(croppedImage);

      setState(() {
        image_ = croppedImage;
        croped_image = croppedImage;
        setState(() {
          croped = true;
          _isPixeArt = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    _dialogContext = context;

    return SafeArea(
        child: Scaffold(
            body: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: Image.file(File(widget.imageFile.path)).image,
                      fit: BoxFit.cover),
                ),
                child: ClipRRect(
                  // make sure we apply clip it properly
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.grey.withOpacity(0.1),
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            color: Colors.white.withOpacity(0.4),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                    ),
                                    color: Colors.black,
                                    onPressed: () {
                                      // navigateToSavedImagesScreen();
                                      Navigator.pop(context);
                                      // do something when the first icon button is pressed
                                    },
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SizedBox(
                                      width: 100,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.red),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          // Action to perform when the button is pressed
                                          print("Inside view");
                                          _isPixeArt
                                              ? _viewColorDialog()
                                              : Fluttertoast.showToast(
                                                  msg: "Choose Pixel Art",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                        },
                                        child: const Text(
                                          'View',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: TextButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.red),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        // Action to perform when the button is pressed
                                        print("Press Save");
                                        // _saveLocally();
                                        _isPixeArt
                                            ? _saveExitDialog(context)
                                            : Fluttertoast.showToast(
                                                msg: "Choose Pixel Art",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                      },
                                      child: const Text(
                                        'Save',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: Image.file(
                                // Replace this path with your own file path
                                File(image_!.path),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          // const Spacer(),
                          Container(
                            color: Colors.white.withOpacity(0.4),
                            child: Row(
                              children: <Widget>[
// First buttton
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _onItemButtonsTap(0);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        side: BorderSide(
                                            color: twoButtonTndex == 0
                                                ? Colors.red
                                                : Colors.transparent),
                                        padding: const EdgeInsets.all(16.0),
                                        backgroundColor: Colors.black,
                                      ),
                                      child: const Icon(
                                        Icons.crop,
                                        color: Colors.white,
                                        size: 20.0,
                                      ),
                                    ),
                                  ),
                                ),

// Second button
                                SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _onItemButtonsTap(1);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      side: BorderSide(
                                          color: twoButtonTndex == 1
                                              ? Colors.red
                                              : Colors.transparent),
                                      padding: const EdgeInsets.all(16.0),
                                      backgroundColor: Colors.black,
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/images/palettee.svg',
                                      height: 25,
                                      width: 25,
                                      colorFilter: const ColorFilter.mode(
                                          Colors.white, BlendMode.srcIn),

                                      // color: Colors.white,
                                      // Adjust to fit your needs
                                    ),
                                    // child: Icon(
                                    //   Icons.filter,
                                    //   color: Colors.white,
                                    //   size: 20.0,
                                    // ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          twoButtonTndex == 0
                              ? cropContainer()
                              : colorpalleteContainer(),
                        ],
                      ),
                    ),
                  ),
                ))));
  }

  Widget colorpalleteContainer() {
    print("Total pallet ${colorpalet.length}");
    return Container(
      color: Colors.white.withOpacity(0.4),
      height: 124,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: colorpalet.length,
                itemBuilder: (context, mainindex) {
                  return mainindex == colorpalet.length - 1
                      ? custompallte("color")
                      : GestureDetector(
                          onTap: () async {
                            setState(() {
                              _selectedIndex = mainindex;
                            });
                            if (croped) {
                              try {
                                showDialog(
                                  context: _dialogContext,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            // CircularProgressIndicator(),
                                            SizedBox(width: 20.0),
                                            Text("Please wait a moment..."),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );

                                print("start progress bar");
                                await Future.delayed(const Duration(
                                    seconds: 1)); // Simulated delayed

                                await Future(() async {
                                  await colorsPalete(mainindex);
                                });

                                Navigator.of(context).pop(); // Close the dialog
                                print("stop progress bar");
                              } catch (e) {
                                print("Error: $e");
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: "First Crop The Image",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          },
                          // _cropImage(2);
                          //   setState(() {
                          //     _selectedIndex = mainindex;
                          //     isLoading = true;
                          //     _dialogContext = context;
                          //   });
                          //   showProgressDialog(_dialogContext);
                          //   croped
                          //       ? colorsPalete(mainindex)
                          //       : Fluttertoast.showToast(
                          //           msg: "First Crop The Image",
                          //           toastLength: Toast.LENGTH_SHORT,
                          //           gravity: ToastGravity.CENTER,
                          //           timeInSecForIosWeb: 1,
                          //           textColor: Colors.white,
                          //           fontSize: 16.0);
                          //   setState(() {
                          //     isLoading = false;
                          //   });
                          //   hideProgressDialog(_dialogContext);
                          // },
                          child: Container(
                            width: 100,
                            height: 100,
                            child: Card(
                              elevation: 10.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  color: _selectedIndex == mainindex
                                      ? Colors.red
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4.5),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 1,
                                    ),
                                    Container(
                                      height: 80,
                                      width: 80,
                                      child: GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 5,
                                          mainAxisSpacing: 0,
                                          crossAxisSpacing: 0,
                                          childAspectRatio: 1,
                                        ),
                                        itemCount: colorpalet[mainindex]
                                            .colorlist
                                            .length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Container(
                                              width: 2.5,
                                              height: 2.5,
                                              decoration: BoxDecoration(
                                                  color: colorpalet[mainindex]
                                                              .colorlist[index]
                                                              .status ==
                                                          1
                                                      ? fromCssColor(
                                                          colorpalet[mainindex]
                                                              .colorlist[index]
                                                              .colorcode)
                                                      : Colors.transparent,
                                                  border: Border.all(
                                                      color:
                                                          Colors.transparent)),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const Spacer(),
                                    colorpalet[mainindex].indexFind
                                        ? const Text(
                                            "All",
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : Text(
                                            "Demo ${mainindex}",
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                }),
          ),
        ],
      ),
    );
  }

  Widget cropContainer() {
    print("inside pixel ${palette.length}");
    return Container(
      color: Colors.white.withOpacity(0.4),
      height: 124,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: palette.length,
                itemBuilder: (context, index) {
                  int xv = palette[index].x.toInt() * 16;
                  int yv = palette[index].y.toInt() * 16;
                  int xvv = xv * yv;
                  String yvv = xvv.toString();
                  double divide = xvv / 16;
                  double title = divide / 16;
                  int ans = title.toInt();
                  String ansTitle = ans.toString();

                  // print(
                  //     "index is  ${index} \t value is ${palette[index].qnt } \t ${palette.length}");
                  return index == palette.length - 1
                      ? customCard("Add")
                      : GestureDetector(
                          onTap: () {
                            // _cropImage(2);
                            setState(() {
                              _pixelIndex = index;
                            });
                            _cropImage(palette[index].qnt.toString(),
                                palette[index].x, palette[index].y);

                            // Fluttertoast.showToast(
                            //     msg: "Selected item: ${palette[index].qnt}");
                          },
                          onLongPress: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Please Confirm'),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    side: BorderSide(
                                        width: 3.0, color: Colors.red),
                                  ),
                                  content: const Text(
                                      'Are you sure to remove the item'),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: ElevatedButton(
                                            child: const Text('Cancel'),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.red),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: ElevatedButton(
                                            child: const Text(
                                              'Confirm',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.red),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24)),
                                                side: const BorderSide(
                                                    width: 1,
                                                    color: Colors.red)),
                                            onPressed: () {
                                              deletePalette(index);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            child: Card(
                              elevation: 10.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  color: _pixelIndex == index
                                      ? Colors.red
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      ansTitle,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    ans == 1
                                        ? const Text(
                                            "Tile",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          )
                                        : const Text(
                                            "Tiles",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      "${yvv} Pixels",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceAround,
                                    //   children: [
                                    //     Text(
                                    //       "${yvv}",
                                    //       style: const TextStyle(
                                    //         color: Colors.black,
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 10,
                                    //       ),
                                    //     ),
                                    //     SizedBox(
                                    //       width: 2,
                                    //     ),
                                    //      Text(
                                    //       "Pixels ${yvv}",
                                    //       style: TextStyle(
                                    //         color: Colors.black,
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 12,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                }),
          ),
        ],
      ),
    );
  }

  Widget customCard(String name) {
    return Container(
      width: 100,
      height: 103,
      child: InkWell(
        onTap: () {
          _showDialog();
          print("Clicked");
        },
        child: Card(
            elevation: 10.0,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(
                    //   Icons.menu,
                    //   size: 40.0,
                    //   color: Colors.black,
                    // ),
                    Image.asset(
                      'assets/images/setting_lines.png',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ))),
      ),
    );
  }

  Widget custompallte(String name) {
    return Container(
      width: 100,
      height: 103,
      child: InkWell(
        onTap: () {
          _showColorDialog();
          print("shows");
          _selectedColors = tempColor1;
          for (int i = 0; i < _selectedColors.length; i++) {
            _selectedColors[i].status = 0;
          }
          print("Clicked");
        },
        child: Card(
            elevation: 10.0,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(
                    //   Icons.menu,
                    //   size: 40.0,
                    //   color: Colors.black,
                    // ),
                    Image.asset(
                      'assets/images/setting_lines.png',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ))),
      ),
    );
  }

  // Step1
  Future<void> colorsPalete(int a) async {
    // showProgressDialog();
    c1 = 0;
    c2 = 0;
    c3 = 0;
    c4 = 0;
    c5 = 0;
    c6 = 0;
    c7 = 0;
    c8 = 0;
    c9 = 0;
    c10 = 0;
    c11 = 0;
    c12 = 0;
    c13 = 0;
    c14 = 0;
    c15 = 0;
    c16 = 0;
    c17 = 0;
    c18 = 0;
    c19 = 0;
    c20 = 0;
    c21 = 0;
    c22 = 0;
    c23 = 0;
    c24 = 0;

    _isPixelated = true;

    z = a;

    // _isPixelated ? showProgressDialog : hideProgressDialog;

    List<ColorCode> replace_colors = [];

    print("Selected item is ${a}");

    int colors = colorpalet[a].colorlist.length;

    for (int i = 0; i < colors; i++) {
      if (colorpalet[a].colorlist[i].status == 1) {
        Color c = (fromCssColor(colorpalet[a].colorlist[i].colorcode));
        print("Selected color ${c}");
        int r = c.red;
        int g = c.green;
        int b = c.blue;
        replace_colors.add(ColorCode(r, g, b));
        print("Selected item RGB ${r}\t ${g}\t${b}");
      }
    }
    print("Selected item color ${replace_colors.length}");

    await _pixelateImage(replace_colors);
    // hideProgressDialog();
  }

  Future<void> _pixelateImage(List<ColorCode> replace_colors) async {
    int xValue = xWidth * 16;
    int yValue = yHeight * 16;

    print("CHECK value of x ${xValue}");
    print("CHECK value of y ${yValue}");

    setState(() {
      _isPixelated = true;
    });

    print("CHECK Inside PixelateImage \t${replace_colors.length}");

    print(_imageHeight);
    print(_imageWidth);
    // Load the image file
    final bytes = croped_image!.readAsBytesSync();
    final image = img.decodeImage(bytes)!;

    // Apply the pixelation effect
    // final pixelatedImage = img.pixelate(image, size: 10);

    final resizedImage = img.copyResize(image, width: xValue, height: yValue);

    DateTime datetime = DateTime.now();
    String dateStr = datetime.toString();
    print(dateStr);

    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    final pixelatedFile = File('$tempPath/resize$dateStr.jpg')
      ..writeAsBytesSync(img.encodeJpg(resizedImage));

    await changeColor(pixelatedFile, replace_colors);
    a++;
  }

  Future<void> changeColor(File file, List<ColorCode> replace_colors) async {
    print("Inside changeColor \t${replace_colors.length}");

    final bytes1 = file.readAsBytesSync();
    final image1 = img.decodeImage(bytes1);

    print("CHECK changeColorHeight ${image1!.height}");
    print("CHECK changeColorwidth ${image1.width}");
    print("CHECK changeColorlength ${image1.length}");
    List<Color> modifiedColors = [];

    for (int y = 0; y < image1.height; y++) {
      for (int x = 0; x < image1.width; x++) {
        // Retrieving contents of a pixel
        final pixel = image1.getPixel(x, y);
        print("Pixel value\t  ${x} \t ${y}\t ${pixel}");
        final red = pixel.r;
        final green = pixel.g;
        final blue = pixel.b;
        print("SET\tred ${red} , green${green} blue${blue}");
        ColorCode res = await nearestColor(
            replace_colors, red.toInt(), green.toInt(), blue.toInt());
        print("color code :${res.getR()},${res.getG()},${res.getB()}");

        // Creating new Color object
        // color = Color.fromARGB(0, res.getR(), res.getG(), res.getB());
        // Setting new Color object to the image
        image1.setPixelRgb(x, y, res.getR(), res.getG(), res.getB());
        // img.Pixel pixelColor = image1.getPixel(x, y);
        // print("after setting color ${pixelColor}");
        Color color = Color.fromRGBO(res.getR(), res.getG(), res.getB(), 1.0);

        String colorCode =
            '#${color.value.toRadixString(16).substring(2).toLowerCase()}';
        print('Color Code final is : $colorCode');

        modifiedColors
            .add(Color.fromARGB(255, res.getR(), res.getG(), res.getB()));

        switch (colorCode) {
          // case "#808080":
          //   // Perform specific actions for color code #808080
          //   //   print("Color code #808080 count: $count");
          //   gray++;
          //   break;
          // colorList(colorcode: "#0cb4a3", status: 1),
          // colorList(colorcode: "#0f735b", status: 1),
          // colorList(colorcode: "#439f4c", status: 1),
          // colorList(colorcode: "#a8d497", status: 1),
          // colorList(colorcode: "#e9e778", status: 1),
          case "#0cb4a3":
            // Perform specific actions for color code #808080
            //   print("Color code #808080 count: $count");
            //   gray++;
            c1++;
            break;

          case "#0f735b":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   orange1++;
            c2++;
            break;
          case "#439f4c":
            // Perform specific actions for color code #808080
            //   print("Color code #808080 count: $count");
            //   green1++;
            c3++;
            break;
          case "#a8d497":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   brown++;
            c4++;
            break;
          case "#e9e778":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   darkG++;
            c5++;
            break;
          //         colorList(colorcode: "#f3d922", status: 1),
          // colorList(colorcode: "#f19d20", status: 1),
          // colorList(colorcode: "#ef7439", status: 1),
          // colorList(colorcode: "#e41f28", status: 1),
          // colorList(colorcode: "#ac2126", status: 1),
          case "#f3d922":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   black++;
            c6++;
            break;
          case "#f19d20":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   white++;
            c7++;
            break;
          case "#ef7439":
            // Perform specific actions for color code #808080
            //   print("Color code #808080 count: $count");
            //   gray++;
            c8++;
            break;
          case "#e41f28":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   orange1++;
            c9++;
            break;
          case "#ac2126":
            // Perform specific actions for color code #808080
            //   print("Color code #808080 count: $count");
            //   green1++;
            c10++;
            break;
          // colorList(colorcode: "#f6d1cb", status: 1),
          // colorList(colorcode: "#dfa2b2", status: 1),
          // colorList(colorcode: "#99497e", status: 1),
          // colorList(colorcode: "#7f6fae", status: 1),
          // colorList(colorcode: "#19598b", status: 1),
          case "#f6d1cb":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   brown++;
            c11++;
            break;
          case "#dfa2b2":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   darkG++;
            c12++;
            break;
          case "#99497e":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   black++;
            c13++;

            break;
          case "#7f6fae":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   white++;
            c14++;

            break;
          case "#19598b":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   white++;
            c15++;

            break;
          //         colorList(colorcode: "#2496cc", status: 1),
          // colorList(colorcode: "#82c8d4", status: 1),
          // colorList(colorcode: "#6d3421", status: 1),
          // colorList(colorcode: "#b88874", status: 1),
          // colorList(colorcode: "#ebdac6", status: 1),
          case "#2496cc":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   darkG++;
            c16++;

            break;
          case "#82c8d4":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   black++;
            c17++;

            break;
          case "#6d3421":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   white++;
            c18++;

            break;
          case "#b88874":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   white++;
            c19++;

            break;
          case "#ebdac6":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   white++;
            c20++;
            break;
          // colorList(colorcode: "#f0f0f0", status: 1),
          // colorList(colorcode: "#c1c6ca", status: 1),
          // colorList(colorcode: "#81898b", status: 1),
          // colorList(colorcode: "#262729", status: 1),
          case "#f0f0f0":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   white++;
            c21++;
            break;
          case "#c1c6ca":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   white++;
            c22++;
            break;
          case "#81898b":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   white++;
            c23++;

            break;
          case "#262729":
            // Perform specific actions for color code #89580
            //   print("Color code #89580 count: $count");
            //   white++;
            c24++;
            break;
        }
      }
    }

    DateTime datetime = DateTime.now();
    String dateSec = datetime.toString();
    // String dateMsec = datetime.millisecond.toString();
    // final resizedImage3 =
    //     img.copyResize(image1, width: _imageWidth, height: _imageHeight);

    // final pixelatedImage = img.pixelate(resizedImage3, size: 10);

    final tempDirc = await getTemporaryDirectory();
    final tempPathc = tempDirc.path;
    final colorchaged_img = File('$tempPathc/colorchange$dateSec.jpg')
      ..writeAsBytesSync(img.encodeJpg(image1));

    // addGridLinesToImage(colorchaged_img, 2);

    final bytes3 = colorchaged_img!.readAsBytesSync();
    final image3 = img.decodeImage(bytes3)!;

    final resizedImage1 =
        img.copyResize(image3, width: _imageWidth, height: _imageHeight);

    final tempDirb = await getTemporaryDirectory();
    final tempPathb = tempDirb.path;
    final colorchaged_imgbig = File('$tempPathb/colorchange_big$dateSec.jpg')
      ..writeAsBytesSync(img.encodeJpg(resizedImage1));

    setState(() {
      setState(() {
        image_ = colorchaged_imgbig;
        _isPixeArt = true;
      });
      _isPixelated = false;
      colorsChanged = true;
    });

    b++;
    // hideProgressDialog();
    await _Selectedcolor_Extract();
  }

  Future<void> addGridLinesToImage(File file, int gridSize) async {
    final bytes1 = await file.readAsBytes();
    final image1 = img.decodeImage(bytes1);

    if (image1 == null) {
      // Handle the case where image decoding fails
      return;
    }

    print("line image1.height ${image1.height}");
    print("line image1.width ${image1.width}");

    final cellWidth = image1.width ~/ gridSize;
    final cellHeight = image1.height ~/ gridSize;

    print(" line image1 cellWidth ${cellWidth}");
    print("cellHeight ${cellHeight}");

    // Draw vertical grid lines
    for (int x = cellWidth; x < image1.width; x += cellWidth) {
      for (int y = 0; y < image1.height; y++) {
        image1.setPixelRgb(
            x, y, 255, 255, 255); // Set the color of the grid lines to white
      }
    }

    // Draw horizontal grid lines
    for (int y = cellHeight; y < image1.height; y += cellHeight) {
      for (int x = 0; x < image1.width; x++) {
        image1.setPixelRgb(
            x, y, 255, 255, 255); // Set the color of the grid lines to white
      }
    }

    DateTime datetime = DateTime.now();
    String dateSec = datetime.toString();

    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    final imageWithGrid = File('$tempPath/imageWithGrid$dateSec.jpg')
      ..writeAsBytesSync(img.encodeJpg(image1));

    final resizedImage3 =
        img.copyResize(image1, width: _imageWidth, height: _imageHeight);

    final tempDirc = await getTemporaryDirectory();
    final tempPathc = tempDirc.path;
    final colorchaged_img = File('$tempPathc/final$dateSec.jpg')
      ..writeAsBytesSync(img.encodeJpg(resizedImage3));

    setState(() {
      image_ = colorchaged_img;
      _isPixelated = false;
      colorsChanged =
          false; // You're not changing pixel colors, just adding grid lines
    });
    // hideProgressDialog();
    await _Selectedcolor_Extract();
  }

  Future<ColorCode> nearestColor(
      List<ColorCode> colorCodelist, int tempR, int tempG, int tempB) async {
    print("Inside nearestColor \t${colorCodelist.length}");

    ColorCode tempcode = colorCodelist[0];
    ColorCode resultCode =
        ColorCode(tempcode.getR(), tempcode.getG(), tempcode.getB());
    print(
        "array list ${tempcode.getR()}\t${tempcode.getG()}\t${tempcode.getB()}");
    int temp = sqrt(pow((tempcode.getR() - tempR), 2) +
            pow((tempcode.getG() - tempG), 2) +
            pow((tempcode.getB() - tempB), 2))
        .toInt();
    for (ColorCode code in colorCodelist) {
      int x1 = code.getR();
      int x2 = tempR;
      int y1 = code.getG();
      int y2 = tempG;
      int z1 = code.getB();
      int z2 = tempB;
      int a = sqrt(pow((x1 - x2), 2) + pow((y1 - y2), 2) + pow((z1 - z2), 2))
          .toInt();
      print("square root values:$a");
      print("temp value:$temp");
      if (a <= temp) {
        temp = a;
        resultCode = ColorCode(code.getR(), code.getG(), code.getB());
      }
    }
    print(
        "-------------------------------------------------------------------");
    return resultCode;
  }

  void _onItemButtonsTap(int index) {
    setState(() {
      twoButtonTndex = index;
    });
  }
}

////
