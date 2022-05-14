import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'You cannot share an empty dialog!',
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
