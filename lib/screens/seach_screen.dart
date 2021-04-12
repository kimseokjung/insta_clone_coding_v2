import 'package:flutter/material.dart';
import 'package:instagram_clone_coding/models/firestore/user_model.dart';
import 'package:instagram_clone_coding/models/user_model_state.dart';
import 'package:instagram_clone_coding/repo/user_network_repository.dart';
import 'package:instagram_clone_coding/widgets/my_progress_indicator.dart';
import 'package:instagram_clone_coding/widgets/rounded_avatar.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: StreamBuilder<List<UserModel>>(
          stream: userNetworkRepository.getAllUserWithoutMe(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SafeArea(
                child: Consumer<UserModelState>(
                  builder: (context,UserModelState myUserModelState, child) {
                    return ListView.separated(
                        itemBuilder: (context, index) {
                          UserModel otherUser = snapshot.data[index];
                          bool amIFollowing = myUserModelState
                              .amIFollowingThisUser(otherUser.userKey);
                          return ListTile(
                            onTap: () {
                              setState(() {
                                amIFollowing
                                    ? userNetworkRepository.unFollowUser(
                                        myUserKey:
                                            myUserModelState.userModel.userKey,
                                        otherUserKey: otherUser.userKey)
                                    : userNetworkRepository.followUser(
                                        myUserKey:
                                            myUserModelState.userModel.userKey,
                                        otherUserKey: otherUser.userKey);
                              });
                            },
                            leading: RoundedAvatar(),
                            title: Text(otherUser.username),
                            subtitle:
                                Text('user bio number ${otherUser.username}'),
                            trailing: Container(
                              height: 30,
                              width: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: amIFollowing
                                    ? Colors.transparent
                                    : Colors.blue,
                                border: Border.all(
                                  color: amIFollowing
                                      ? Colors.black26
                                      : Colors.transparent,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                amIFollowing ? 'following' : 'follow',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: amIFollowing
                                        ? Colors.black87
                                        : Colors.white),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.grey,
                          );
                        },
                        itemCount: snapshot.data.length);
                  },
                ),
              );
            } else {
              return MyProgressIndicator();
            }
          }),
    );
  }
}
