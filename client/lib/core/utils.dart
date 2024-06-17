import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

String rgbToHex(Color color) =>
    '${_intToRadixString(color.red)}${_intToRadixString(color.green)}${_intToRadixString(color.blue)}';

Color hexToColor(String hex) => Color(int.parse(hex, radix: 16) + 0xFF000000);

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
}

Future<File?> pickAudio() async {
  return await _pickerByFileType(FileType.audio);
}

Future<File?> pickImage() async {
  return await _pickerByFileType(FileType.image);
}

String getAudioDuration(int seconds) {
  return '${(seconds ~/ 60)}:${(seconds % 60) < 10 ? '0${(seconds % 60)}' : (seconds % 60)}';
}

Future<File?> _pickerByFileType(FileType fileType) async {
  try {
    final filePickerResult =
        await FilePicker.platform.pickFiles(type: fileType);

    if (filePickerResult != null) {
      return File(filePickerResult.files.first.xFile.path);
    }

    return null;
  } catch (e) {
    return null;
  }
}

String _intToRadixString(int color) {
  return color.toRadixString(16).padLeft(2, '0');
}
