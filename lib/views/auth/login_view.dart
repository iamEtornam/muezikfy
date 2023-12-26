import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:muezikfy/providers/auth_provider.dart';
import 'package:muezikfy/routes.dart';
import 'package:muezikfy/utilities/ui_util.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    final authenticationProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'MUEZIKFY',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const FlutterLogo(
                    size: 120,
                  ),
                  const Spacer(),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45)),
                    ),
                    onPressed: () async {
                      BotToast.showLoading(
                          allowClick: false,
                          clickClose: false,
                          backButtonBehavior: BackButtonBehavior.ignore);
                      bool isSuccessful =
                          await authenticationProvider.signInWithGoogle();
                      BotToast.closeAllLoading();
                      if (!mounted) return;
                      if (isSuccessful) {
                        alertNotification(
                            message: 'Welcome to Muezikfy...',
                            context: context);
                        Future.delayed(const Duration(seconds: 3), () {
                          context.goNamed(RoutesName.home);
                        });
                      } else {
                        alertNotification(
                            message: 'Authentication failed!',
                            context: context);
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/ic_google.svg',
                          width: 35,
                          height: 35,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Continue with Google',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Platform.isIOS
                      ? TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFF000000),
                              padding: const EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(45))),
                          onPressed: () async {
                            BotToast.showLoading(
                                allowClick: false,
                                clickClose: false,
                                backButtonBehavior: BackButtonBehavior.ignore);
                            bool isSuccessful =
                                await authenticationProvider.signInWithApple();
                            BotToast.closeAllLoading();
                            if (!mounted) return;

                            if (isSuccessful) {
                              alertNotification(
                                  message: 'Welcome to Muezikfy...',
                                  context: context);
                              Future.delayed(const Duration(seconds: 3), () {
                                context.goNamed(RoutesName.home);
                              });
                            } else {
                              alertNotification(
                                  message: 'Authentication failed!',
                                  context: context);
                            }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                AntDesign.apple1,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Sign in with Apple',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
