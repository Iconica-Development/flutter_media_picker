// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_form/flutter_form.dart';

class MediaCheckPage extends StatefulWidget {
  const MediaCheckPage({
    required this.displayResult,
    required this.inputSettings,
    required this.onComplete,
    required this.cancel,
    Key? key,
  }) : super(key: key);

  final Widget displayResult;
  final Map<String, dynamic> inputSettings;
  final Function onComplete;
  final Function cancel;

  @override
  State<MediaCheckPage> createState() => _MediaCheckPageState();
}

class _MediaCheckPageState extends State<MediaCheckPage> {
  FlutterFormController formController = FlutterFormController();

  final FlutterFormInputController<String> descriptionController =
      FlutterFormInputPlainTextController(id: 'description');

  final FlutterFormInputController<bool> timelineSwitchController =
      FlutterFormInputSwitchController(id: 'timeline');

  final FlutterFormInputController<bool> vaultSwitchController =
      FlutterFormInputSwitchController(id: 'vault');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: FlutterForm(
        formController: formController,
        options: FlutterFormOptions(
          onFinished: (results) {
            widget.onComplete(results[0]);
          },
          onNext: (pageNumber, results) {},
          nextButton: (int pageNumber, bool checkingPages) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: SizedBox(
                  height: 45,
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: Colors.black,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      widget.cancel();
                      formController.autoNextStep();
                    },
                    child: const Text("Delen"),
                  ),
                ),
              ),
            );
          },
          backButton: (int pageNumber, bool checkingPages, int pageAmount) {
            return Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(
                  top: 35,
                  left: 40,
                ),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  color: const Color(0xFFD8D8D8).withOpacity(0.50),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  splashRadius: 15,
                  onPressed: () {
                    if (formController.getCurrentStep() == 0) {
                      widget.cancel();
                      Navigator.pop(context);
                    } else {
                      formController.previousStep();
                    }
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
              ),
            );
          },
          pages: [
            FlutterFormPage(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 75,
                  left: 30,
                  right: 30,
                  bottom: 40,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.inputSettings['title'] ?? 'title',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    SizedBox(
                      height: widget.inputSettings['height'],
                      width: widget.inputSettings['width'],
                      child: widget.displayResult,
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    Expanded(
                      child: FlutterFormInputMultiLine(
                          hint: "Voeg omschrijving toe...",
                          maxCharacters: 300,
                          controller: descriptionController),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    FlutterFormInputSwitch(
                      label: const Text(
                        'Deel op je tijdlijn',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      controller: timelineSwitchController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    FlutterFormInputSwitch(
                      label: const Text(
                        'Bewaar in de kluis',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      controller: vaultSwitchController,
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
