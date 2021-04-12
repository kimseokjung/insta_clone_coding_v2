import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instagram_clone_coding/constants/common_size.dart';
import 'package:instagram_clone_coding/constants/screen_size.dart';
import 'package:instagram_clone_coding/models/firestore/post_model.dart';
import 'package:instagram_clone_coding/models/user_model_state.dart';
import 'package:instagram_clone_coding/repo/post_network_repository.dart';
import 'package:instagram_clone_coding/screens/comments_screen.dart';
import 'package:instagram_clone_coding/widgets/comment.dart';
import 'package:instagram_clone_coding/widgets/my_progress_indicator.dart';
import 'package:instagram_clone_coding/widgets/rounded_avatar.dart';
import 'package:provider/provider.dart';

class Post extends StatelessWidget {
  final PostModel postModel;

  Post(
    this.postModel, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _postHeader(context),
        _postImage(),
        _postActions(context),
        _postLikes(),
        _postCaption(),
        _moreComments(context),
        _lastComment(),
      ],
    );
  }

  Widget _postCaption() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: common_gap, vertical: common_xxs_gap),
      child: Comment(
        showImage: false,
        username: postModel.username,
        text: postModel.caption,
      ),
    );
  }

  Widget _lastComment() {
    return Padding(
      padding: const EdgeInsets.only(
          left: common_gap, right: common_gap, top: common_xxs_gap),
      child: Comment(
        showImage: false,
        username: postModel.lastCommentor,
        text: postModel.lastComment,
      ),
    );
  }

  Padding _postLikes() {
    return Padding(
        padding: EdgeInsets.only(left: common_gap),
        child: Text(
          '${postModel.numOfLikes == null ? 0 : postModel.numOfLikes.length} likes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ));
  }

  Row _postActions(BuildContext context) {
    return Row(
      children: [
        Consumer<UserModelState>(
          builder: (context, userModelState, child) {
            return IconButton(
                icon: postModel.numOfLikes
                        .contains(userModelState.userModel.userKey)
                    ? ImageIcon(
                        AssetImage(
                          'assets/images/heart_selected.png',
                        ),
                        color: Colors.red,
                      )
                    : ImageIcon(AssetImage(
                        'assets/images/heart.png',
                      )),
                color: Colors.black87,
                iconSize: icon_size,
                onPressed: () {
                  postNetworkRepository.toggleLike(
                      postModel.postKey, userModelState.userModel.userKey);
                });
          },
        ),
        IconButton(
            icon: ImageIcon(AssetImage('assets/images/comment.png')),
            color: Colors.black87,
            iconSize: icon_size,
            onPressed: () {
              _goToComments(context);
            }),
        IconButton(
            icon: ImageIcon(AssetImage('assets/images/direct_message.png')),
            color: Colors.black87,
            iconSize: icon_size,
            onPressed: null),
        Spacer(),
        IconButton(
            icon: ImageIcon(AssetImage('assets/images/bookmark.png')),
            color: Colors.black87,
            iconSize: icon_size,
            onPressed: null),
      ],
    );
  }

  Widget _postHeader(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(common_xxs_gap),
          child: RoundedAvatar(),
        ),
        Expanded(child: Text(postModel.username,style: Theme.of(context).textTheme.subtitle2,)),
        IconButton(
            icon: Icon(Icons.more_horiz),
            color: Colors.black87,
            onPressed: null)
      ],
    );
  }

  Widget _postImage() {
    Widget progress = MyProgressIndicator(
      containerSize: size.width,
    );

    return CachedNetworkImage(
      imageUrl: postModel.postImg,
      placeholder: (BuildContext context, String url) {
        return progress;
      },
      imageBuilder: (BuildContext context, ImageProvider imageProvider) {
        return AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
                image:
                    DecorationImage(image: imageProvider, fit: BoxFit.cover)),
          ),
        );
      },
    );
  }

  Widget _moreComments(BuildContext context) {
    return Visibility(
      visible:
          (postModel.numOfComments != null || postModel.numOfComments >= 2),
      child: GestureDetector(
        onTap: () {
          _goToComments(context);
        },
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: common_gap, vertical: 2),
          child: Text(
            "${postModel.numOfComments} more comments...",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  _goToComments(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return CommentsScreen(postModel);
      },
    ));
  }
}
