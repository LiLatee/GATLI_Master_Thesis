import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:master_thesis/features/home_page/home_screen.dart';

class SetProfileConfirmationDialog extends StatelessWidget {
  const SetProfileConfirmationDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(16.0),
      children: [
        Text(
          AppLocalizations.of(context)!.isEditFinished,
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppLocalizations.of(context)!.isEditFinishedNo,
              ),
            ),
            SizedBox(width: 8.0),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                HomePage.routeName,
                (Route<dynamic> route) => false,
              ),
              child: Text(
                AppLocalizations.of(context)!.isEditFinishedYes,
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
