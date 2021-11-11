import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:get/get.dart';

import 'package:master_thesis/core/constants/app_constants.dart';
import 'package:master_thesis/core/l10n/l10n.dart';
import 'package:master_thesis/features/data/user_session_repository.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/features/home_page/home_screen.dart';
import 'package:master_thesis/service_locator.dart';

class SetAvatarPage extends StatefulWidget {
  const SetAvatarPage({
    Key? key,
    this.fromSettings = false,
  }) : super(key: key);
  final bool fromSettings;

  static const String routeName = '/setAvatarPage';

  @override
  State<SetAvatarPage> createState() => _SetAvatarPageState();
}

class _SetAvatarPageState extends State<SetAvatarPage> {
  String? moji;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(context.l10n.setProfileAvatar),
        automaticallyImplyLeading: widget.fromSettings,
      ),
      body: _buildBody(context),
    );
  }

  Column _buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: AppConstants.toScreenEdgePadding),
                _buildSetAvatarMessage(context),
                const SizedBox(height: AppConstants.toScreenEdgePadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FluttermojiCircleAvatar(),
                    _buildFinishEditProfileButton(context),
                  ],
                ),
              ],
            ),
          ),
        ),
        _buildFluttermojiCustomizer(context)
      ],
    );
  }

  Widget _buildFinishEditProfileButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        Get.find<FluttermojiController>().setFluttermoji();
        final failureOrUserId = await sl<UserSessionRepository>().readSession();
        failureOrUserId.fold(
          (l) => log('SetAvatarPage - ${l.message}'),
          (userId) async {
            final failureOrUser = await sl<UserRepository>().getUser();
            failureOrUser.fold(
              (l) => log('SetAvatarPage - ${l.message}'),
              (user) async {
                await sl<UserRepository>().updateUser(user.copyWith(
                    emojiSVG:
                        await FluttermojiFunctions().encodeMySVGtoString()));
                if (widget.fromSettings) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacementNamed(context, HomePage.routeName);
                }
              },
            );
          },
        );
      },
      label: Text(context.l10n.finishEditProfile),
      icon: const Icon(Icons.done),
    );
  }

  Padding _buildSetAvatarMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.toScreenEdgePadding),
      child: Text(
        context.l10n.setAvatarMessage,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Column _buildFluttermojiCustomizer(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(height: AppConstants.toScreenEdgePadding),
        FluttermojiCustomizer(
          outerTitleText: context.l10n.customizeAvatar,
        ),
      ],
    );
  }
}
