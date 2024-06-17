import 'dart:io';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final songNameController = TextEditingController();
  final artistController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Color selectedColor = Pallete.cardColor;
  File? selectedImage;
  File? selectedAudio;

  Future selectAudio() async {
    final pickedAudio = await pickAudio();

    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  Future selectImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    artistController.dispose();
    songNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      homeViewModelProvider.select((val) => val?.isLoading == true),
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text('Upload Song'),
          actions: [
            IconButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() &&
                    selectedAudio != null &&
                    selectedImage != null) {
                  ref.read(homeViewModelProvider.notifier).uploadSong(
                        selectedAudio: selectedAudio!,
                        selectedThumbnail: selectedImage!,
                        songName: songNameController.text,
                        artist: artistController.text,
                        selectedColor: selectedColor,
                      );
                } else {
                  showSnackBar(context, 'Missing fields!');
                }
              },
              icon: const Icon(Icons.check),
            )
          ],
        ),
        body: isLoading
            ? const Loader()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: selectImage,
                          child: selectedImage != null
                              ? SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : DottedBorder(
                                  color: Pallete.borderColor,
                                  radius: const Radius.circular(10),
                                  borderType: BorderType.RRect,
                                  strokeCap: StrokeCap.round,
                                  dashPattern: const [10, 4],
                                  child: const SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.folder_open,
                                          size: 40,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          'Select the thumbnail for your song',
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 40),
                        selectedAudio != null
                            ? AudioWave(path: selectedAudio!.path)
                            : CustomField(
                                hintText: 'Pick Song',
                                controller: null,
                                readOnly: true,
                                onTap: selectAudio,
                              ),
                        const SizedBox(height: 20),
                        CustomField(
                          hintText: 'Artist',
                          controller: artistController,
                        ),
                        const SizedBox(height: 20),
                        CustomField(
                          hintText: 'Song Name',
                          controller: songNameController,
                        ),
                        const SizedBox(height: 20),
                        ColorPicker(
                          pickersEnabled: const {ColorPickerType.wheel: true},
                          color: selectedColor,
                          onColorChanged: (Color color) {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }
}
