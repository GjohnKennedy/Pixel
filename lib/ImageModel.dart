import 'package:hive/hive.dart';

part 'ImageModel.g.dart';

@HiveType(typeId: 0)
class ImageModel extends HiveObject {
  @HiveField(0)
  late String image;

  @HiveField(1)
  late List<CropDetails> cropDetails;

  @HiveField(2)
  late List<ViewCustom> colorDetails;

  @HiveField(3) // New field
  late String imageName;

  ImageModel({
    required this.image,
    required this.cropDetails,
    required this.colorDetails,
    required this.imageName,
  });
}

@HiveType(typeId: 1)
class CropDetails extends HiveObject {
  @HiveField(0)
  late String cropName;

  @HiveField(1)
  late double xx;

  @HiveField(2)
  late double yy;

  CropDetails({required this.cropName, required this.xx, required this.yy});
}

@HiveType(typeId: 2)
class ViewCustom extends HiveObject {
  @HiveField(0)
  String addViewColor;
  @HiveField(1)
  int color_count;
  ViewCustom({
    required this.addViewColor,
    required this.color_count,
  });
}
