import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muezikfy/providers/auth_provider.dart';
import 'package:muezikfy/utilities/color_schemes.dart';
import 'package:muezikfy/utilities/ui_util.dart';
import 'package:provider/provider.dart';

class FriendsListView extends StatefulWidget {
  const FriendsListView({super.key});

  @override
  State<FriendsListView> createState() => _FriendsListViewState();
}

class _FriendsListViewState extends State<FriendsListView> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text('Add new friends',
              style: Theme.of(context).textTheme.titleLarge)),
      body: FirestoreQueryBuilder<Map<String, dynamic>>(
        query: authProvider.personsQuery,
        builder: (context, snapshot, _) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: snapshot.docs.length,
            itemBuilder: (context, index) {
              // if we reached the end of the currently obtained items, we try to
              // obtain more items
              if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                // Tell FirestoreQueryBuilder to try to obtain more items.
                // It is safe to call this function from within the build method.
                snapshot.fetchMore();
              }

              final user = snapshot.docs[index].data();

              return InkWell(
                onTap: () async {
                  final res = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog.adaptive(
                          title: Text(
                            'Information',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          content: Text(
                            'Add "${user['first_name']} ${user['last_name']}" as a friend?',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text(
                                  'Cancel',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.red),
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text(
                                  'Add',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ))
                          ],
                        );
                      });

                  if (res == null) return;
                  if (res == true) {
                    BotToast.showLoading(
                        allowClick: false,
                        clickClose: false,
                        backButtonBehavior: BackButtonBehavior.ignore);
                    await authProvider.addPersonAsFriend(user['user_id']);
                    BotToast.closeAllLoading();
                    if (!mounted) return;
                    alertNotification(
                        message:
                            'Added "${user['first_name']} ${user['last_name']}" as a friend',
                        context: context);
                  }
                },
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
                            backgroundImage: CachedNetworkImageProvider(
                                user['photoUrl'] ?? ''),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      SizedBox(
                          width: 90,
                          child: Text(
                            user['first_name'] ?? '',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall,
                          )),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
