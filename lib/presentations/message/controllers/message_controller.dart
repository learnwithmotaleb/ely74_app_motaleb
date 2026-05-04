import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:market_place/presentations/message/model/conversation_model.dart';
import 'package:market_place/presentations/message/views/chatting_page.dart';
import 'package:market_place/presentations/navigation/controller/navigation_controller.dart';
import 'package:market_place/presentations/navigation/views/navigation_page.dart';
import 'package:market_place/presentations/profile/controllers/account_information_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../../core/api-client/api_endpoints.dart';
import '../../../core/api-client/api_service.dart';
import '../../../core/helper/helper_function.dart';
import '../../../core/utils/hive_boxes.dart';
import '../../../core/utils/variable.dart';
import '../model/chat_message_model.dart';
import '../model/message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessageController extends GetxController {
  final messages = <ChatMessage>[].obs;
  RxString img = "".obs;
  RxString voicePath = "".obs;

  static MessageController get to => Get.find();
  final RxString currentConversationId = ''.obs;

  RxBool isLoadingCreateConversation = false.obs;
  RxBool isLoadingCreateMessage = false.obs;
  RxBool isLoadingConversation = false.obs;
  RxBool isLoadingMessage = false.obs;
  var tabContent = <Widget>[].obs;
  RxList<ConversationModel> conversationList = <ConversationModel>[].obs;
  RxList<MessageModel> messageList = <MessageModel>[].obs;
  Rx<Users> receiverUser = Users().obs;
  Rx<ChattingUserModel> chattingUser = ChattingUserModel().obs;
  TextEditingController messageController = TextEditingController();
  RxString messageText = "".obs;
  IO.Socket? socket;

  // Voice recording variables
  late AudioRecorder audioRecorder;
  RxBool isRecording = false.obs;
  RxInt recordingDuration = 0.obs;
  Timer? _timer;

  ///====================conversation pagination variable========================///

  final RxInt currentPage = 1.obs;
  final RxInt itemsPerPage = 10.obs;
  final RxInt totalCategoryPages = 5.obs;
  final RxBool isLoadingMore = false.obs;

  ///===============================message pagination variable======================///
  RxInt messageCurrentPage = 1.obs;
  RxInt totalMessagePages = 1.obs;
  RxInt messageItemsPerPage = 10.obs;
  RxBool isLoadingMoreMessages = false.obs;

  @override
  void onInit() async {
    super.onInit();
    messageController.addListener(() {
      messageText.value = messageController.text;
    });
    audioRecorder = AudioRecorder();
    await AccountInformationController.to.getUserProfileRequest();
    if (AccountInformationController.to.userModel.value.sId != null &&
        AccountInformationController.to.userModel.value.sId!.isNotEmpty) {
      socket = IO.io(
        '${ApiService().baseUrl}?user_id=${AccountInformationController.to.userModel.value.sId}',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build(),
      );

      socket?.connect();

      socket?.onConnect((_) {
        logger.d('✅ Socket connected');
        socket?.emit('msg', 'test');
      });

      socket?.onConnectError((data) {
        logger.e('❌ Socket connect error: $data');
      });

      socket?.onError((data) {
        logger.e('❌ Socket error: $data');
      });

      socket?.onDisconnect((_) {
        logger.e('🔌 Socket disconnected');
      });
    } else {
      logger.d(AccountInformationController.to.userModel.value.sId);
    }
    getConversationListRequest();
  }

  // Voice Recording Methods
  Future<void> startRecording() async {
    try {
      if (await audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        String path = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        const config = RecordConfig();
        
        await audioRecorder.start(config, path: path);
        isRecording.value = true;
        recordingDuration.value = 0;
        _startTimer();
      }
    } catch (e) {
      logger.e("Error starting recording: $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await audioRecorder.stop();
      isRecording.value = false;
      _stopTimer();
      if (path != null) {
        voicePath.value = path;
      }
    } catch (e) {
      logger.e("Error stopping recording: $e");
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recordingDuration.value++;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  ///------------------------------  get conversation list method -------------------------///

  Future<void> getConversationListRequest({bool loadMore = false}) async {
    try {
      if (loadMore && currentPage.value >= totalCategoryPages.value) {
        return;
      }

      if (loadMore) {
        currentPage.value++;
        isLoadingMore.value = true;
      } else {
        isLoadingConversation.value = true;
        currentPage.value = 1;
      }
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: conversationListEndPoint,
        method: 'GET',
        queryParams: {
          'page': currentPage.value.toString(),
          'limit': itemsPerPage.value.toString(),
          'sort': 'updatedAt',
          'order': 'desc',
        },
      );
      isLoadingConversation.value = false;
      isLoadingMore.value = false;
      if (response['success'] == true) {
        if (response['pagination'] != null) {
          currentPage.value = response['pagination']['currentPage'] ?? 1;
          totalCategoryPages.value =
              response['pagination']['totalPages'] ?? 1; // Add this line

          itemsPerPage.value = response['pagination']['itemsPerPage'] ?? 10;
        }
        final newCategories = (response['data'] as List).map((e) => ConversationModel.fromJson(e)).toList();
        final imageUrls = newCategories
            .map((cat) => cat.users?.first.img != null ? "${ApiService().baseUrl}/${cat.users!.first.img}".replaceAll("\\", "/") : "")
            .where((url) => url.isNotEmpty).toList();
        final imageUrls1 = newCategories
            .map((cat) => cat.users?.last.img != null ? "${ApiService().baseUrl}/${cat.users!.last.img}".replaceAll("\\", "/") : "")
            .where((url) => url.isNotEmpty).toList();

        preloadImagesFromUrls(imageUrls);
        preloadImagesFromUrls(imageUrls1);
        if (loadMore) {
          conversationList.addAll(newCategories); // Append for load more
        } else {
          conversationList.value = newCategories; // Replace for refresh
        }
        logger.d(response);
      } else {
        logger.e(response);
        if (kDebugMode) {
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingConversation.value = false;
    }
  }

  ///------------------------------ get message list method -------------------------///

  Future<void> getMessageListRequest({
    required String conversationId,
    bool loadMore = false,
  }) async {
    try {
      if (loadMore && messageCurrentPage.value >= totalMessagePages.value) {
        return;
      }

      if (loadMore) {
        messageCurrentPage.value++;
        isLoadingMoreMessages.value = true;
      } else {
        messageCurrentPage.value = 1;
        isLoadingMessage.value = true;
      }

      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: messageListEndPoint,
        queryParams: {
          "conversation_id": conversationId,
          "page": messageCurrentPage.value.toString(),
          "limit": messageItemsPerPage.value.toString(),
          "sort": "createdAt",
          "order": "desc", // or "asc" depending on your display order
        },
        method: 'GET',
      );

      isLoadingMessage.value = false;
      isLoadingMoreMessages.value = false;

      if (response['success'] == true) {
        logger.d(response);

        if (response['pagination'] != null) {
          messageCurrentPage.value = response['pagination']['currentPage'] ?? 1;
          totalMessagePages.value = response['pagination']['totalPages'] ?? 1;
          messageItemsPerPage.value =
              response['pagination']['itemsPerPage'] ?? 20;
        }
        chattingUser.value = ChattingUserModel.fromJson(
          response['conversation'],
        );
        final imageUrls2 =
            chattingUser.value.users!
                .map((cat) => cat.img != null ? "${ApiService().baseUrl}/${cat.img}".replaceAll("\\", "/") : "")
                .where((url) => url.isNotEmpty)
                .toList();
        final newMessages =
            (response['data'] as List)
                .map((e) => MessageModel.fromJson(e))
                .toList();
        final imageUrls =
            newMessages
                .map((cat) => cat.img != null ? "${ApiService().baseUrl}/${cat.img}".replaceAll("\\", "/") : "")
                .where((url) => url.isNotEmpty)
                .toList();
        preloadImagesFromUrls(imageUrls);
        preloadImagesFromUrls(imageUrls2);
        if (loadMore) {
          messageList.addAll(newMessages); // append
        } else {
          messageList.value = newMessages; // reset
        }
      } else {
        logger.e(response);
        if (kDebugMode) {
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingMessage.value = false;
      isLoadingMoreMessages.value = false;
    }
  }

  ///------------------------------  create conversation method -------------------------///

  Future<void> createConversationRequest({required String userId}) async {
    try {
      isLoadingCreateConversation.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: conversationCreateEndPoint,
        method: 'POST',
        body: {"user": userId},
      );

      if (response['success'] == true) {
        logger.d(response);

        showCustomSnackbar(title: 'Success', message: response['message']);
        await getConversationListRequest();

        Get.toNamed(
          ChattingPage.routeName,
          arguments: response['result']['_id'],
        );
      } else {
        logger.e(response);

        NavigationController.to.selectedNavIndex.value = 3;
        Get.toNamed(NavigationPage.routeName);
      }
    } catch (e) {
      isLoadingCreateConversation.value = false;
      logger.e(e.toString());
    } finally {
      isLoadingCreateConversation.value = false;
    }
  }

  ///------------------------------  create conversation method -------------------------///

  Future<bool> blockConversationRequest({
    required String conversationId,
  }) async {
    try {
      // isLoadingCreateConversation.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(
        endpoint: "$conversationBlockEndPoint$conversationId",
        method: 'PATCH',
      );

      if (response['success'] == true) {
        logger.d(response);

        showCustomSnackbar(title: 'Success', message: response['message']);
        await getConversationListRequest();
        // isLoadingCreateConversation.value = false;
        return true;
      } else {
        logger.e(response);

        return false;
      }
    } catch (e) {
      // isLoadingCreateConversation.value = false;
      logger.e(e.toString());
      return false;
    }
  }

  ///------------------------------  create Message method -------------------------///

  Future<void> createMessageRequest({required String conversationId}) async {
    try {
      isLoadingCreateMessage.value = true;

      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      Map<String, String> fields = {
        'conversation_id': conversationId,
      };
      
      fields['message'] = messageController.text;
      
      Map<String, dynamic> files = {};

      if (img.value.isNotEmpty) {
        files['img'] = File(img.value);
      }
      
      if (voicePath.value.isNotEmpty) {
        String path = voicePath.value;
        if (path.startsWith('file://')) {
          path = path.replaceFirst('file://', '');
        }
        files['voice_message'] = File(path);
      }

      logger.d("Creating message with fields: $fields and files: ${files.keys.toList()}");

      final response = await ApiService().multipartRequest(
        endpoint: messageCreateEndPoint,
        method: 'POST',
        fields: fields,
        files: files,
      );

      isLoadingCreateMessage.value = false;

      if (response['success'] == true) {
        logger.d("Message created successfully: $response");
        messageController.clear();
        img.value = "";
        voicePath.value = "";
        getMessageListRequest(conversationId: conversationId);
      } else {
        logger.e("Failed to create message: $response");
        if (kDebugMode) {
          showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed,
          );
        }
      }
    } catch (e) {
      logger.e("Exception in createMessageRequest: $e");
      isLoadingCreateMessage.value = false;
    } finally {
      isLoadingCreateMessage.value = false;
    }
  }

  @override
  void onClose() {
    audioRecorder.dispose();
    _stopTimer();
    super.onClose();
  }
}
