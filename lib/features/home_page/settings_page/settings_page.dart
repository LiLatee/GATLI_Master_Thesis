import 'package:flutter/material.dart';
import 'package:master_thesis/features/app/app_cubit.dart';
import 'package:master_thesis/service_locator.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: TextButton(
        onPressed: () {
          sl<AppCubit>().logout();
        },
        child: const Text('Logout'),
      ),
      // ListView(
      //   children: [
      // TextButton(
      //   onPressed: () {
      //     sl<AppCubit>().logout();
      //   },
      //   child: const Text('Logout'),
      // ),
      //   ],
      // ),
    );
  }
}
