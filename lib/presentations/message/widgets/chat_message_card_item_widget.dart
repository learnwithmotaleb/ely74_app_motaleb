import 'package:audioplayers/audioplayers.dart';
import 'package:market_place/core/components/custom_network_image.dart';
import 'package:market_place/core/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market_place/core/constants/custom_text.dart';
import 'package:market_place/core/helper/helper_function.dart';
import 'package:market_place/presentations/message/model/message_model.dart';
import 'package:market_place/presentations/profile/controllers/account_information_controller.dart';

import '../../../core/api-client/api_service.dart';
import '../model/conversation_model.dart';

class ChatMessageCardItemWidget extends StatelessWidget {
  const ChatMessageCardItemWidget({
    super.key,
    required this.message,
    required this.receiverUser,
  });

  final MessageModel message;
  final ConversationUserModel receiverUser;

  @override
  Widget build(BuildContext context) {
    bool isMe = message.sender != receiverUser.sId;
    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe)
            CustomNetworkImage(
              imageUrl: "${ApiService().baseUrl}/${receiverUser.img}",
              height: 40.w,
              boxShape: BoxShape.circle,
              width: 40.w,
            ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: isMe ? 40.w : 8.w,
                    right: isMe ? 8.w : 40.w,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.kPrimaryColor.withOpacity(0.1) : AppColors.kPrimaryAccentColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft: isMe ? Radius.circular(16.r) : Radius.circular(0),
                      bottomRight: isMe ? Radius.circular(0) : Radius.circular(16.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.message != null && message.message!.isNotEmpty)
                        SelectableText(
                          message.message.toString(),
                          style: TextStyle(
                            color: AppColors.kBlackColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      
                      // Image Message
                      if (message.img != null && message.img!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Stack(
                                    children: [
                                      CustomNetworkImage(
                                        imageUrl: "${ApiService().baseUrl}/${message.img}",
                                      ),
                                      Positioned(
                                        right: 10,
                                        top: 10,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: CustomNetworkImage(
                                height: 150.h,
                                width: 150.w,
                                imageUrl: "${ApiService().baseUrl}/${message.img}",
                              ),
                            ),
                          ),
                        ),

                      // Voice Message
                      if (message.voiceMessage != null && message.voiceMessage!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: VoiceMessagePlayer(
                            audioUrl: "${ApiService().baseUrl}/${message.voiceMessage}",
                            isMe: isMe,
                          ),
                        ),
                    ],
                  ),
                ),

                // Timestamp
                Padding(
                  padding: EdgeInsets.only(
                    top: 4,
                    left: isMe ? 0 : 8.w,
                    right: isMe ? 8.w : 0,
                  ),
                  child: Text(
                    dateFormateChange(date: message.createdAt.toString()),
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),

          if (isMe)
            CustomNetworkImage(
              imageUrl: "${ApiService().baseUrl}/${AccountInformationController.to.userModel.value.img}",
              height: 40.w,
              boxShape: BoxShape.circle,
              width: 40.w,
            ),
        ],
      ),
    );
  }
}

class VoiceMessagePlayer extends StatefulWidget {
  final String audioUrl;
  final bool isMe;

  const VoiceMessagePlayer({super.key, required this.audioUrl, required this.isMe});

  @override
  State<VoiceMessagePlayer> createState() => _VoiceMessagePlayerState();
}

class _VoiceMessagePlayerState extends State<VoiceMessagePlayer> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });

    _audioPlayer.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.audioUrl));
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              color: AppColors.kPrimaryColor,
              size: 32.sp,
            ),
            onPressed: _togglePlay,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
          Expanded(
            child: Column(
              children: [
                Slider(
                  min: 0,
                  max: _duration.inMilliseconds.toDouble(),
                  value: _position.inMilliseconds.toDouble().clamp(0, _duration.inMilliseconds.toDouble()),
                  activeColor: AppColors.kPrimaryColor,
                  inactiveColor: AppColors.kPrimaryColor.withOpacity(0.3),
                  onChanged: (value) async {
                    final position = Duration(milliseconds: value.toInt());
                    await _audioPlayer.seek(position);
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_position),
                        style: TextStyle(fontSize: 10.sp),
                      ),
                      Text(
                        _formatDuration(_duration),
                        style: TextStyle(fontSize: 10.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
