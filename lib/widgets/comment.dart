import 'package:flutter/material.dart';
import 'package:instagram_clone_coding/constants/common_size.dart';
import 'package:instagram_clone_coding/widgets/rounded_avatar.dart';

class Comment extends StatelessWidget {
  final bool showImage;
  final String username;
  final String text;
  final DateTime dateTime;

  Comment({
    Key key,
    this.showImage = true,
    @required this.username,
    @required this.text,
    this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showImage) RoundedAvatar(size: 30.0),
        if (showImage)
          SizedBox(
            width: common_xxs_gap,
          ),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text.rich(
                TextSpan(
                  style: Theme.of(context).textTheme.subtitle1,
                  children: <TextSpan>[
                    TextSpan(
                        text: username,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black87)),
                    TextSpan(text: '  '),
                    TextSpan(
                        text: text, style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              ),
              if (dateTime != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(dateTime.toIso8601String(),
                      style: TextStyle(color: Colors.grey[500], fontSize: 10)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
