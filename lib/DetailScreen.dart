// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:from_css_color/from_css_color.dart';
// import 'package:pixel/ImageModel.dart';
//
// class DetailsScreen extends StatelessWidget {
//   final ImageModel imageModel;
//
//   const DetailsScreen({required this.imageModel});
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: SafeArea(
//         child: Scaffold(
//           body: CustomScrollView(
//             slivers: [
//               SliverAppBar(
//                 backgroundColor: Colors.red,
//                 leading: IconButton(
//                   icon: Icon(Icons.arrow_back),
//                   color: Colors.black,
//                   onPressed: () {
//                     Navigator.pop(
//                         context); // Navigate back when the back arrow is pressed
//                   },
//                 ),
//                 title: Text(
//                   '${imageModel.imageName}',
//                   style: const TextStyle(
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 pinned: true,
//               ),
//               SliverList(
//                 delegate: SliverChildListDelegate([
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         PageRouteBuilder(
//                           opaque: false,
//                           pageBuilder: (BuildContext context, _, __) {
//                             return Scaffold(
//                               backgroundColor: Colors.black,
//                               body: Center(
//                                 child: Hero(
//                                   tag:
//                                   'imageTag', // Unique tag for the Hero widget
//                                   child: Image.file(
//                                     File(imageModel.image),
//                                     fit: BoxFit.contain,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(0),
//                       child: Hero(
//                         tag:
//                         'imageTag', // Same tag as used in the full screen view
//                         child: Container(
//                           width: 350,
//                           height: 350,
//                           child: Image.file(
//                             File(imageModel.image),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),
//                   Padding(
//                     padding: const EdgeInsets.all(2.0),
//                     child: const Text(
//                       'Crop Details',
//                       style: TextStyle(
//                           fontSize: 18.0, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   for (final cropDetail in imageModel.cropDetails)
//                     ListTile(
//                       // title: Text(cropDetail.cropName),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('X: ${cropDetail.xx}'),
//                           Text('Y: ${cropDetail.yy}'),
//                         ],
//                       ),
//                     ),
//                   const SizedBox(height: 16.0),
//
//                   // Rest of the code...
//                   Padding(
//                     padding: const EdgeInsets.all(2.0),
//                     child: const Text(
//                       "Used Pixel's",
//                       style: TextStyle(
//                           fontSize: 18.0, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       width: double.maxFinite,
//                       height: 290,
//                       child: GridView.builder(
//                         gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 5,
//                           mainAxisSpacing: 0,
//                           crossAxisSpacing: 0,
//                           childAspectRatio: 1,
//                         ),
//                         itemCount: imageModel.colorDetails.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           return GestureDetector(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(0),
//                                 color: fromCssColor(
//                                   imageModel.colorDetails[index].addViewColor,
//                                 ),
//                                 border: Border.all(color: Colors.transparent),
//                               ),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "${imageModel.colorDetails[index].color_count}",
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ]),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//
//     return SafeArea(
//       child: Scaffold(
//         body: CustomScrollView(
//           slivers: [
//             SliverAppBar(
//               backgroundColor: Colors.red,
//               leading: IconButton(
//                 icon: Icon(Icons.arrow_back),
//                 color: Colors.black,
//                 onPressed: () {
//                   Navigator.pop(
//                       context); // Navigate back when the back arrow is pressed
//                 },
//               ),
//               title: Text(
//                 '${imageModel.imageName}',
//                 style: const TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               pinned: true,
//             ),
//             SliverList(
//               delegate: SliverChildListDelegate([
//                 Padding(
//                   padding: const EdgeInsets.all(0),
//                   child: Container(
//                     width: 350,
//                     height: 350,
//                     child: Image.file(
//                       File(imageModel.image),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 Padding(
//                   padding: const EdgeInsets.all(2.0),
//                   child: const Text(
//                     'Crop Details',
//                     style:
//                     TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 for (final cropDetail in imageModel.cropDetails)
//                   ListTile(
//                     // title: Text(cropDetail.cropName),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('X: ${cropDetail.xx}'),
//                         Text('Y: ${cropDetail.yy}'),
//                       ],
//                     ),
//                   ),
//                 const SizedBox(height: 16.0),
//                 Padding(
//                   padding: const EdgeInsets.all(2.0),
//                   child: const Text(
//                     "Used Pixel's",
//                     style:
//                     TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     width: double.maxFinite,
//                     height: 290,
//                     child: GridView.builder(
//                       gridDelegate:
//                       const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 5,
//                         mainAxisSpacing: 0,
//                         crossAxisSpacing: 0,
//                         childAspectRatio: 1,
//                       ),
//                       itemCount: imageModel.colorDetails.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return GestureDetector(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(0),
//                               color: fromCssColor(
//                                 imageModel.colorDetails[index].addViewColor,
//                               ),
//                               border: Border.all(color: Colors.transparent),
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "${imageModel.colorDetails[index].color_count}",
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
