import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gemini_tutorial/models/message.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  final bool isStream;

  const MessageCard({super.key, required this.message, this.isStream = false});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  late final Stream<String> streamWord;

  Stream<String> streamToStream(Stream<String> text) async* {
    String word = "";

    text.listen((event) {
      word = event;
    });
    final words = word.split(" ");
    for (int i = 0; i < words.length; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      yield words.sublist(0, i).join(" ");
    }
  }

  Stream<String> textToStream(String word) async* {
    final words = word.split(" ");
    for (int i = 0; i < words.length; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      yield words.sublist(0, i).join(" ");
    }
  }

  List<String> extractLinks(String text) {
    var regex = RegExp(r'https?://(?:[-\w.]|(?:%[\da-fA-F]{2}))+');
    var result = regex.allMatches(text).map((e) => e.group(0) ?? "");
    return result.toList();
  }

  @override
  void initState() {
    super.initState();
    streamWord = textToStream(widget.message.content);
  }

  @override
  Widget build(BuildContext context) {
    print(extractLinks(widget.message.content));
    return StreamBuilder<String>(
        stream: streamWord,
        builder: (context, snapshot) {
          return Offstage(
            offstage: snapshot.data == null,
            child: Container(
              constraints: BoxConstraints(maxWidth: 300.w, minWidth: 50.w),
              decoration: BoxDecoration(
                borderRadius: widget.message.isSent
                    ? Styles.sendMessageBorder
                    : Styles.receiveMessageBorder,
                color: widget.message.isSent
                    ? CustomColors.sendMessageColor
                    : Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(10.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    !widget.isStream ||
                            widget.message.isSent ||
                            snapshot.connectionState == ConnectionState.done
                        ? Text(
                            widget.message.content,
                            style: GoogleFonts.mulish(
                              color: widget.message.isSent
                                  ? Colors.white
                                  : CustomColors.blackTextColor,
                              fontSize: 14.sp,
                            ),
                          )
                        : Text(
                            snapshot.data ?? "",
                            style: GoogleFonts.mulish(
                              color: widget.message.isSent
                                  ? Colors.white
                                  : CustomColors.blackTextColor,
                              fontSize: 14.sp,
                            ),
                          ),
                    Text(
                      "09:45",
                      style: GoogleFonts.lato(
                        color: widget.message.isSent
                            ? Colors.white
                            : CustomColors.timeGrey,
                        fontSize: 10.sp,
                      ),
                    )
                    // Text(
                    //   "${message.time.hour.toString().padLeft(2, "0")}:${message.time.minute.toString().padLeft(2, "0")}",
                    //   style: GoogleFonts.lato(
                    //     color: message.isSent ? Colors.white : CustomColors.timeGrey,
                    //     fontSize: 10.sp,
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
