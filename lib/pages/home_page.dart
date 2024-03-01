import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gemini_tutorial/constants/colors.dart';
import 'package:gemini_tutorial/pages/views/message_card.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/chat_bloc/chat_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();

  int length = 0;
  final scrollController = ScrollController();

  void _sendMessage(BuildContext context) {
    context.read<ChatBloc>().add(SendMessage(message: controller.text));
    controller.clear();
    print(scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.backgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Chat',
                style: GoogleFonts.mulish(
                  color: CustomColors.blackTextColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (context.watch<ChatBloc>().state is ChatLoadingState)
                const CupertinoActivityIndicator()
            ],
          ),
          centerTitle: false,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SafeArea(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (length != state.messages.length || length == 0) {
                  print("New position");
                  scrollController.jumpTo(
                    scrollController.position.maxScrollExtent,
                  );
                  length = state.messages.length;
                }
              },
              builder: (context, state) {
                final messages = state.messages;
                return ListView.separated(
                  itemCount: messages.length,
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Align(
                        alignment: message.isSent
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: index == (messages.length - 1)
                            ? Padding(
                                padding: EdgeInsets.only(bottom: 100.sp),
                                child: MessageCard(
                                  message: messages.last,
                                  isStream: true,
                                ),
                              )
                            : MessageCard(message: message));
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 12.h,
                    );
                  },
                );
              },
            ),
          ),
        ),
        bottomSheet: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.plus,
                          size: 30.sp,
                        )),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        autocorrect: false,
                        style: TextStyle(
                          fontSize: 15.sp,
                        ),
                        onSubmitted: (value) {
                          _sendMessage(context);
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          filled: true,
                          fillColor: CustomColors.backgroundColor,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          _sendMessage(context);
                        },
                        icon: Icon(
                          Icons.send,
                          size: 30.sp,
                          color: CustomColors.sendMessageColor,
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}
