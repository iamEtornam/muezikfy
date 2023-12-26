import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muezikfy/models/person.dart';
import 'package:muezikfy/providers/auth_provider.dart';
import 'package:muezikfy/resources/resources.dart';
import 'package:muezikfy/routes.dart';
import 'package:muezikfy/shared_widgets/custom_bottomsheet.dart';
import 'package:muezikfy/shared_widgets/custom_buttons.dart';
import 'package:muezikfy/shared_widgets/custom_progress_indicator.dart';
import 'package:muezikfy/shared_widgets/custom_textfield.dart';
import 'package:muezikfy/utilities/custom_colors.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  XFile? imageFile;
  late AuthProvider authProvider;
  Person? user;
  final formKey = GlobalKey<FormState>();
  TextEditingController? _firstNameTextController;
  TextEditingController? _lastNameTextController;
  TextEditingController? _userNameTextController;
  TextEditingController? _emailTextController;
  String phoneUrl = '';
  bool discoverable = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      authProvider = Provider.of<AuthProvider>(context, listen: false);

      user = await authProvider.getUser();
      _firstNameTextController =
          TextEditingController(text: user?.firstName ?? '');
      _lastNameTextController =
          TextEditingController(text: user?.lastName ?? '');
      _userNameTextController =
          TextEditingController(text: user?.username ?? '');
      _emailTextController = TextEditingController(text: user?.email ?? '');
      phoneUrl = user?.photoUrl ?? '';
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title:
              Text('Profile', style: Theme.of(context).textTheme.titleLarge)),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  children: [
                    imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            child: FutureBuilder<Uint8List>(
                                future: imageFile!.readAsBytes(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CustomProgressIndicator();
                                  }
                                  return Image.memory(
                                    snapshot.data!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fill,
                                  );
                                }),
                          )
                        : phoneUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: phoneUrl,
                                width: 100,
                                height: 100,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(.3),
                                        width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(90.0)),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator.adaptive(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey.withOpacity(.3),
                                  child: SvgPicture.asset(Svgs.person),
                                ),
                                fit: BoxFit.cover,
                                color: const Color(0xFFF5F5F5),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(90),
                                child: Image.asset(
                                  Images.avatar,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill,
                                ),
                              ),
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.black38,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: FloatingActionButton.small(
                        backgroundColor: Colors.white,
                        onPressed: () async {
                          final res = await showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return CustomBottomsheet(
                                    title: 'Options',
                                    onCloseAction: () =>
                                        Navigator.of(context).pop(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          onTap: () => Navigator.of(context)
                                              .pop(ImageSource.camera),
                                          contentPadding: EdgeInsets.zero,
                                          leading: SvgPicture.asset(
                                            Svgs.camera,
                                          ),
                                          title: Text(
                                            'Camera',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                ),
                                          ),
                                        ),
                                        const Divider(),
                                        ListTile(
                                          onTap: () => Navigator.of(context)
                                              .pop(ImageSource.gallery),
                                          contentPadding: EdgeInsets.zero,
                                          leading: SvgPicture.asset(
                                            Svgs.gallery,
                                          ),
                                          title: Text(
                                            'Gallery',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ));
                              });

                          if (res == null) return;
                          final xFile = await ImagePicker()
                              .pickImage(source: res, imageQuality: 60);
                          if (xFile == null) return;
                          if (!mounted) return;

                          setState(() {
                            imageFile = xFile;
                          });
                        },
                        elevation: 0,
                        child: Center(
                          child: SvgPicture.asset(
                            Svgs.camera,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    textController: _firstNameTextController,
                    placeholderText: 'John',
                    label: 'First name',
                    isProfile: true,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: CustomTextField(
                    textController: _lastNameTextController,
                    placeholderText: 'Doe',
                    label: 'Last name',
                    isProfile: true,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextField(
              textController: _emailTextController,
              placeholderText: 'johndoe@mail.com',
              label: 'Email',
              isProfile: true,
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextField(
              textController: _userNameTextController,
              placeholderText: 'john.doe',
              label: 'Username',
              isProfile: true,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Make my profile public',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  width: 7,
                ),
                const Spacer(),
                Switch.adaptive(
                    activeColor: Theme.of(context).primaryColor,
                    activeTrackColor: colorMain.withOpacity(.3),
                    // trackColor: Theme.of(context).inputDecorationTheme.fillColor ?? Colors.grey,
                    inactiveThumbColor: Colors.grey,
                    trackOutlineWidth:
                        MaterialStateProperty.resolveWith<double?>(
                            (Set<MaterialState> states) {
                      return 1.0; // Use the default width.
                    }),
                    trackOutlineColor:
                        MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                      return Colors.grey;
                      // Use the default color.
                    }),
                    value: discoverable,
                    onChanged: (val) {
                      setState(() {
                        discoverable = val;
                      });
                    })
              ],
            ),
            const SizedBox(
              height: 35,
            ),
            PrimaryButton(
              label: 'Update',
              onPressed: () async {
                if (formKey.currentState!.validate() && imageFile != null) {
                  BotToast.showLoading(
                      allowClick: false,
                      clickClose: false,
                      backButtonBehavior: BackButtonBehavior.ignore);
                  final photoUrl = await authProvider.uploadPhoto(
                      file: await imageFile!.readAsBytes(),
                      path: imageFile!.path);
                  await authProvider.updateUser(Person(
                      firstName: _firstNameTextController!.text,
                      lastName: _lastNameTextController!.text,
                      photoUrl: photoUrl,
                      email: _emailTextController!.text,
                      createdAt: DateTime.now().toString(),
                      userId: authProvider.currentUser!.uid,
                      discoverable: discoverable));
                  BotToast.closeAllLoading();
                  if (!mounted) return;

                  context.goNamed(RoutesName.home);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
