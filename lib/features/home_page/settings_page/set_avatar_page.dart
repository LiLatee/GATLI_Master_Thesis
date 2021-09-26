import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:get/get.dart';
import 'package:master_thesis/core/constants/app_constants.dart';
import 'package:master_thesis/core/l10n/l10n.dart';
import 'package:master_thesis/features/data/user_session_repository.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/service_locator.dart';

class SetAvatarPage extends StatefulWidget {
  const SetAvatarPage({Key? key}) : super(key: key);

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
        // if (moji != null)
        //   SvgPicture.string(
        //       FluttermojiFunctions().decodeFluttermojifromString(moji!)),
        // WholeScreenWidthButton(
        //   label: 'test',
        //   onPressed: () async {
        //     final String mojiToDecode =
        //         await FluttermojiFunctions().encodeMySVGtoString();

        //     setState(() async {
        //       moji = await FluttermojiFunctions().encodeMySVGtoString();
        //       // moji = FluttermojiFunctions()
        //       //     .decodeFluttermojifromString(mojiToDecode);
        //     });
        //   },
        // ),
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
          (l) => null,
          (userId) async {
            final failureOrUser = await sl<UserRepository>().getUser(userId);
            failureOrUser.fold(
              (l) => null,
              (user) async {
                await sl<UserRepository>().updateUser(user.copyWith(
                    emojiSVG:
                        await FluttermojiFunctions().encodeMySVGtoString()));
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
        AppLocalizations.of(context)!.setAvatarMessage,
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
          outerTitleText: AppLocalizations.of(context)!.customizeAvatar,
        ),
      ],
    );
  }
}
