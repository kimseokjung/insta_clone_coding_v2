import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_coding/constants/screen_size.dart';
import 'package:instagram_clone_coding/models/camera_state.dart';
import 'package:instagram_clone_coding/models/user_model_state.dart';
import 'package:instagram_clone_coding/repo/helper/generate_post_key.dart';
import 'package:instagram_clone_coding/screens/share_post_screen.dart';
import 'package:instagram_clone_coding/widgets/my_progress_indicator.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class TakePhoto extends StatefulWidget {
  const TakePhoto({
    Key key,
  }) : super(key: key);

  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  CameraController _controller;
  Widget _progress = MyProgressIndicator();

  @override
  Widget build(BuildContext context) {
    // ignore: missing_required_param
    return Consumer <CameraState>(
        builder: (BuildContext context, CameraState cameraState, Widget child) {
          return Column(
            children: [
              Container(
                width: size.width,
                height: size.width,
                color: Colors.black,
                child:
                (cameraState.isReadyToTakePhoto)
                    ? _getPreview(cameraState)
                    : _progress,
              ),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if(cameraState.isReadyToTakePhoto){
                      _attemptTakePhoto(cameraState,context);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                      minimumSize: Size(100, 100),
                      shape: CircleBorder(),
                      side: BorderSide(color: Colors.black12, width: 20)), child: null,
                ),
              )
            ],
          );
        }
    );
  }

  void _attemptTakePhoto(CameraState cameraState, BuildContext context) async{
    final String postKey = getNewPostKey(Provider.of<UserModelState>(context, listen: false).userModel);
    try{
      // final path = join((await getTemporaryDirectory()).path, '$postKey.png');

      XFile file  = await cameraState.controller.takePicture();
      // file.saveTo(path);
      File imageFile = File(file.path);
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => SharePostScreen(imageFile, postKey: postKey,)));
    }catch(e){

    }
  }
}

Widget _getPreview(CameraState cameraState) {
  return ClipRect(
    child: OverflowBox(
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Container(
          width: size.width,
          height: size.width * cameraState.controller.value.aspectRatio ,
          child: CameraPreview(cameraState.controller),
        ),
      ),
    ),
  );
}
