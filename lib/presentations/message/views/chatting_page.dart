import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:market_place/core/components/custom_appbar.dart';
import 'package:market_place/core/components/custom_network_image.dart';
import 'package:market_place/core/components/custom_text_button.dart';
import 'package:market_place/core/constants/app_static_strings.dart';
import 'package:market_place/core/constants/custom_space.dart';
import 'package:market_place/core/constants/custom_text.dart';
import 'package:market_place/core/constants/fontsize_constant.dart';
import 'package:market_place/core/constants/image_constants.dart';
import 'package:market_place/core/constants/pagination_loading_widget.dart';
import 'package:market_place/core/constants/text_style_constant.dart';
import 'package:market_place/core/helper/helper_function.dart';
import 'package:market_place/presentations/message/model/message_model.dart';
import 'package:market_place/presentations/profile/controllers/account_information_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/api-client/api_service.dart';
import '../../../core/components/custom_textfield.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/padding_constant.dart';
import '../controllers/message_controller.dart';
import '../model/conversation_model.dart';
import '../widgets/chat_message_card_item_widget.dart';

class ChattingPage extends StatefulWidget {
  static const String routeName = '/chatting';

  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  ScrollController messageScrollController = ScrollController();
  final args = Get.arguments;

  bool isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    final userId = AccountInformationController.to.userModel.value.sId;
    MessageController.to.messageList.clear();
    MessageController.to.socket?.off('new-message::$args-$userId');
    MessageController.to.socket?.on('new-message::$args-$userId', (data) {
      MessageController.to.getMessageListRequest(conversationId: args);
    });
    messageScrollController.addListener(() {
      if (messageScrollController.position.pixels ==
          messageScrollController.position.maxScrollExtent) {
        MessageController.to.getMessageListRequest(
          conversationId: args,
          loadMore: true,
        );
      }
    });

    // Initial message load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialMessages();
    });
  }

  void _loadInitialMessages() async {
    await MessageController.to.getMessageListRequest(conversationId: args);

    // Scroll to bottom after initial load
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (messageScrollController.hasClients) {
      messageScrollController.animateTo(
        messageScrollController
            .position
            .minScrollExtent, // ⬅️ bottom in reverse:true
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  ConversationUserModel? getOtherUser(ChattingUserModel? meta) {
    final myId = AccountInformationController.to.userModel.value.sId;

    if (meta == null || meta.users == null) return null;

    return meta.users!.firstWhere(
      (p) => p.sId != myId,
      orElse: () => ConversationUserModel(name: "", img: null),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          ConversationUserModel? convoUser = getOtherUser(
            MessageController.to.chattingUser.value,
          );
          return CustomDefaultAppbar(
            title: convoUser != null ? convoUser.name : 'User Name loading....',
            action: [
              MessageController.to.chattingUser.value.isBlocked == true &&
                      MessageController.to.chattingUser.value.blockedBy ==
                          convoUser?.sId
                  ? SizedBox.shrink()
                  : CustomTextButton(
                    onPressed: () async {
                      bool isBlocked = await MessageController.to
                          .blockConversationRequest(conversationId: args);
                      if (isBlocked) {
                        MessageController.to.chattingUser.update(
                          (val) => val?.isBlocked = !(val.isBlocked ?? false),
                        );
                      }
                    },
                    title:
                        MessageController.to.chattingUser.value.isBlocked ==
                                true
                            ? AppStaticStrings.unblock.tr
                            : AppStaticStrings.block.tr,
                  ),
            ],
          );
        }),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return MessageController.to.messageList.isNotEmpty
                ? SizedBox.shrink()
                : _buildReceiverProfile();
          }),
          Obx(() {
            return MessageController.to.isLoadingMoreMessages.value
                ? PaginationLoadingWidget()
                : SizedBox.shrink();
          }),
          // Messages list
          Expanded(
            child: Obx(() {
              if (MessageController.to.isLoadingMessage.value &&
                  MessageController.to.messageList.isEmpty) {
                return ListView.builder(
                  reverse: true,
                  itemCount: 6,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemBuilder:
                      (context, index) => ChatMessageSkeleton(
                        isSender: index % 2 == 0 ? true : false,
                      ),
                );
              } else {
                ConversationUserModel? convoUser = getOtherUser(
                  MessageController.to.chattingUser.value,
                );
                return ListView.builder(
                  controller: messageScrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  reverse: true,
                  itemCount: MessageController.to.messageList.length,
                  itemBuilder: (context, index) {
                    final message = MessageController.to.messageList[index];
                    return ChatMessageCardItemWidget(
                      message: message,
                      receiverUser: convoUser!,
                    );
                  },
                );
              }
            }),
          ),

          // Voice / Image preview section
          Obx(() {
            return (MessageController.to.img.value.isNotEmpty || 
                    MessageController.to.voicePath.value.isNotEmpty)
                ? Container(
                    padding: padding8,
                    color: Colors.grey[100],
                    child: Row(
                      children: [
                        if (MessageController.to.img.value.isNotEmpty)
                          Stack(
                            children: [
                              Image.file(
                                height: 80.w,
                                width: 80.w,
                                fit: BoxFit.cover,
                                File(MessageController.to.img.value),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: GestureDetector(
                                  onTap: () => MessageController.to.img.value = "",
                                  child: Icon(Icons.cancel, color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        if (MessageController.to.voicePath.value.isNotEmpty)
                          Expanded(
                            child: Container(
                              padding: padding8,
                              decoration: BoxDecoration(
                                color: AppColors.kPrimaryAccentColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.mic, color: AppColors.kPrimaryColor),
                                  space8W,
                                  Text("Voice Message Ready"),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () => MessageController.to.voicePath.value = "",
                                    icon: Icon(Icons.delete, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : SizedBox.shrink();
          }),

          // Message input section
          Obx(() {
            return MessageController.to.chattingUser.value.isBlocked == true
                ? Padding(
                  padding: padding12,
                  child: CustomText(
                    text: "Conversation Blocked!!",
                    style: poppinsSemiBold,
                  ),
                )
                : _buildMessageInput();
          }),
        ],
      ),
    );
  }

  Widget _buildReceiverProfile() {
    return Center(
      child: Obx(() {
        ConversationUserModel? convoUser = getOtherUser(
          MessageController.to.chattingUser.value,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomNetworkImage(
              imageUrl: "${ApiService().baseUrl}/${convoUser?.img}",
              height: 75.w,
              width: 75.w,
              boxShape: BoxShape.circle,
            ),
            space4H,
            CustomText(
              text: convoUser?.name ?? "Jane Cooper",
              style: poppinsSemiBold,
              fontSize: getFontSizeDefault(),
            ),
          ],
        );
      }),
    );
  }

  Widget ChatMessageSkeleton({bool isSender = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSender)
            Shimmer.fromColors(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHighlight,
              child: CircleAvatar(radius: 24),
            ),
          if (!isSender) SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: AppColors.shimmerBase,
                  highlightColor: AppColors.shimmerHighlight,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: isSender ? 0 : 8,
                      right: isSender ? 8 : 0,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    constraints: BoxConstraints(maxWidth: Get.width * 0.7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 12,
                          width: 100,
                          color: AppColors.shimmerBase,
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: 12,
                          width: 60,
                          color: AppColors.shimmerBase,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Shimmer.fromColors(
                  baseColor: AppColors.shimmerBase,
                  highlightColor: AppColors.shimmerHighlight,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: isSender ? 0 : 8,
                      right: isSender ? 8 : 0,
                    ),
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Shimmer.fromColors(
                  baseColor: AppColors.shimmerBase,
                  highlightColor: AppColors.shimmerHighlight,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: isSender ? 0 : 8,
                      right: isSender ? 8 : 0,
                    ),
                    height: 10,
                    width: 50,
                    color: AppColors.shimmerBase,
                  ),
                ),
              ],
            ),
          ),

          if (isSender) SizedBox(width: 8),
          if (isSender)
            Shimmer.fromColors(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHighlight,
              child: CircleAvatar(radius: 24),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: padding8,
      child: Obx(() {
        final isRecording = MessageController.to.isRecording.value;
        return Row(
          children: [
            if (!isRecording)
              IconButton(
                onPressed: () {
                  pickImages(
                    context: context,
                    allowMultiple: false,
                    singleImagePath: MessageController.to.img,
                  );
                },
                icon: SvgPicture.asset(imgIcon),
              ),
            Expanded(
              child: isRecording
                  ? Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryAccentColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          Icon(Icons.mic, color: Colors.red),
                          space8W,
                          Text(
                            MessageController.to.formatDuration(
                              MessageController.to.recordingDuration.value,
                            ),
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text("Recording...", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : CustomTextField(
                      hintText: AppStaticStrings.typeMessage.tr,
                      textEditingController: MessageController.to.messageController,
                      borderColor: AppColors.kPrimaryColor,
                      fillColor: AppColors.kWhiteColor,
                      borderRadius: 16.r,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: 4,
                      minLines: 1,
                      contentPadding: EdgeInsets.zero,
                    ),
            ),
            space8W,
            if (MessageController.to.messageController.text.isEmpty && 
                MessageController.to.img.isEmpty && 
                MessageController.to.voicePath.isEmpty)
              GestureDetector(
                onLongPress: () => MessageController.to.startRecording(),
                onLongPressUp: () => MessageController.to.stopRecording(),
                child: CircleAvatar(
                  backgroundColor: isRecording ? Colors.red : AppColors.kPrimaryColor,
                  child: Icon(isRecording ? Icons.stop : Icons.mic, color: Colors.white),
                ),
              )
            else
              Obx(() {
                return MessageController.to.isLoadingCreateMessage.value
                    ? PaginationLoadingWidget()
                    : IconButton(
                        onPressed: () {
                          if (MessageController.to.messageController.text.isNotEmpty ||
                              MessageController.to.img.isNotEmpty ||
                              MessageController.to.voicePath.isNotEmpty) {
                            MessageController.to
                                .createMessageRequest(conversationId: args)
                                .then((_) {
                              _scrollToBottom();
                            });
                          }
                        },
                        icon: SvgPicture.asset(sendMessageIcon),
                      );
              }),
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    messageScrollController.dispose();
    super.dispose();
  }
}
