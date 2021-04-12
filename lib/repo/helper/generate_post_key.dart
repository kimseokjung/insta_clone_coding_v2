import 'package:instagram_clone_coding/models/firestore/user_model.dart';

String getNewPostKey(UserModel userModel) =>
    "${DateTime.now().microsecondsSinceEpoch}_${userModel.userKey}";
