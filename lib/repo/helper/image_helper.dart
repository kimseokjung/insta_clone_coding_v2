import 'dart:io';
import 'package:image/image.dart';

File getResizedImage(File originImage){
  // 원본 이미지를 바이트로 읽어서 오브젝트로 받아온다
  Image image = decodeImage(originImage.readAsBytesSync());
  // 이미지 사이즈를 줄임 (정사각형)
  Image reSizedImage = copyResizeCropSquare(image, 300);

  //이미지 퀄리티 줄여서 jpg파일로 저장
  //이미지 저장할땐 png였음
  File resizedFile = File(originImage.path.substring(0, originImage.path.length-3)+"jpg");
  resizedFile.writeAsBytesSync(encodeJpg(reSizedImage, quality: 50));
  return resizedFile;
}