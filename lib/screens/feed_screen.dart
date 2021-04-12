import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_coding/models/firestore/post_model.dart';
import 'package:instagram_clone_coding/models/firestore/user_model.dart';
import 'package:instagram_clone_coding/repo/post_network_repository.dart';
import 'package:instagram_clone_coding/repo/user_network_repository.dart';
import 'package:instagram_clone_coding/widgets/my_progress_indicator.dart';
import 'package:instagram_clone_coding/widgets/post.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatelessWidget {
  final List<dynamic> followings;

  const FeedScreen(
    this.followings, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<PostModel>>.value(
        value: postNetworkRepository.fetchPostsFromAllFollowers(followings),
        child: Consumer<List<PostModel>>(
          builder: (context, posts, child) {
            if (posts == null || posts.isEmpty)
              return MyProgressIndicator();
            else {
              return Scaffold(
                appBar: CupertinoNavigationBar(
                  leading: IconButton(
                      onPressed: null,
                      icon: Icon(
                        CupertinoIcons.camera,
                        color: Colors.black87,
                      )),
                  middle: Text(
                    'instagram',
                    style: TextStyle(
                        fontFamily: 'VeganStyle',
                        color: Colors.black87,
                        fontSize: 24),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: ImageIcon(
                            AssetImage('assets/images/actionbar_camera.png'),
                            color: Colors.black87,
                          ),
                          onPressed: () {
                            userNetworkRepository
                                .getAllUserWithoutMe()
                                .listen((users) {
                              print(users);
                            });
                          }),
                      IconButton(
                          icon: ImageIcon(
                            AssetImage('assets/images/direct_message.png'),
                            color: Colors.black87,
                          ),
                          onPressed: () {}),
                    ],
                  ),
                ),
                body: ListView.builder(
                  itemBuilder: (context, index) =>
                      feedListBuilder(context, posts[index]),
                  itemCount: posts.length,
                ),
              );
            }
          },
        ));
  }

  Widget feedListBuilder(BuildContext context, PostModel postModel) {
    return Post(postModel);
  }
}
