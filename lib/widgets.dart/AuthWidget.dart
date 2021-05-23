import 'package:classroom_scheduler_flutter/Pages.dart/AuthenticationScreen.dart/LoginPage.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWidget extends StatelessWidget {
  final AuthService authService = AuthService();
  final Widget child;

  AuthWidget({
    this.child,
  });
  @override
  Widget build(BuildContext context) {
    bool isSignedIn = Provider.of<AuthService>(context).isSigned;

    return isSignedIn ? child : LogInPage();
  }
}
