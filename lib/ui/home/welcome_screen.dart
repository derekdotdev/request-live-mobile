import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../../app_localizations.dart';
import '../../constants/global_variables.dart';
import '../../models/user_model.dart';
import '../../resources/firestore_database.dart';
import '../drawer/app_bar_local.dart';
import '../drawer/app_drawer.dart';
import '../entertainer/entertainer_screen.dart';
import '../../routes.dart';
import '../../providers/auth_provider.dart';
import '../../constants/colors.dart';

class WelcomeScreen extends StatefulWidget {
  // static const routeName = '/welcome';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _page = 0;
  late PageController pageController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO verify if page controller should be disposed before or after super().
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      backgroundColor: Colors.white,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              title: const Text('Request Live'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () {
                    _confirmSignOut(context);
                  },
                ),
              ],
            ),
      drawer: width < webScreenSize ? null : const AppDrawer(),
      body: PageView(
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          // Feed Screen
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: (_page == 0) ? primaryColor : secondaryColor),
            label: '',
            backgroundColor: primaryColor,
          ),
          // Search Screen
          BottomNavigationBarItem(
            icon: Icon(Icons.search,
                color: (_page == 1) ? primaryColor : secondaryColor),
            label: '',
            backgroundColor: primaryColor,
          ),
          // Profile Screen
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: (_page == 2) ? primaryColor : secondaryColor),
            label: '',
            backgroundColor: primaryColor,
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
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
