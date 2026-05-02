import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market_place/core/components/custom_refresh_indicator.dart';
import 'package:market_place/presentations/message/controllers/message_controller.dart';
import 'package:market_place/presentations/message/loading/conversation_loading.dart';
import 'package:market_place/presentations/message/model/conversation_model.dart';

import '../../../core/components/empty_widget.dart';
import '../../../core/constants/padding_constant.dart';
import '../../../core/constants/pagination_loading_widget.dart';
import '../../profile/controllers/account_information_controller.dart';
import '../widgets/message_card_item_widget.dart';

class MessageListPage extends StatefulWidget {
  static const String routeName = '/message';

  const MessageListPage({super.key});

  @override
  State<MessageListPage> createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        MessageController.to.getConversationListRequest(loadMore: true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicatorWidget(
      onRefresh: () async{
      await  MessageController.to.getConversationListRequest();
      },
      child: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(child: Padding(
            padding: padding12,
            child: Column(
              children: [
                Obx(() {
                  return  MessageController.to.isLoadingConversation.value?
                  ConversationLoadingWidget(): MessageController.to.conversationList.isEmpty?
                  EmptyWidget(text: "Conversation List is Empty!!",)
                      :Column(
                    spacing: 12.h,
                    children: List.generate(
                        MessageController.to.conversationList.length,
                            (index) {
                          final conversation = MessageController.to.conversationList[index];
                          final receiver = conversation.users?.firstWhere(
                                (u) => u.sId != AccountInformationController.to.userModel.value.sId,
                            orElse: () => Users(), // fallback
                          );

                          return MessageCardItemWidget(
                            conversation: conversation,
                            receiverUser: receiver!,
                          );
                        }
                    ),
                  );
                }),
                Obx(() {
                  return MessageController.to.isLoadingMore.value
                      ? PaginationLoadingWidget()
                      : SizedBox.shrink();
                }),
              ],
            ),
          ),)
        ],
      ),
    );
  }
}

