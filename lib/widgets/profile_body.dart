import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_coding/constants/common_size.dart';
import 'package:instagram_clone_coding/constants/screen_size.dart';
import 'package:instagram_clone_coding/models/user_model_state.dart';
import 'package:instagram_clone_coding/screens/profile_screen.dart';
import 'package:instagram_clone_coding/widgets/rounded_avatar.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatefulWidget {
  final Function() onMenuChanged;
  final UserModelState userModelState;

  const ProfileBody(
    this.userModelState, {
    Key key,
    this.onMenuChanged,
  }) : super(key: key);

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody>
    with SingleTickerProviderStateMixin {
  SelectedTab _isSelected = SelectedTab.left;
  double _leftImageMargin = 0;
  double _rightImageMargin = size.width;
  AnimationController _iconAnimationController;

  @override
  void initState() {
    _iconAnimationController =
        AnimationController(vsync: this, duration: duration);
    super.initState();
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModelState userModelState = Provider.of<UserModelState>(context);
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _appbar(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(common_gap),
                        child: RoundedAvatar(
                          size: 80,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: common_gap),
                          child: Table(
                            children: [
                              TableRow(children: [
                                _valueText(
                                    '${userModelState.userModel.myPosts.length}'),
                                _valueText(
                                    '${userModelState.userModel.followers}'),
                                _valueText(
                                    '${userModelState.userModel.followings.length}'),
                              ]),
                              TableRow(children: [
                                _labelText('Post'),
                                _labelText('Followers'),
                                _labelText('Following'),
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  _userbio(),
                  _editProfileBtn(),
                  _tabButtons(),
                  _selectedIndicator(),
                ])),
                _imagePager()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _appbar() {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]))),
      child: Row(
        children: [
          SizedBox(
            width: common_gap,
          ),
          Expanded(child: _username(context)),
          IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: _iconAnimationController,
              ),
              onPressed: () {
                widget.onMenuChanged();
                _iconAnimationController.status == AnimationStatus.completed
                    ? _iconAnimationController.reverse()
                    : _iconAnimationController.forward();
              }),
        ],
      ),
    );
  }

  Text _valueText(String value) => Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      );

  Padding _labelText(String value) => Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
        ),
      );

  SliverToBoxAdapter _imagePager() {
    return SliverToBoxAdapter(
        child: Stack(children: [
      AnimatedContainer(
        duration: duration,
        transform: Matrix4.translationValues(_leftImageMargin, 0, 0),
        curve: Curves.fastOutSlowIn,
        child: _images(),
      ),
      AnimatedContainer(
        duration: duration,
        transform: Matrix4.translationValues(_rightImageMargin, 0, 0),
        curve: Curves.fastOutSlowIn,
        child: _images(),
      )
    ]));
  }

  GridView _images() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      childAspectRatio: 1,
      physics: NeverScrollableScrollPhysics(),
      children: List.generate(
          30,
          (index) => CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: "https://picsum.photos/id/$index/100/100",
              )),
    );
  }

  Row _tabButtons() {
    return Row(
      children: [
        Expanded(
          child: IconButton(
            icon: ImageIcon(AssetImage('assets/images/grid.png')),
            onPressed: () {
              _tabSelected(SelectedTab.left);
            },
            color: _isSelected == SelectedTab.left
                ? Colors.black87
                : Colors.black26,
          ),
        ),
        Expanded(
          child: IconButton(
            icon: ImageIcon(AssetImage('assets/images/saved.png')),
            onPressed: () {
              _tabSelected(SelectedTab.right);
            },
            color: _isSelected == SelectedTab.right
                ? Colors.black87
                : Colors.black26,
          ),
        )
      ],
    );
  }

  _tabSelected(SelectedTab selectedTab) {
    setState(() {
      switch (selectedTab) {
        case SelectedTab.left:
          _isSelected = SelectedTab.left;
          _leftImageMargin = 0;
          _rightImageMargin = size.width;
          break;
        case SelectedTab.right:
          _isSelected = SelectedTab.right;
          _leftImageMargin = -size.width;
          _rightImageMargin = 0;
          break;
      }
    });
  }

  Padding _editProfileBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: common_gap, vertical: common_xxs_gap),
      child: SizedBox(
        height: 24,
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.black87),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0))),
          child: Text(
            'Edit Profile',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
      ),
    );
  }

  _username(BuildContext context) {
    UserModelState userModelState = Provider.of<UserModelState>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: common_xxs_gap),
      child: Text(
        userModelState == null || userModelState.userModel == null
            ? "No search name"
            : userModelState.userModel.username,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  _userbio() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: common_gap, vertical: common_xxs_gap),
      child: Text(
        'this is what i believe!!',
      ),
    );
  }

  _selectedIndicator() {
    return AnimatedContainer(
      duration: duration,
      alignment: _isSelected == SelectedTab.left
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        height: 3,
        width: size.width / 2,
        color: Colors.black87,
      ),
      curve: Curves.fastOutSlowIn,
    );
  }
}

enum SelectedTab { left, right }
