import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/media/camera.dart';
import '../../main.dart';
import 'c_bottom_sheet.dart';

class CameraBS extends CBottomSheet {
  void Function(File? file)? callback;
  bool activeVideo;
  double? ratioX;
  double? ratioY;
  List<CBottomSheetItem>? extraItemList;

  CameraBS({
    this.callback,
    this.activeVideo = false,
    this.ratioX,
    this.ratioY,
    this.extraItemList,
  }) : super(
         isExpanded: false,
         itemList: [
           CBottomSheetItem(
             icon: Icon(Icons.camera_alt_rounded),
             title: "Kamera",
             onTap: () async {
               navigatorKey.currentState?.pop();
               File? file;
               file = await CameraService.instance.getImage(ImageSource.camera);
               if (file != null) {
                 file = await CameraService.instance
                     .copyWith(ratioX: ratioX, ratioY: ratioY)
                     .getCropImage(file);
               }
               callback?.call(file);
             },
           ),
           CBottomSheetItem(
             icon: Icon(Icons.photo_library_rounded),
             title: "Galeri",
             onTap: () async {
               navigatorKey.currentState?.pop();
               File? file;
               file = await CameraService.instance.getImage(
                 ImageSource.gallery,
               );
               if (file != null) {
                 file = await CameraService.instance
                     .copyWith(ratioX: ratioX, ratioY: ratioY)
                     .getCropImage(file);
               }
               callback?.call(file);
             },
           ),
           if (activeVideo)
             CBottomSheetItem(
               icon: Icon(Icons.video_collection_rounded),
               title: "Video",
               onTap: () async {
                 navigatorKey.currentState?.pop();
                 final f = await CameraService.instance.getVideo(
                   ImageSource.gallery,
                 );
                 callback?.call(f);
               },
             ),
           if (extraItemList != null) ...extraItemList,
         ],
       );
}
