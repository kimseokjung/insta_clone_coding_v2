import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_coding/models/gellery_state.dart';
import 'package:instagram_clone_coding/models/user_model_state.dart';
import 'package:instagram_clone_coding/repo/helper/generate_post_key.dart';
import 'package:instagram_clone_coding/screens/share_post_screen.dart';
import 'package:local_image_provider/device_image.dart';
import 'package:local_image_provider/local_image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class MyGellery extends StatefulWidget {
  @override
  _MyGelleryState createState() => _MyGelleryState();
}

class _MyGelleryState extends State<MyGellery> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GelleryState>(
      builder: (context, GelleryState gelleryState, child) {
        return GridView.count(
          crossAxisCount: 3,
          children: getImages(context, gelleryState),
        );
      },
    );
  }

  List<Widget> getImages(BuildContext context, GelleryState gelleryState) {
    return gelleryState.images
        .map((localImage) => InkWell(
              onTap: () async {
                Uint8List bytes = await localImage.getScaledImageBytes(
                    gelleryState.localImageProvider, 0.3);

                final String postKey = getNewPostKey(Provider.of<UserModelState>(context, listen: false).userModel);
                try {
                  final path = join(
                      (await getTemporaryDirectory()).path, '$postKey.png');
                  File imageFile = File(path)..writeAsBytesSync(bytes);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => SharePostScreen(imageFile, postKey: postKey,)));
                } catch (e) {}
              },
              child: Image(
                image: DeviceImage(localImage, scale: 0.2),
                fit: BoxFit.cover,
              ),
            ))
        .toList();
  }

}
