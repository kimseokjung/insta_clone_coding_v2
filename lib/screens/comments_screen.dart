import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_coding/constants/common_size.dart';
import 'package:instagram_clone_coding/models/firestore/comment_model.dart';
import 'package:instagram_clone_coding/models/firestore/post_model.dart';
import 'package:instagram_clone_coding/models/firestore/user_model.dart';
import 'package:instagram_clone_coding/models/user_model_state.dart';
import 'package:instagram_clone_coding/repo/comment_network_repository.dart';
import 'package:instagram_clone_coding/widgets/comment.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final PostModel postModel;

  const CommentsScreen(this.postModel, {
    Key key,
  }) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController _textEditingController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: common_gap, vertical: common_xxs_gap),
                child: Comment(
                  showImage: true,
                  username: widget.postModel.username,
                  text: widget.postModel.caption,
                  dateTime: widget.postModel.postTime,
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[300],
            ),
            Expanded(
              child: StreamProvider.value(
                value: commentNetworkRepository.fetchAllComment(widget.postModel.postKey),
                child: Consumer<List<CommentModel>>(
                  builder: (context, comments, child) {
                    return ListView.separated(reverse: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: common_xxs_gap,
                                horizontal: common_gap),
                            child: Comment(
                              username: comments[index].username,
                              text: comments[index].comment,
                              dateTime: comments[index].commentTime,
                              showImage: true,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: common_xxs_gap,
                          );
                        },
                        itemCount: comments == null ? 0 : comments.length);
                  },
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[200],
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: common_gap),
                      child: TextFormField(
                        autofocus: true,
                        controller: _textEditingController,
                        cursorColor: Colors.black54,
                        decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            border: InputBorder.none,
                            contentPadding:
                            new EdgeInsets.symmetric(vertical: common_xxs_gap)),
                        validator: (String value) {
                          if (value.isEmpty)
                            return 'Input something';
                          else
                            return null;
                        },
                      ),
                    )),
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      UserModel userModel =
                          Provider
                              .of<UserModelState>(context, listen: false)
                              .userModel;
                      Map<String, dynamic> newComment =
                      CommentModel.getMapForNewComment(
                          userModel.userKey,
                          userModel.username,
                          _textEditingController.text.toString().trim());
                      await commentNetworkRepository.createNewComment(
                          widget.postModel.postKey, newComment);
                      _textEditingController.clear();
                    }
                  },
                  child: Text('Post'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
