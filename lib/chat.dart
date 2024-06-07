import 'dart:convert';

import 'package:chatbot_app/models/chatMessageModel.dart';
import 'package:chatbot_app/models/globalSharedPreferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

String apiKey = 'AIzaSyAL75D8Flwm3BoFTpyX5vrBVsRU0Sy_aCM';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final GenerativeModel model =
      GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey);
  TextEditingController txtCont = new TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> msgs = [];
  bool _loading = false;
  List<ChatMessage> prevMsgs = [];
  bool _hasPrevMsgs = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final String? tempMsgs =
        SharedPreferencesHelper.instance.prefs.getString('msgs');

    if (tempMsgs != null) {
      msgs = ChatMessage.decode(tempMsgs.toString());
      _hasPrevMsgs = true;
      print("hello $prevMsgs");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(msgs);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Chat with me ", style: GoogleFonts.poppins(fontSize: 16),),
        backgroundColor: Color(0xFF7DD5F6),
        excludeHeaderSemantics: true,
      ),
      
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount:
                _hasPrevMsgs ? prevMsgs.length + msgs.length : msgs.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 90),
            // physics: NeverScrollableScrollPhysics(),
            controller: _scrollController,
            itemBuilder: (context, index) {
              return Container(
                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (msgs[index].messageType == "gemini"
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (msgs[index].messageType == "gemini"
                          ? Colors.grey.shade200
                          : Color(0xFF7DD5F6)),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      msgs[index].messageContent.toString(),
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ),
                ),
              );
            },
          ),

          Positioned(
              bottom: 0,
              child: Row(
                children: [
                  Container(
                    // height: 100,
                    width: MediaQuery.sizeOf(context).width - 10,
                    margin: EdgeInsets.only(left: 5, right: 5, bottom: 7),
                    child: TextField(
                      controller: txtCont,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Write message...",
                        hintStyle: GoogleFonts.poppins(fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        
                        suffixIcon: FloatingActionButton(
                          onPressed: () async {
                            setState(() {
                              _loading = true;
                            });
                            msgs.add(ChatMessage(
                                messageContent: txtCont.text,
                                messageType: 'user'));
                            final content = [Content.text(txtCont.text)];
                            final response =
                                await model.generateContent(content);

                            msgs.add(ChatMessage(
                                messageContent: response.text,
                                messageType: 'gemini'));

                            final String encodedData = ChatMessage.encode(msgs);
                            SharedPreferencesHelper.instance.prefs
                                .setString('msgs', encodedData);
                            setState(() {
                              txtCont.clear();
                              _loading = false;
                            });
                          },
                          child: Container(
                            child: _loading
                                ? CupertinoActivityIndicator()
                                : Icon(Icons.send),
                          ),
                          backgroundColor: Colors.white,
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ))
          // Positioned(
          //   bottom: 0,
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: SizedBox(
          //           height: 200,
          //           child: TextField(
          //             controller: txtCont,
          //             decoration: InputDecoration(
          //                 hintText: "Write message...",
          //                 hintStyle: TextStyle(color: Colors.black54),
          //                 border: InputBorder.none),
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         width: 15,
          //       ),
          //
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
