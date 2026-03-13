import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'app_color.dart';


enum MessageType { success, error, warning, info }


class Utils {

  static final Utils _instance = Utils._internal();
  factory Utils() => _instance;
  Utils._internal();

  /// FlushBar Message
  void showFlushBar(BuildContext context,String message, {String? title, MessageType type = MessageType.info}){
    Flushbar(
      title: title,
      message: message,
      titleColor: AppColor.primaryColors,
      messageColor: AppColor.primaryColors,
      backgroundColor: getColorByType(type),
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 1),
      isDismissible: true,
      borderRadius: BorderRadius.circular(8),
      margin: const EdgeInsets.all(10),
      icon: Icon(getIconByType(type), color: Colors.white),
    ).show(context);
  }

  /// SnackBar Message
  void showSnackBar(BuildContext context, String message, {MessageType type = MessageType.info}) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message),
          backgroundColor: getColorByType(type),
          duration: const Duration(seconds: 1),
        )
    );
  }



  Color getColorByType(MessageType type){
    switch(type){
      case MessageType.success:
        return AppColor.successColors;
      case MessageType.error:
        return AppColor.errorColors;
      case MessageType.warning:
        return Colors.orange.shade800;
      case MessageType.info:
      default :
        return AppColor.tertiaryColors;
    }
  }


  IconData getIconByType(MessageType type){
    switch(type){
      case MessageType.success:
        return Icons.check_circle;
      case MessageType.error:
        return Icons.error;
      case MessageType.warning:
        return Icons.warning;
      case MessageType.info:
      default :
        return Icons.info;
    }
  }

}





Future<void> showCustomDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirm,
  String confirmText = "Yes",
  String cancelText = "Cancel",
  bool showCancelButton = true,
  IconData icon = Icons.info,
  Color iconColor = Colors.blue,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          if (showCancelButton)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(cancelText),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
}