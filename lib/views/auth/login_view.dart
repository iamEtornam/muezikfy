import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muezikfy/providers/auth_provider.dart';
import 'package:muezikfy/utilities/ui_util.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
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
                        .headline5
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  FlatButton(
                    padding: EdgeInsets.all(15),
                    onPressed: () async {
                      BotToast.showLoading(
                          allowClick: false,
                          clickClose: false,
                          backButtonBehavior: BackButtonBehavior.ignore);
                      bool isSuccessful =
                          await authenticationProvider.signInWithGoogle();
                      BotToast.closeAllLoading();
                      if (isSuccessful) {
                        alertNotification(
                            message: 'Welcome to Muezikfy...',
                            context: context);
                        Future.delayed(Duration(seconds: 5), () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/homeView', (route) => false);
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
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Continue with Google',
                          style: Theme.of(context).textTheme.button,
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                      color: Color(0xFF3b5998),
                      padding: EdgeInsets.all(15),
                      onPressed: () async {
                        BotToast.showLoading(
                            allowClick: false,
                            clickClose: false,
                            backButtonBehavior: BackButtonBehavior.ignore);
                        bool isSuccessful =
                            await authenticationProvider.signInWithFacebook();
                        BotToast.closeAllLoading();
                        if (isSuccessful) {
                          alertNotification(
                              message: 'Welcome to Muezikfy...',
                              context: context);
                          Future.delayed(Duration(seconds: 5), () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/homeView', (route) => false);
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
                          Icon(
                            AntDesign.facebook_square,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Continue with Facebook',
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45))),
                  SizedBox(
                    height: 10,
                  ),
                  Platform.isIOS?  FlatButton(
                      color: Color(0xFF000000),
                      padding: EdgeInsets.all(15),
                      onPressed: () async {
                        BotToast.showLoading(
                            allowClick: false,
                            clickClose: false,
                            backButtonBehavior: BackButtonBehavior.ignore);
                        bool isSuccessful =
                            await authenticationProvider.signInWithApple();
                        BotToast.closeAllLoading();
                        if (isSuccessful) {
                          alertNotification(
                              message: 'Welcome to Muezikfy...',
                              context: context);
                          Future.delayed(Duration(seconds: 5), () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/homeView', (route) => false);
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
                          Icon(
                            AntDesign.apple1,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Sign in with Apple',
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45))) : SizedBox(),
                  SizedBox(
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
