// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ImageModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ImageModelAdapter extends TypeAdapter<ImageModel> {
  @override
  final int typeId = 0;

  @override
  ImageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageModel(
      image: fields[0] as String,
      cropDetails: (fields[1] as List).cast<CropDetails>(),
      colorDetails: (fields[2] as List).cast<ViewCustom>(),
      imageName: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ImageModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.cropDetails)
      ..writeByte(2)
      ..write(obj.colorDetails)
      ..writeByte(3)
      ..write(obj.imageName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CropDetailsAdapter extends TypeAdapter<CropDetails> {
  @override
  final int typeId = 1;

  @override
  CropDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CropDetails(
      cropName: fields[0] as String,
      xx: fields[1] as double,
      yy: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CropDetails obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.cropName)
      ..writeByte(1)
      ..write(obj.xx)
      ..writeByte(2)
      ..write(obj.yy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CropDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ViewCustomAdapter extends TypeAdapter<ViewCustom> {
  @override
  final int typeId = 2;

  @override
  ViewCustom read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ViewCustom(
      addViewColor: fields[0] as String,
      color_count: fields[1] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, ViewCustom obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.addViewColor)
      ..writeByte(1)
      ..write(obj.color_count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ViewCustomAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
