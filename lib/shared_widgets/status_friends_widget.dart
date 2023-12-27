import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muezikfy/providers/auth_provider.dart';
import 'package:muezikfy/shared_widgets/custom_progress_indicator.dart';
import 'package:muezikfy/utilities/color_schemes.dart';
import 'package:provider/provider.dart';

class StatusFriendsWidget extends StatelessWidget {
  final String friendId;
  final VoidCallback onTap;
  const StatusFriendsWidget({
    super.key,
    required this.friendId, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: Provider.of<AuthProvider>(context, listen: false)
            .getFriendProfile(friendId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.data == null) {
            return const CustomProgressIndicator();
          }
          if (snapshot.data?.exists == false) {
            return const SizedBox.shrink();
          }
          final data = snapshot.data?.data();
          return InkWell(
            onTap: onTap,
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
                            CachedNetworkImageProvider(data?['photoUrl'] ?? ''),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  SizedBox(
                      width: 90,
                      child: Text(
                        data?['first_name'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall,
                      )),
                ],
              ),
            ),
          );
        });
  }
}
