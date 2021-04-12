import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone_coding/constants/firestore_key.dart';
import 'package:instagram_clone_coding/repo/helper/transformers.dart';
import 'package:instagram_clone_coding/models/firestore/post_model.dart';
import 'package:rxdart/rxdart.dart';

class PostNetworkRepository with Transformers {
  Future<Map<String, dynamic>> createNewPost(String postKey,
      Map<String, dynamic> postData) async {
    final DocumentReference postRef =
    FirebaseFirestore.instance.collection(COLLECTION_POSTS).doc(postKey);
    final DocumentSnapshot postSnapshot = await postRef.get();
    final DocumentReference userRef = FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .doc(postData[KEY_USERKEY]);

    return FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      if (!postSnapshot.exists) {
        await tx.set(postRef, postData);
        await tx.update(userRef, {
          KEY_MYPOSTS: FieldValue.arrayUnion([postKey])
        });
      }
    });
  }

  Future<void> updatePostImageUrl({String postImg, String postKey}) async {
    final DocumentReference postRef =
    FirebaseFirestore.instance.collection(COLLECTION_POSTS).doc(postKey);
    final DocumentSnapshot postSnapshot = await postRef.get();

    if (postSnapshot.exists) {
      await postRef.update({KEY_POSTIMG: postImg});
    }
  }

  Stream<List<PostModel>> getPostFromSpecificUser(String userKey) {
    return FirebaseFirestore.instance
        .collection(COLLECTION_POSTS)
        .where(KEY_USERKEY, isEqualTo: userKey)
        .snapshots()
        .transform(toPosts);
  }

  Stream<List<PostModel>> fetchPostsFromAllFollowers(List<dynamic> followings) {
    final CollectionReference collectionReference = FirebaseFirestore.instance
        .collection(COLLECTION_POSTS);
    List<Stream<List<PostModel>>> streams = [];

    for (final following in followings) {
      streams.add(collectionReference.where(KEY_USERKEY, isEqualTo: following)
          .snapshots()
          .transform(toPosts));
    }
    return CombineLatestStream.list<List<PostModel>>(streams)
        .transform(combineListOfPosts)
        .transform(latestToTop);
  }

  Future<void> toggleLike(String postKey, String userKey) async{
    final DocumentReference postRef = FirebaseFirestore.instance.collection(COLLECTION_POSTS).doc(postKey);
    final DocumentSnapshot postSnapshot = await postRef.get();

    if(postSnapshot.exists){
      if(postSnapshot.data()[KEY_NUMOFLIKES].contains(userKey)){
        //yes
        postRef.update({KEY_NUMOFLIKES: FieldValue.arrayRemove([userKey])});
      }else {
        //no
        postRef.update({KEY_NUMOFLIKES: FieldValue.arrayUnion([userKey])});
      }
    }
  }
}

PostNetworkRepository postNetworkRepository = PostNetworkRepository();

/*
  Post Data upload procedure

  1. get Post reference(create)
  2. get User reference
  3. open transaction
  4. update postKey into user data
  5. upload post data to post reference
 */
