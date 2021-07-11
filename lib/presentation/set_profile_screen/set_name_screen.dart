import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:master_thesis/core/constants/AppConstants.dart';
import 'package:master_thesis/logic/cubit/launching_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:master_thesis/presentation/router/app_router.dart';

class SetNameScreen extends StatelessWidget {
  const SetNameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _nameFormKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.setProfileName,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_nameFormKey.currentState!.validate())
            Navigator.pushNamed(context, AppRouterNames.setAvatarScreen);
        },
        child: Icon(Icons.arrow_forward),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: AppConstants.toScreenEdgePadding),
          _buildSetProfileNameMessage(context),
          SizedBox(height: AppConstants.toScreenEdgePadding),
          _buildTextFormName(_nameFormKey, context),
        ],
      ),
    );
  }

  TextButton _buildNextButton(
      GlobalKey<FormState> _nameFormKey, BuildContext context) {
    return TextButton(
      onPressed: () {
        if (_nameFormKey.currentState!.validate())
          Navigator.pushNamed(context, AppRouterNames.setAvatarScreen);
      },
      child: Text(AppLocalizations.of(context)!.next),
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  Widget _buildTextFormName(
      GlobalKey<FormState> _nameFormKey, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.toScreenEdgePadding),
      child: Form(
        key: _nameFormKey,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.name,
            focusedBorder: OutlineInputBorder(borderSide: BorderSide()),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty)
              return AppLocalizations.of(context)!.pleaseEnterName;
            else
              return null;
          },
        ),
      ),
    );
  }

  Padding _buildSetProfileNameMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.toScreenEdgePadding),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.hi,
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            Text(
              AppLocalizations.of(context)!.setNameMessage,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
