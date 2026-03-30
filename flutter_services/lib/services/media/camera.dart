/* Documents and Integration
https://pub.dev/packages/flutter_image_compress
https://pub.dev/packages/image_picker

IOS:
<key>NSCameraUsageDescription</key>
<string>...</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>..string>
<key>NSMicrophoneUsageDescription</key> (Video kayıt yapılacaksa gerekli)
<string>...</string>

*https://pub.dev/packages/image_cropper

Android:
# AndroidManifest.xml
<activity
  android:name="com.yalantis.ucrop.UCropActivity"
  android:screenOrientation="portrait"
  android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>

*/

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CameraService {
  static final CameraService instance = CameraService._internal();

  final String title;
  final int quality;
  final double maxWidth;
  final double maxHeight;
  final double? ratioX;
  final double? ratioY;

  CameraService._internal({
    this.title = "Fotoğraf Düzenleyici",
    this.quality = 100,
    this.maxWidth = 1080,
    this.maxHeight = 1920,
    this.ratioX,
    this.ratioY,
  });

  final _picker = ImagePicker();

  Future<File?> getImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: quality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      return null;
    }
  }

  Future<List<File>?> getMultiImage() async {
    try {
      final pickedFile = await _picker.pickMultiImage(
        imageQuality: quality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );
      if (pickedFile.isNotEmpty) {
        return pickedFile.map((e) => File(e.path)).toList();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<File?> getVideo(ImageSource source, {Duration? maxDuration}) async {
    try {
      final pickedFile = await _picker.pickVideo(
        source: source,
        preferredCameraDevice: CameraDevice.rear,
        maxDuration: maxDuration,
      );
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      return null;
    }
  }

  // #region Crop
  Future<File?> getCropImage(File file) async {
    final r = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: ratioX == null
          ? null
          : CropAspectRatio(ratioX: ratioX!, ratioY: ratioY ?? ratioX!),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: title,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: ratioX != null,
          showCropGrid: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
        IOSUiSettings(
          title: title,
          aspectRatioLockEnabled: ratioX != null,
          aspectRatioPickerButtonHidden: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
      ],
    );
    return r == null ? null : File(r.path);
  }
  // #endregion

  // #region Compress
  Future<File> autoCompressFile(File file, {int maxByte = 1048576}) async {
    File tempFile = file;
    int quality = this.quality;
    while (quality > 1) {
      int length = (await tempFile.length());
      if (length < maxByte) break;
      quality -= 1;
      tempFile = (await compressFileFromFile(file, quality: quality))!;
    }
    return tempFile;
  }

  String _getTargetPath(String path, int quality) {
    final type = path.split('.').last;
    final base = path.split('/');
    base.removeAt(base.length - 1);
    return "${base.join('/')}/${DateTime.now().millisecondsSinceEpoch}.$type";
  }

  Future<File?> compressFileFromFile(
    File file, {
    String? targetPath,
    int quality = 100,
  }) async {
    targetPath ??= _getTargetPath(file.path, quality);
    final xFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
    );

    return xFile != null ? File(xFile.path) : null;
  }

  Future<Uint8List?> compressByteFromFile(
    File file, {
    int quality = 100,
  }) async {
    return await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: quality,
    );
  }

  Future<Uint8List> compressByteFromByte(
    Uint8List list, {
    int quality = 100,
  }) async {
    return await FlutterImageCompress.compressWithList(list, quality: quality);
  }

  Future<Uint8List?> compressByteFromAsset(
    String assetName, {
    int quality = 100,
  }) async {
    return await FlutterImageCompress.compressAssetImage(
      assetName,
      quality: quality,
    );
  }
  // #endregion

  CameraService copyWith({
    String? title,
    int? quality,
    double? maxWidth,
    double? maxHeight,
    double? ratioX,
    double? ratioY,
  }) {
    return CameraService._internal(
      title: title ?? this.title,
      quality: quality ?? this.quality,
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      ratioX: ratioX,
      ratioY: ratioY,
    );
  }
}
