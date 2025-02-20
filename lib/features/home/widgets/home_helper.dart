/* old
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeHelper {
  static Future<bool> get isInternetConnected async {
    final Connectivity connectivity = Connectivity();
    List<ConnectivityResult> results = await connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile);
  }

  static void showCustomSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating, // يجعلها تظهر بشكل عائم
      duration: Duration(seconds: 3), // مدة الظهور
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Login Required',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text('You need to log in to perform this action.'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // // Close the dialog
                // Navigator.pop(context);

                // // Navigate to login page
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SignUpScreen(type: '',)),
                // );
              },
              child: Text('Login'),
            ),
          ],
        );
      },
    );
  }

  static void showResultDialog(BuildContext context,
      {String title = 'Confirmation', String desc = "Done Successfully"}) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(desc),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Close the dialog
                Navigator.pop(context);
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> pickDateAndTime(
    BuildContext context,
    Rx<DateTime?> date, {
    bool pickTime = false,
    DateTime? firstDate,
  }) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date.value ?? firstDate,
      firstDate: firstDate ?? DateTime(1950),
      lastDate: DateTime(2100),
      locale: const Locale('en'),
    );

    if (pickedDate != null) {
      TimeOfDay time = TimeOfDay.now();

      if (pickTime) {
        // Pick Time
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(date.value ?? DateTime.now()),
          initialEntryMode: TimePickerEntryMode.input,
        );

        if (pickedTime != null) {
          time = pickedTime;
        }
      }
      date.value = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
          time.hour, time.minute, DateTime.now().second);
    }
  }

  static Future<void> pickTime(BuildContext context, Rx<TimeOfDay?> time,
      [TimeOfDay? initialTime]) async {
    // Pick Time
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: time.value ?? initialTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
    );

    if (pickedTime != null) {
      time.value = TimeOfDay(hour: pickedTime.hour, minute: pickedTime.minute);
    }
  }

  static String formatTime(TimeOfDay time) {
    // تحويل TimeOfDay إلى DateTime
    var now = DateTime.now();
    final datetime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return DateFormat('hh:mm a').format(datetime);
  }
}*/

//new

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_333/features/auth/presentation/sign_up_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeHelper {
  static Future<bool> get isInternetConnected async {
    final Connectivity connectivity = Connectivity();
    List<ConnectivityResult> results = await connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile);
  }

  static void showCustomSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating, // Floating snackbar
      duration: Duration(seconds: 3), // Display duration
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// ✅ **Modified Function: Allow profile editing without requiring login**
  static void showLoginDialog(BuildContext context,
      {bool requireLogin = true}) {
    if (!requireLogin) {
      // ✅ Allow profile editing without forcing login
      return;
    }

    // Show login dialog only when login is required
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Login Required',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text('You need to log in to perform this action.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog first
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignUpScreen(type: '')),
                );
              },
              child: Text('Login'),
            ),
          ],
        );
      },
    );
  }

  static void showResultDialog(BuildContext context,
      {String title = 'Confirmation', String desc = "Done Successfully"}) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(desc),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> pickDateAndTime(
    BuildContext context,
    Rx<DateTime?> date, {
    bool pickTime = false,
    DateTime? firstDate,
  }) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date.value ?? firstDate,
      firstDate: firstDate ?? DateTime(1950),
      lastDate: DateTime(2100),
      locale: const Locale('en'),
    );

    if (pickedDate != null) {
      TimeOfDay time = TimeOfDay.now();

      if (pickTime) {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(date.value ?? DateTime.now()),
          initialEntryMode: TimePickerEntryMode.input,
        );

        if (pickedTime != null) {
          time = pickedTime;
        }
      }
      date.value = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
          time.hour, time.minute, DateTime.now().second);
    }
  }

  static Future<void> pickTime(BuildContext context, Rx<TimeOfDay?> time,
      [TimeOfDay? initialTime]) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: time.value ?? initialTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
    );

    if (pickedTime != null) {
      time.value = TimeOfDay(hour: pickedTime.hour, minute: pickedTime.minute);
    }
  }

  static String formatTime(TimeOfDay time) {
    var now = DateTime.now();
    final datetime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return DateFormat('hh:mm a').format(datetime);
  }
}
