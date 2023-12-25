import 'package:flutter/material.dart';
import 'package:muezikfy/utilities/custom_colors.dart';

class StatusFriendsWidget extends StatelessWidget {
  final String avatar;
  final String name;
  const StatusFriendsWidget({
    Key? key,
    required this.avatar,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: colorMain, width: 2)),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  radius: 33,
                  backgroundColor: colorMain.withOpacity(.5),
                  backgroundImage:
                      ExactAssetImage(avatar, package: 'sample_data'),
                ),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            SizedBox(
                width: 90,
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall,
                )),
          ],
        ),
      ),
    );
  }
}
