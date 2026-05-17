import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

enum ChatMsgType { text, photos, voice, mine }

class ChatMsg {
  const ChatMsg({required this.type, this.text, this.time = ''});
  final ChatMsgType type;
  final String? text;
  final String time;
}

class ChatDetailController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  late final String chatName;

  final RxList<ChatMsg> messages = <ChatMsg>[
    const ChatMsg(
      type: ChatMsgType.text,
      text: "Here's the first moodboard for the product film.",
      time: '10:24 AM',
    ),
    const ChatMsg(type: ChatMsgType.photos, time: '10:24 AM'),
    const ChatMsg(type: ChatMsgType.voice, time: '10:25 AM'),
    const ChatMsg(
      type: ChatMsgType.mine,
      text: 'Looks amazing!',
      time: '10:26 AM',
    ),
  ].obs;

  late final bool fromProjectMode;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    chatName = args?['name'] as String? ?? 'Sohbet';
    fromProjectMode = args?['mode'] != null;
  }

  void goBack() {
    if (fromProjectMode) {
      Get.offAllNamed(AppRoutes.clientHome);
    } else {
      Get.back();
    }
  }

  void send() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;
    messages.add(ChatMsg(
      type: ChatMsgType.mine,
      text: text,
      time: _now(),
    ));
    messageController.clear();
  }

  String _now() {
    final t = TimeOfDay.now();
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
