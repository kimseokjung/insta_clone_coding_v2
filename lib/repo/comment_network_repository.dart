import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone_coding/constants/firestore_key.dart';
import 'package:instagram_clone_coding/models/firestore/comment_model.dart';
import 'package:instagram_clone_coding/repo/helper/transformers.dart';

class CommentNetworkRepository with Transformers {
  Future<void> createNewComment(
      String postKey, Map<String, dynamic> commentData) async {
    final DocumentReference postRef =
        FirebaseFirestore.instance.collection(COLLECTION_POSTS).doc(postKey);
    final DocumentSnapshot postSnapshot = await postRef.get();
    final DocumentReference commentRef =
        postRef.collection(COLLECTION_COMMENTS).doc();

    return FirebaseFirestore.instance.runTransaction((tx) async {
      if (postSnapshot.exists) {
        await tx.set(commentRef, commentData);

        int numOfComments = postSnapshot.data()[KEY_NUMOFCOMMENTS];
        await tx.update(postRef, {
          KEY_NUMOFCOMMENTS: numOfComments + 1,
          KEY_LASTCOMMENT: commentData[KEY_COMMENT],
          KEY_LASTCOMMENTTIME: commentData[KEY_COMMENTTIME],
          KEY_LASTCOMMENTOR: commentData[KEY_USERNAME],
        });
      }
    });
  }

  Stream<List<CommentModel>> fetchAllComment(String postKey) {
    return FirebaseFirestore.instance
        .collection(COLLECTION_POSTS)
        .doc(postKey)
        .collection(COLLECTION_COMMENTS)
        .orderBy(KEY_COMMENTTIME, descending: true) //최신순으로 정렬
        .snapshots()
        .transform(toComments);
  }
}
CommentNetworkRepository commentNetworkRepository = CommentNetworkRepository();
