import 'package:flutter/material.dart';
import '../storage/get_storage.dart';
import '../utils/utils.dart';
import '../utils/route/route_name.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool validate(BuildContext context) {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty) {
      Utils().showSnackBar(context, "Enter Email");
      return false;
    }

    if (password.isEmpty) {
      Utils().showSnackBar(context, "Enter Password");
      return false;
    }

    return true;
  }

  Future<void> login(BuildContext context) async {
    if (!validate(context)) return;

    setLoading(true);

    await Future.delayed(const Duration(seconds: 1));

    await TokenStore.saveUser(
      email: usernameController.text.trim(),
      password: passwordController.text.trim(),
    );

    setLoading(false);

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteName.home,
        (route) => false,
      );
    }
  }

  void logout(BuildContext context) async {
    await TokenStore.clearToken();

    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteName.login,
      (route) => false,
    );
  }
}
