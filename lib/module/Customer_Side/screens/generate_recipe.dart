import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GenerateRecipe extends StatefulWidget {
  static const String id = "ai-screen";

  const GenerateRecipe({super.key});

  @override
  State<GenerateRecipe> createState() => _GenerateRecipeState();
}

class _GenerateRecipeState extends State<GenerateRecipe> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  final List<String> inputTags = [];
  String response = "";

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(onTap: (){Get.back();},child: Icon(CupertinoIcons.back,color: Colors.white,)),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Cook with us",style: TextStyle(color: Colors.white),),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: size.height,
            child: Column(
              children: [
                Text(
                  'Find according to your test 😋',
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        height: size.height/15,
                        width: size.width/1.2,
                        child: TextFormField(
                          autofocus: true,
                          autocorrect: true,
                          focusNode: focusNode,
                          controller: controller,
                          cursorColor: Colors.green,
                          onFieldSubmitted: (value) {
                            setState(() {
                              inputTags.add(value);
                              focusNode.requestFocus();
                            });
                            print("${inputTags}");
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.green
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            labelText: "Enter the ingredients you have",
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: size.height/15,
                      width: size.width/6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Colors.green,
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            inputTags.add(controller.text);
                            focusNode.requestFocus();
                          });
                          controller.clear();
                          print("${inputTags}");
                        },
                        icon: Icon(
                          CupertinoIcons.add,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Wrap(
                    children: [
                      for (int i = 0; i < inputTags.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Chip(
                            backgroundColor: Colors.green
                                .withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.5)),
                            label: Text(
                              inputTags[i],
                            ),
                            onDeleted: () {
                              setState(() {
                                inputTags.remove(inputTags[i]);
                                response = "";
                                print(inputTags);
                              });
                            },
                            deleteIcon: Icon(
                              CupertinoIcons.clear,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                inputTags.length != 0 ?
                Expanded(
                  child: Container(
                    height: size.height/1.68,
                    width: size.width,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(5.5, 5),
                            blurRadius: 12,
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                          )
                        ]
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${response}",
                          style: TextStyle(fontSize: 16,color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                ):Expanded(child: Container()),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                    onPressed: () async {
                      if (inputTags.length < 1) {
                        return showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: Text("Attention Please... 😊"),
                            content:
                            Text("Please enter ingredients or recipe name"),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: Text("OK",style: TextStyle(color: Colors.green),),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                            ],
                          ),
                        );
                      } else {
                        final apiKey =
                            "AIzaSyA9SDdz6cB9se4SfZgs_ViuNl5ouQiZD8g";
                        setState(() => response = 'Thinking...');
                        final model = GenerativeModel(
                            model: 'gemini-pro', apiKey: apiKey);
                        final content = [
                          Content.text(
                              'Create a recipe from list of ingredients ${inputTags.toString()}')
                        ];
                        final gResponse = await model.generateContent(content);
                        setState(() => response = _extractContent(gResponse));

                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.book,color: Colors.white,),
                        SizedBox(width: size.width/20,),
                        Text('Find in our book',style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _extractContent(GenerateContentResponse generateResponse) {
    // Assuming GenerateContentResponse has a 'content' property
    final content = generateResponse.text;
    if (content != null) {
      log("${content.toString()}");
      return content.toString();
    } else {
      return "No content generated";
    }
  }
}