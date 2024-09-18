part of 'constants.dart';

class Snack {
  final String text;

  Snack(this.text);

  void success() {
    snackbarKey.currentState?.showSnackBar(
      snackBar(
        text,
        Colors.green,
        Icons.check_circle_outlined,
      ),
    );
  }

  void error() {
    snackbarKey.currentState?.showSnackBar(
      snackBar(
        text,
        Colors.red,
        Icons.error_outline_outlined,
      ),
    );
  }

  void warning() {
    snackbarKey.currentState?.showSnackBar(
      snackBar(
        text,
        Colors.blueGrey,
        Icons.warning_outlined,
      ),
    );
  }

  SnackBar snackBar(String text, Color color, IconData icon) {
    return SnackBar(
      backgroundColor: color,
      padding: const EdgeInsets.all(20),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          Space.h10,
          Flexible(child: Text(text)),
        ],
      ),
      duration: const Duration(seconds: 3),
    );
  }
}
