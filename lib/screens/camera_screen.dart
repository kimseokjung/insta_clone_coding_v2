import 'package:flutter/material.dart';
import 'package:instagram_clone_coding/models/camera_state.dart';
import 'package:instagram_clone_coding/models/gellery_state.dart';
import 'package:instagram_clone_coding/widgets/my_gellery.dart';
import 'package:instagram_clone_coding/widgets/take_photo.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  CameraState _cameraState = CameraState();
  GelleryState _gelleryState = GelleryState();

  @override
  _CameraScreenState createState() {
    _cameraState.getReadyToTakePhoto();
    _gelleryState.initProvider();
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen> {
  int _currentIndex = 1;
  PageController _pageController = PageController(initialPage: 1);
  String _title = "Photo";

  @override
  void dispose() {
    _pageController.dispose();
    widget._cameraState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CameraState>.value(value: widget._cameraState),
        ChangeNotifierProvider<GelleryState>.value(value: widget._gelleryState),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title, textAlign: TextAlign.center,),
        ),
        body: PageView(
          controller: _pageController,
          children: [
            MyGellery(),
            TakePhoto(),
            Container(
              color: Colors.cyanAccent,
            ),
          ],
          onPageChanged: (index){
            setState(() {
              _currentIndex = index;
              switch(_currentIndex){
                case 0:
                  _title = "Gellery";
                  break;
                case 1:
                  _title = "Photo";
                  break;
                case 2:
                  _title = "Video";
                  break;
              }
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 0,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.black45,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.radio_button_checked), label: 'GELLERY'),
            BottomNavigationBarItem(
                icon: Icon(Icons.radio_button_checked), label: 'PHOTO'),
            BottomNavigationBarItem(
                icon: Icon(Icons.radio_button_checked), label: 'VIDEO'),
          ],
          currentIndex: _currentIndex,
          onTap: _onItemTabbed,
        ),
      ),
    );
  }

  void _onItemTabbed(index) {
    print(index);
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(_currentIndex,
          duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
    });
  }
}


