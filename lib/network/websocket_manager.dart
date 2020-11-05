import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/models/message.dart';
import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  WebSocketChannel channel;

  connectToServer(
      String token, {Function(Message message) onSuccess,Function onError}) async {
    var appConfig = GetIt.instance<AppConfig>();
    var host = appConfig.apiHost;
    Uri uri = Uri.parse("wss://${host.substring(8)}/ws/?token=$token");
    debugPrint("向$uri 发起请求");
    channel = WebSocketChannel.connect(uri);
    channel.stream.listen((message) {
      debugPrint("收到服务器的消息: ${message.toString()}");
      Message m;
      m = Message.fromJson(json.decode(message));
      onSuccess(m);
    });
  }

  disconnect() async {
    channel.sink.close();
  }

  sendMessage(data) async {
    channel.sink.add(data);
  }

//外部添加监听
}
