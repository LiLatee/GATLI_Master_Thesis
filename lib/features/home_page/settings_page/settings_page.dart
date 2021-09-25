import 'package:flutter/material.dart';
import 'package:master_thesis/core/l10n/l10n.dart';
import 'package:master_thesis/features/app/app_cubit.dart';
import 'package:master_thesis/features/login/login_page.dart';
import 'package:master_thesis/features/widgets/whole_screen_width_button.dart';
import 'package:master_thesis/service_locator.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: WholeScreenWidthButton(
              label: context.l10n.logout,
              color: Theme.of(context).colorScheme.secondaryVariant,
              onPressed: () {
                sl<AppCubit>().logout();
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginPage.routeName, (route) => false);
              },
            ),
          ),
        ],
      ),
    );
  }
}
