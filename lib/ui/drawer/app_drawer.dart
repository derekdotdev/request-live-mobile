import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../../app_localizations.dart';
import '../requests/requests_screen.dart';
import '../../screens/search_screen.dart';
import '../../routes.dart';
import '../../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Options'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Main'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(Routes.home);
            },
          ),
          const Divider(),
          // TODO if(in app purchases (purchased) token) show 'my requests'
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('My Requests'),
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.requests,
                arguments: RequestsScreenArgs(
                  // TODO figure this out!
                  'entertainerUID', 'entertainerDisplayName',
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              // Navigator.of(context).pop();
              _confirmSignOut(context);
            },
          ),
        ],
      ),
    );
  }

  _confirmSignOut(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        material: (_, PlatformTarget target) => MaterialAlertDialogData(
            backgroundColor: Theme.of(context).appBarTheme.color),
        title: Text(AppLocalizations.of(context).translate("alertDialogTitle")),
        content:
            Text(AppLocalizations.of(context).translate("alertDialogMessage")),
        actions: <Widget>[
          PlatformDialogAction(
            child: PlatformText(
                AppLocalizations.of(context).translate("alertDialogCancelBtn")),
            onPressed: () => Navigator.pop(context),
          ),
          PlatformDialogAction(
            child: PlatformText(
                AppLocalizations.of(context).translate("alertDialogYesBtn")),
            onPressed: () {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);

              authProvider.signOut();

              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.login, ModalRoute.withName(Routes.login));
            },
          )
        ],
      ),
    );
  }
}
