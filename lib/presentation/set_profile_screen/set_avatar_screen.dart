import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:master_thesis/core/constants/AppConstants.dart';
import 'package:master_thesis/logic/cubit/launching_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:master_thesis/presentation/home_screen/home_screen.dart';
import 'package:master_thesis/presentation/router/app_router.dart';

class SetAvatarScreen extends StatelessWidget {
  SetAvatarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setProfileAvatar),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: AppConstants.toScreenEdgePadding),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.toScreenEdgePadding),
                    child: Text(
                      AppLocalizations.of(context)!.setAvatarMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  SizedBox(height: AppConstants.toScreenEdgePadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FluttermojiCircleAvatar(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                  contentPadding: EdgeInsets.all(16.0),
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .isEditFinished,
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    Wrap(
                                      alignment: WrapAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .isEditFinishedNo,
                                          ),
                                        ),
                                        SizedBox(width: 8.0),
                                        TextButton(
                                          onPressed: () => Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                            AppRouterNames.home,
                                            (Route<dynamic> route) => false,
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .isEditFinishedYes,
                                          ),
                                          style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                              AppLocalizations.of(context)!.finishEditProfile),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: AppConstants.toScreenEdgePadding),
              FluttermojiCustomizer(
                outerTitleText: AppLocalizations.of(context)!.customizeAvatar,
              ),
            ],
          )
        ],
      ),
    );
  }
}
