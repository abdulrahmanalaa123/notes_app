import 'package:flutter/cupertino.dart';
import 'package:notes_app/ui_components/authentication_components/error_indicator.dart';
import 'package:sqflite/sqflite.dart';

//after restrucuring the notesViewModel turns out
//all functions will be void so i couldve just set void instead of T
//and used it but fuck it its still a good idea to use it in this more
// gereral way
class NotesErrorIndicator {
  final errorIndicator = ErrorIndicator();
  NotesErrorIndicator();

  Future<T?> noInputFuncWrapper<T>(
      {required Future<T> Function() func,
      required BuildContext context}) async {
    try {
      return await func();
    } on DatabaseException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) async => await errorIndicator.show(context, text: e.toString()));
    }
    return null;
  }

  Future<T?> oneInputFuncWrapper<T, R>(
      {required Future<T> Function(R object) func,
      required R object,
      required BuildContext context}) async {
    try {
      return await func(object);
    } on DatabaseException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) async => await errorIndicator.show(context, text: e.toString()));
    }
    return null;
  }

  Future<T?> twoInputFuncWrapper<T, R, G>(
      {required Future<T> Function(R object, G? object2) func,
      required R object,
      G? object2,
      required BuildContext context}) async {
    try {
      if (object2 != null) {
        return await func(object, object2);
      } else {
        return await func(object, null);
      }
    } on DatabaseException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) async => await errorIndicator.show(context, text: e.toString()));
    }
    return null;
  }
}
