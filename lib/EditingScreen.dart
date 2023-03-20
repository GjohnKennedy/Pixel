import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditingScreen extends StatefulWidget {
  XFile imageFile;

  EditingScreen({super.key, required this.imageFile});

  @override
  _EditingScreenState createState() => _EditingScreenState();
}

class Palette {
  String qnt;
  int size;
  Palette({required this.qnt, required this.size});
}

class _EditingScreenState extends State<EditingScreen> {
  int twoButtonTndex = 0;

  int _selectedIndex = -1;

  void _onItemButtonsTap(int index) {
    setState(() {
      twoButtonTndex = index;
    });
  }

  List<Palette> palette = [];

  final nameController = TextEditingController();
  final ageController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    palette.add(Palette(qnt: "1", size: 1));
    palette.add(Palette(qnt: "2", size: 1));
    palette.add(Palette(qnt: "3", size: 1));
    palette.add(Palette(qnt: "3", size: 1));
  }

  _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Pallete"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: "Qnt"),
              ),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Size"),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  palette.add(
                    Palette(
                      qnt: nameController.text,
                      size: int.parse(ageController.text),
                    ),
                  );
                });
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            Container(
              color: Colors.white.withOpacity(0.4),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                      ),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.pop(context);
                        // do something when the first icon button is pressed
                      },
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 100,
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
                          // Action to perform when the button is pressed
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
            const Spacer(),
            /* Expanded(
              child: widget.imageFile == null
                  ? Text('No image selected.')
                  : Image.file(File(widget.imageFile.path)),
            ),*/
            Container(
              color: Colors.white.withOpacity(0.4),
              child: Row(
                children: <Widget>[
// First button
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
                        colorFilter:
                            ColorFilter.mode(Colors.white, BlendMode.srcIn),

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
            twoButtonTndex == 0 ? pixelContainer() : palleteContainer(),
          ],
        ),
      ),
    ));
  }

  Widget palleteContainer() {
    return Container(
      color: Colors.white.withOpacity(0.4),
      height: 120,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ListView.builder(
                  itemCount: palette.length,
                  itemBuilder: (BuildContext context, int index) {
                    // return editImageCard(persons[index].name);
                  },
                ),
                // editImageCard("", "16x16 pixel"),
              ],
            ),
          ),
          customCard("Add Pallete"),
          // const SizedBox(
          //   height: 20.0,
          // ),
        ],
      ),
    );
  }

  Widget pixelContainer() {
    return Container(
      color: Colors.white.withOpacity(0.4),
      height: 120,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: palette.length,
                itemBuilder: (context, index) {
                  return index == palette.length - 1
                      ? customCard("Add")
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                            Fluttertoast.showToast(
                                msg: "Selected item: ${palette[index].qnt}");
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            child: Card(
                              elevation: 10.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  color: _selectedIndex == index
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
                                      palette[index].qnt,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    const Text(
                                      "Tiles",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      "pixels",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
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

  Widget editImageCard(String headerText) {
    return Container(
      width: 100,
      height: 100,
      child: Card(
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                headerText,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 2,
              ),
              const Text(
                "Tiles",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "pixels",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
