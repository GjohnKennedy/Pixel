import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'EditingScreen.dart';
import 'customRadio.dart';

class ImageData {
  final String imagePath;
  bool isFavorite;

  ImageData({required this.imagePath, this.isFavorite = false});
}

List<ImageData> _favoriteImages = [];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<ImageData> _images = [
    ImageData(imagePath: "assets/images/image11.jpg"),
    ImageData(imagePath: "assets/images/image10.jpg"),
    ImageData(imagePath: "assets/images/image9.jpg"),
    ImageData(imagePath: "assets/images/image8.jpg"),
    ImageData(imagePath: "assets/images/image7.jpg"),
    ImageData(imagePath: "assets/images/image6.jpg"),
    ImageData(imagePath: "assets/images/image5.jpg"),
    ImageData(imagePath: "assets/images/image4.jpg"),
    ImageData(imagePath: "assets/images/image3.jpg"),
    ImageData(imagePath: "assets/images/image2.jpg"),
    ImageData(imagePath: "assets/images/image1.jpg"),
    ImageData(imagePath: "assets/images/image9.jpg"),
  ];

  late ScrollController _scrollController;
  bool _showTopWidget = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset == 0 && !_showTopWidget) {
        setState(() {
          _showTopWidget = true;
        });
      } else if (_scrollController.offset > 0 && _showTopWidget) {
        setState(() {
          _showTopWidget = false;
        });
      }
    });
  }

  int headerIndex = 0;
  int buttonTndex = 0;
  bool _isSelected = false;
  ImagePicker picker = ImagePicker();
  late XFile _image;

  void _onItemHeaderTap(int index) {
    setState(() {
      headerIndex = index;
    });
  }

  void _onItemButtonTap(int index) {
    setState(() {
      buttonTndex = index;
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      _images[index].isFavorite = !_images[index].isFavorite;

      if (_images[index].isFavorite) {
        _favoriteImages.add(_images[index]);
        print(_favoriteImages.length);
      } else {
        _favoriteImages.remove(_images[index]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return SafeArea(
        child: Scaffold(
            appBar: null,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          IconButton(
                            // icon: const Icon(
                            //   Icons.home_outlined,
                            //   color: Colors.black,
                            //   size: 30,
                            // ),
                            icon: Image.asset(
                              "assets/images/home.png",
                              width: 25,
                              height: 25,
                            ),
                            color: Colors.black,

                            onPressed: () {
                              // do something when the first icon button is pressed
                              log("First icon button pressed!");
                              _onItemHeaderTap(0);
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: headerIndex == 0
                                    ? Colors.red
                                    : Colors.transparent),
                            height: 2.5,
                            width: 25,
                          )
                        ],
                      ),

                      // const SizedBox(
                      //   width: 1,
                      //   height: 10,
                      // ),

                      Column(
                        children: [
                          IconButton(
                            // icon: const Icon(
                            //   Icons.add_circle_outline,
                            //   color: Colors.black,
                            //   size: 30,
                            // ),
                            icon: SvgPicture.asset(
                              'assets/images/plus-circle.svg',
                              color: Colors.black,
                              width: 24,
                              height: 24,
                            ),
                            onPressed: () {
                              // do something when the second icon button is pressed
                              log("Second icon button pressed!");
                              _onItemHeaderTap(1);
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: headerIndex == 1
                                    ? Colors.red
                                    : Colors.transparent),
                            height: 2.5,
                            width: 25,
                          )
                        ],
                      ),

                      const Spacer(),
                      TextButton.icon(
                          onPressed: () {},
                          // icon: const Icon(
                          //   Icons.shopping_bag_outlined,
                          //   color: Colors.red,
                          // ),

                          icon: SvgPicture.asset(
                            'assets/images/bag.svg',
                            color: Colors.red,
                            width: 18,
                            height: 18,
                          ),
                          label: const Text(
                            'Store',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                headerIndex == 0 ? homeTabWidgets() : addTabWidgets(),
              ],
            )));
  }

  Widget homeTabWidgets() {
    return Expanded(
      child: Column(
        children: [
          Visibility(
            visible: _showTopWidget,
            child: Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                const SizedBox(
                  width: 10,
                ),
                OutlinedButton.icon(
                    onPressed: () {
                      _onItemButtonTap(0);
                    },
                    icon: Icon(
                      Icons.star_border_outlined,
                      color: buttonTndex == 0 ? Colors.white : Colors.red,
                    ),
                    label: Text(
                      'Featured',
                      style: TextStyle(
                          fontSize: 18,
                          color: buttonTndex == 0 ? Colors.white : Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                        backgroundColor:
                            buttonTndex == 0 ? Colors.red : Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        side: BorderSide(
                            width: 1,
                            color:
                                buttonTndex == 0 ? Colors.white : Colors.red))),
                const SizedBox(
                  width: 10,
                ),
                OutlinedButton.icon(
                    onPressed: () {
                      _onItemButtonTap(1);
                    },
                    icon: Icon(
                      Icons.favorite_border,
                      color: buttonTndex == 1 ? Colors.white : Colors.red,
                    ),
                    label: Text(
                      'Saved',
                      style: TextStyle(
                          fontSize: 18,
                          color: buttonTndex == 1 ? Colors.white : Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                        backgroundColor:
                            buttonTndex == 1 ? Colors.red : Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        side: BorderSide(
                            width: 1,
                            color:
                                buttonTndex == 1 ? Colors.white : Colors.red)))
              ],
            ),
          ),
          // buildHomeGridView(),
          buttonTndex == 0 ? featureTabWidgets() : savedTabWidgets(),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget featureTabWidgets() {
    return Expanded(
      child: Column(
        children: [const SizedBox(height: 8.0), featureGridWidgets()],
      ),
    );
  }

  Widget featureGridWidgets() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: StaggeredGridView.countBuilder(
          controller: _scrollController,
          crossAxisCount: 2,
          itemCount: _images.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        // 'assets/images/image$index.jpg',
                        _images[index].imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Item $index',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _images[index].isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              _toggleFavorite(index);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          staggeredTileBuilder: (int index) =>
              StaggeredTile.count(1, index.isEven ? 1.2 : 1.8),
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 0.5,
        ),
      ),
    );
  }

  Widget savedTabWidgets() {
    return Expanded(
      child: Column(
        children: [const SizedBox(height: 20.0), savedGridView()],
      ),
    );
  }

  Widget savedGridView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: StaggeredGridView.countBuilder(
          controller: _scrollController,
          crossAxisCount: 2,
          itemCount: _favoriteImages.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        // 'assets/images/image$index.jpg',
                        _favoriteImages[index].imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          staggeredTileBuilder: (int index) =>
              StaggeredTile.count(1, index.isEven ? 1.2 : 1.8),
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 0.5,
        ),
      ),
    );
  }

  Future _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
        _image == null
            ? const Text('No image selected.')
            : Image.file(
                File(_image.path),
                height: 150.0,
                width: 150.0,
                fit: BoxFit.cover,
              );
        _navigateToEditingScreen();
      } else {
        print('No image selected.');
      }
    });
  }

  void _navigateToEditingScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditingScreen(imageFile: _image),
      ),
    );
  }

  Widget addTabWidgets() {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              OutlinedButton.icon(
                  onPressed: () {
                    _getImageFromGallery();
                    // image = await picker.pickImage(source: ImageSource.gallery);
                    // setState(() {
                    //   //update UI
                    // });
                  },
                  icon: SvgPicture.asset(
                    "assets/images/cardimage.svg",
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Upload',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  )),
              const Spacer(),
              // Radio(
              //   value: true,
              //   groupValue:,
              //   onChanged: (value) {
              //     setState(() {
              //       print(value);
              //       _isSelected = !value!;
              //     });
              //   },
              // ),

              // Radio<bool>(
              //   value: true,
              //   groupValue: _isSelected,
              //   onChanged: (bool? value) {
              //     setState(() {
              //       _isSelected = !_isSelected;
              //       print(value);
              //     });
              //   },
              // )
              // ,
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: RadioButtonPage(),
              ),
              // const Padding(
              //   padding: EdgeInsets.only(right: 10.0),
              //   child: Text(
              //     'Select',
              //     style: TextStyle(color: Colors.grey),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 320.0),
          const Text("Upload Page")
          // buildAddGridView()
        ],
      ),
    );
  }

  Widget buildHomeGridView() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(10, (index) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/home.png",
                    width: 70,
                    height: 70,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("images"),
                        SizedBox(width: 10.0),
                        Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ]),
          );
        }),
      ),
    );
  }

  Widget buildAddGridView() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        children: List.generate(10, (index) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/shopping-bag.png",
                    width: 70,
                    height: 70,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          " imagenames",
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(width: 10.0),
                        Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ]),
          );
        }),
      ),
    );
  }
}
