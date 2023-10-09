import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixel/ImageModel.dart';
import 'package:pixel/detail.dart';

import 'EditingScreen.dart';
import 'customRadio.dart';

class ImageData {
  final String imagePath;
  bool isFavorite;

  ImageData({required this.imagePath, this.isFavorite = false});
}

List<ImageData> _favoriteImages = [];

class HomePage extends StatefulWidget {
  // final List<File> imagesL;

  const HomePage({Key? key}) : super(key: key);
  // const HomePage({super.key, required this.imagesL});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<dynamic> imageBox;

  // List<File> LocalImage = [];
  List<File> imagesL = [];

  bool isSelected = false;

  final RadioButtonPage radioButtonPage = RadioButtonPage();

  // RadioButtonPage radioButtonPage = RadioButtonPage();

  final List<ImageData> _images = [
    // ImageData(imagePath: "assets/images/image11.jpg"),
    // ImageData(imagePath: "assets/images/image10.jpg"),
    // ImageData(imagePath: "assets/images/image9.jpg"),
    // ImageData(imagePath: "assets/images/image8.jpg"),
    // ImageData(imagePath: "assets/images/image7.jpg"),
    // ImageData(imagePath: "assets/images/image6.jpg"),
    // ImageData(imagePath: "assets/images/image5.jpg"),
    // ImageData(imagePath: "assets/images/image4.jpg"),
    // ImageData(imagePath: "assets/images/image3.jpg"),
    // ImageData(imagePath: "assets/images/image2.jpg"),
    // ImageData(imagePath: "assets/images/image1.jpg"),
    // ImageData(imagePath: "assets/images/image9.jpg"),
    ImageData(imagePath: "assets/images/dino.jpg"),
    ImageData(imagePath: "assets/images/tiger.jpg"),
    ImageData(imagePath: "assets/images/ship.jpg"),
    ImageData(imagePath: "assets/images/Lion.jpg"),
    ImageData(imagePath: "assets/images/heart.jpg"),
    ImageData(imagePath: "assets/images/monkey.jpg"),
    ImageData(imagePath: "assets/images/watermelon.jpg"),
    ImageData(imagePath: "assets/images/butterfly.jpg"),
    // ImageData(imagePath: "assets/images/image3.jpg"),
    // ImageData(imagePath: "assets/images/image2.jpg"),
    // ImageData(imagePath: "assets/images/image1.jpg"),
    // ImageData(imagePath: "assets/images/image9.jpg"),
  ];

  late ScrollController _scrollController;
  late ScrollController _scrollController1;
  bool _showTopWidget = true;
  bool _showTopWidget1 = true;

  @override
  void initState() {
    super.initState();
    imageBox = Hive.box<dynamic>('images');
    // openImageBox();
    // retrieveImages();
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
    _scrollController1 = ScrollController();
    _scrollController1.addListener(() {
      if (_scrollController1.offset == 0 && !_showTopWidget1) {
        setState(() {
          _showTopWidget1 = true;
        });
      } else if (_scrollController1.offset > 0 && _showTopWidget1) {
        setState(() {
          _showTopWidget1 = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // Close the image box when the screen is disposed
    // imageBox.close();
    super.dispose();
  }

  // Future<void> openImageBox() async {
  //   // Open the image box
  //   imageBox = await Hive.openBox<dynamic>('images');
  // }

  Future<void> _deleteImage(int index) async {
    final imageModel = imageBox.getAt(index) as ImageModel;
    final imageFile = File(imageModel.image);

    await imageFile.delete(); // Delete the actual image file

    print("Deleted image file ${imageFile.path}");
    // Remove the item from the Hive database
    imageBox.deleteAt(index);

    // Refresh the UI
    setState(() {});
  }

  // Future<void> retrieveImages() async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final files = directory.listSync();
  //
  //   setState(() {
  //     imagesL = files
  //         .where((file) => file.path.endsWith('.png'))
  //         .map((file) => File(file.path))
  //         .toList();
  //   });
  //   print("home imageL");
  //   print(imagesL.length);
  // }

  int headerIndex = 0;
  int buttonTndex = 0;

  ImagePicker picker = ImagePicker();
  late File _image;

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
      } else {
        _favoriteImages.remove(_images[index]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return SafeArea(
      //     child: WillPopScope(
      //   onWillPop: () async {
      //     // Exit the app when back button is pressed on the HomePage
      //     SystemNavigator.pop();
      //     return true; // Returning true will allow the app to exit
      //   },
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
          )),
    );
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
            return GestureDetector(
              onDoubleTap: () {
                setState(() {
                  if (index >= 0 && index < _images.length) {
                    _toggleFavorite(index);
                  }
                });
              },
              child: Card(
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
                            'Art $index',
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
                                if (index >= 0 && index < _images.length) {
                                  _toggleFavorite(index);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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

  Widget LocalTabWidgets() {
    return Expanded(
      child: Column(
        children: [const SizedBox(height: 20.0), LocalGridView()],
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

  Widget LocalGridView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ValueListenableBuilder(
          valueListenable: imageBox.listenable(),
          builder: (context, Box<dynamic> box, _) {
            final imageModels = box.values.toList();
            // Image.file(
            //   File(imageModel.image),
            //   fit: BoxFit.contain,
            // ),
            if (imageModels.isEmpty) {
              return const Center(
                child: Text(
                  'Art is Empty',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }
            return StaggeredGridView.countBuilder(
              controller: _scrollController,
              crossAxisCount: 2,
              itemCount: imageModels.length,
              itemBuilder: (BuildContext context, int index) {
                final imageModel = imageModels[index] as ImageModel;
                print(imageModel.image); // Print the image path

                return GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            side: BorderSide(width: 3.0, color: Colors.red),
                          ),
                          title: const Text('Delete Image'),
                          content: const Text(
                              'Are you sure you want to delete this image?'),
                          actions: <Widget>[
                            SizedBox(
                              width: 80,
                              child: ElevatedButton(
                                child: const Text('Cancel'),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
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
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    side: const BorderSide(
                                        width: 1, color: Colors.red)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _deleteImage(index);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailsScreen(imageModel: imageModel),
                      ),
                    );
                    // Handle image selection or any other action
                  },
                  child: Card(
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
                            child: Image.file(
                              File(imageModel.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(18),
                        //     child: Stack(
                        //       fit: StackFit.expand,
                        //       children: [
                        //         Image.file(
                        //           File(imageModel.image),
                        //           fit: BoxFit.cover,
                        //         ),
                        //         // Add any additional widgets or overlays here
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              },
              staggeredTileBuilder: (int index) =>
                  StaggeredTile.count(1, index.isEven ? 1.2 : 1.8),
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 0.5,
            );
          },
        ),
      ),
    );
    // Return a default non-null widget (Container) if null is encountered
  }

  // Widget LocalGridView() {
  //   return Expanded(
  //     child: Padding(
  //       padding: const EdgeInsets.all(2.0),
  //
  //         child:  StaggeredGridView.countBuilder(
  //             controller: _scrollController,
  //             crossAxisCount: 2,
  //             itemCount: imagesL.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               return Card(
  //                 elevation: 0,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(2),
  //                 ),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.stretch,
  //                   children: [
  //                     Expanded(
  //                       child: ClipRRect(
  //                         borderRadius: BorderRadius.circular(18),
  //                         child: Stack(
  //                           fit: StackFit.expand,
  //                           children: [
  //                             Image.file(imagesL[index], fit: BoxFit.cover),
  //                             if (isSelected)
  //                               Align(
  //                                 alignment: Alignment.topRight,
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Container(
  //                                     decoration: const BoxDecoration(
  //                                       shape: BoxShape.circle,
  //                                       color: Colors.red,
  //                                     ),
  //                                     child: const Icon(Icons.check,
  //                                         size: 14, color: Colors.black),
  //                                   ),
  //                                 ),
  //                               ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             },
  //             staggeredTileBuilder: (int index) =>
  //                 StaggeredTile.count(1, index.isEven ? 1.2 : 1.8),
  //             mainAxisSpacing: 1.0,
  //             crossAxisSpacing: 0.5,
  //           )
  //
  //     ),
  //   );
  // }

  Future _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _image == null
            ? const Text('No image selected.')
            : Image.file(
                File(_image.path),
                height: 150.0,
                width: 150.0,
                fit: BoxFit.cover,
              );
        _navigateToEditingScreen();
      } else {}
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
          Visibility(
            visible: _showTopWidget,
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                OutlinedButton.icon(
                    onPressed: () {
                      _getImageFromGallery();
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
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: RadioButtonPage(),
                ),
              ],
            ),
          ),
          // const SizedBox(height: 0),
          // const Text("Upload Pages")

          // buildAddGridView()
          // imagesL.isEmpty ? const Text("Upload Page") : LocalTabWidgets()
          LocalTabWidgets()
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
}
