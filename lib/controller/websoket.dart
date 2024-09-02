import 'dart:convert';
import 'package:get/get.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketController extends GetxController {
  late WebSocketChannel channel= IOWebSocketChannel.connect(Uri.parse(Api.webSocket));
  var receivedData = ''.obs;

  @override
  void onInit() {
    super.onInit();
    connectWebSocket();
  }

  void connectWebSocket() {
    channel = IOWebSocketChannel.connect(Api.webSocket);
    channel.stream.listen((message) {
      receivedData.value = message;
    });
  }

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  void closeConnection() {
    channel.sink.close();
  }

  @override
  void onClose() {
    closeConnection();
    super.onClose();
  }
}