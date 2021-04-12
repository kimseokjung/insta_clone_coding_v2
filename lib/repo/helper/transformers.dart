import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone_coding/models/firestore/comment_model.dart';
import 'package:instagram_clone_coding/models/firestore/post_model.dart';
import 'package:instagram_clone_coding/models/firestore/user_model.dart';

class Transformers {
  // todo : DocumentSnapshot<UserModel>로 들어오는 값을 UserModel로 받기위해 변환한
  final toUser = StreamTransformer<DocumentSnapshot, UserModel>.fromHandlers(
      handleData: (snapshot, sink) async {
    sink.add(UserModel.fromSnapshot(snapshot));
  });
  final toUsersExceptMe =
      StreamTransformer<QuerySnapshot, List<UserModel>>.fromHandlers(
          handleData: (snapshot, sink) async {
    List<UserModel> users = [];

    User _firebaseUser = await FirebaseAuth.instance.currentUser;
    snapshot.docs.forEach((documentSnapshot) {
      if (_firebaseUser.uid != documentSnapshot.id)
        users.add(UserModel.fromSnapshot(documentSnapshot));
    });

    sink.add(users);
  });

  final toPosts =
      StreamTransformer<QuerySnapshot, List<PostModel>>.fromHandlers(
          handleData: (snapshot, sink) async {
    List<PostModel> posts = [];

    snapshot.docs.forEach((documentSnapshot) {
      posts.add(PostModel.fromSnapshot(documentSnapshot));
    });

    sink.add(posts);
  });

  final toComments =
  StreamTransformer<QuerySnapshot, List<CommentModel>>.fromHandlers(
      handleData: (snapshot, sink) async {
        List<CommentModel> comments = [];

        snapshot.docs.forEach((documentSnapshot) {
          comments.add(CommentModel.fromSnapshot(documentSnapshot));
        });

        sink.add(comments);
      });

  final combineListOfPosts =
      StreamTransformer<List<List<PostModel>>, List<PostModel>>.fromHandlers(
          handleData: (listOfPosts, sink) async {
    List<PostModel> posts = [];

    for(final postList in listOfPosts) {
      posts.addAll(postList);
    }

    sink.add(posts);
  });

  final latestToTop =
      StreamTransformer<List<PostModel>, List<PostModel>>.fromHandlers(
          handleData: (posts, sink) async {
    posts.sort((a, b) => b.postTime.compareTo(a.postTime));
    sink.add(posts);
  });
}
