import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:master_thesis/core/constants/AppConstants.dart';
import 'package:master_thesis/logic/cubit/launching_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:master_thesis/presentation/home_screen/home_screen.dart';
import 'package:master_thesis/presentation/router/app_router.dart';

import 'set_profile_confirmation_dialog.dart';

class SetAvatarScreen extends StatelessWidget {
  SetAvatarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setProfileAvatar),
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
                SizedBox(height: AppConstants.toScreenEdgePadding),
                _buildSetAvatarMessage(context),
                SizedBox(height: AppConstants.toScreenEdgePadding),
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
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => SetProfileConfirmationDialog(),
        );
      },
      label: Text(AppLocalizations.of(context)!.finishEditProfile),
      icon: Icon(Icons.done),
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
        SizedBox(height: AppConstants.toScreenEdgePadding),
        FluttermojiCustomizer(
          outerTitleText: AppLocalizations.of(context)!.customizeAvatar,
        ),
      ],
    );
  }
}
