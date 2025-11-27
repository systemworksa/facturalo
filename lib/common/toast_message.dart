import 'package:bot_toast/bot_toast.dart';

class ToastMessage {
  void showToast(String titulo) {
    BotToast.showText(text: titulo);
  }
}
