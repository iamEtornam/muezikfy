import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muezikfy/models/person.dart';
import 'package:muezikfy/providers/auth_provider.dart';
import 'package:muezikfy/resources/resources.dart';
import 'package:muezikfy/shared_widgets/custom_bottomsheet.dart';
import 'package:muezikfy/shared_widgets/custom_buttons.dart';
import 'package:muezikfy/shared_widgets/custom_progress_indicator.dart';
import 'package:muezikfy/shared_widgets/custom_textfield.dart';
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
  late TextEditingController _firstNameTextController;
  late TextEditingController _lastNameTextController;
  late TextEditingController _userNameTextController;
  late TextEditingController _emailTextController;
  String phoneUrl = '';

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
      appBar: AppBar(),
      body: user == null
          ? CustomProgressIndicator()
          : Form(
              key: formKey,
              child: ListView(
                padding: EdgeInsets.all(24),
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
                                          return CustomProgressIndicator();
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
                                              color:
                                                  Colors.grey.withOpacity(.3),
                                              width: 1.0),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(90.0)),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          CircularProgressIndicator.adaptive(
                                              value: downloadProgress.progress),
                                      errorWidget: (context, url, error) =>
                                          CircleAvatar(
                                        radius: 50,
                                        backgroundColor:
                                            Colors.grey.withOpacity(.3),
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
                                                onTap: () =>
                                                    Navigator.of(context).pop(
                                                        ImageSource.camera),
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
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 15,
                                                      ),
                                                ),
                                              ),
                                              const Divider(),
                                              ListTile(
                                                onTap: () =>
                                                    Navigator.of(context).pop(
                                                        ImageSource.gallery),
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
                                                        fontWeight:
                                                            FontWeight.w400,
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
                                  color: Colors.black,
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
                    height: 35,
                  ),
                  PrimaryButton(
                    label: 'Update',
                    onPressed: () async {
                      if (formKey.currentState!.validate() &&
                          imageFile != null) {
                        await authProvider.updateUser(Person(
                            firstName: _firstNameTextController.text,
                            lastName: _lastNameTextController.text,
                            photoUrl: imageFile!.path,
                            email: _emailTextController.text,
                            createdAt: DateTime.now().toString(),
                            userId: user!.userId));
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              ),
            ),
    );
  }
}
