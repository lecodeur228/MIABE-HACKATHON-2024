import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ctrl_r/screens/pages/add_control_screen.dart';

class TextScan extends StatefulWidget {
  TextEditingController plaqueController;
  TextScan({super.key, required this.plaqueController});

  @override
  State<TextScan> createState() => _TextScanState();
}

class _TextScanState extends State<TextScan> {
  //var _script = TextRecognitionScript.latin;
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  bool textScanning = false;

  XFile? imageFile;

  String scannedText = "";

  ScanData scanData = ScanData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Text Recognition example"),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (textScanning) const CircularProgressIndicator(),
                if (!textScanning && imageFile == null)
                  Container(
                    width: 300,
                    height: 300,
                    color: Colors.grey[300]!,
                  ),
                if (imageFile != null) Image.file(File(imageFile!.path)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            getPlaque(ImageSource.camera);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_view_day_rounded,
                                  color: Theme.of(context).primaryColor,
                                  size: 30,
                                ),
                                const Text(
                                  "Plaque",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black87),
                                )
                              ],
                            ),
                          ),
                        )),

                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            getName(ImageSource.camera);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.contact_page,
                                  color: Theme.of(context).primaryColor,
                                  size: 30,
                                ),
                                const Text(
                                  "Nom",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black87),
                                )
                              ],
                            ),
                          ),
                        )),
                    //

                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            //   Navigator.push(
                            //   context,
                            //   // MaterialPageRoute(
                            //   //   builder: (context) => AddControleScreen(scanData: scanData),
                            //   // ),
                            // );
                          },
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: Theme.of(context).primaryColor,
                                    size: 30,
                                  ),
                                  const Text(
                                    "Correct",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black87),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  scannedText,
                  style: const TextStyle(fontSize: 20),
                )
              ],
            )),
      )),
    );
  }

  void getPlaque(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedPlaque(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getName(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedName(pickedImage, 'nom:');
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getRecognisedName(XFile image, String keyword) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final recognisedText = await _textRecognizer.processImage(inputImage);

    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        String lineText = line.text;
        int keywordIndex =
            lineText.toLowerCase().indexOf(keyword.toLowerCase());

        if (keywordIndex != -1) {
          // Keyword found, extract text after it
          String textAfterKeyword =
              lineText.substring(keywordIndex + keyword.length);
          if (textAfterKeyword.isNotEmpty) {
            scannedText += textAfterKeyword;
          }
        }
      }
    }
    scanData.nom = scannedText;
    textScanning = false;
    setState(() {});
  }

  void getRecognisedPlaque(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final recognisedText = await _textRecognizer.processImage(inputImage);

    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = "$scannedText${line.text}\n";
      }
      List<String> parts = scannedText.split(' ');

      // Vérifier que la chaîne contient bien deux parties
      if (parts.length == 2) {
        // Réorganiser les parties
        String rearrangedText = '${parts[1]} ${parts[0]}';

        setState(() {
          widget.plaqueController.text = rearrangedText;
        });
      } else {
        print("Le format du texte scanné n'est pas valide.");
      }
    }
    scanData.plaque = scannedText;
    textScanning = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }
}

class ScanData {
  String? plaque;
  String? nom;
}
