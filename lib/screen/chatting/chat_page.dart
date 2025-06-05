import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siscom_operasional/controller/chat_controller.dart';
import 'package:siscom_operasional/screen/pesan/pesan%20copy.dart';
import 'package:siscom_operasional/services/request.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/image_editing.dart';
import 'package:siscom_operasional/utils/widget/image_picker_bottom_sheet.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../model/message_chat.dart';

TextEditingController _messageController = TextEditingController();
final ItemScrollController _scrollController = ItemScrollController();

class ChatPage extends StatefulWidget {
  final IOWebSocketChannel webSocketChannel;
  final fullNamePenerima;
  final emIdPenerima;
  final emIdPengirim;
  final imageProfil;
  final title;
  const ChatPage({
    super.key,
    required this.webSocketChannel,
    required this.fullNamePenerima,
    required this.emIdPenerima,
    required this.emIdPengirim,
    required this.imageProfil,
    required this.title,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController controller = Get.put(ChatController());
  var _pesans = <Message>[].obs;
  var lampiran = ''.obs;
  var isLoading = false.obs;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    controller.statuspengiriman.value = true;
    _tandaSudahDibaca();
    _fetchPesan();
    _setData();

    _loadTempMessage();
  }

  Future<void> _loadTempMessage() async
  
  
   {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) async {
      List<Message> messages = await getItemList();

      messages.sort((a, b) => (a.id).compareTo(b.id));
      print('Panjang data ${messages.length}');
      if (messages.isNotEmpty) {
        // if (controller.statuspengiriman.value==true){
        await kirimPesan(messages[0]);
        print("masuk sini tidal else");
        // }else{
        //   print("masuk sini  else");
        // }

        // messages.forEach((element) async {

        // });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer!.cancel();
  }

  void _setData() {
    final data = {
      'type': 'setData',
      'em_id_penerima': widget.emIdPenerima,
      'em_id_pengirim': widget.emIdPengirim,
    };
    widget.webSocketChannel.sink.add(jsonEncode(data));
  }

  Future pickImage(ImageSource source) async {

    try {
      final image = await ImagePicker().pickImage(
        source: source,
      );
      if (image == null) return;
      final String compressedImagePath = '${image.path}_compressed.jpg';

      // Compress the image
      final resultCompress = await FlutterImageCompress.compressAndGetFile(
        image.path,
        compressedImagePath,
        quality: 80,
      );

      File? imgFile = resultCompress;

      final result =
          await Get.to(() => ImageEditingScreen(imageFile: imgFile!));

      if (result != null) {
        File editedFile = result['file'];
        String caption = result['caption'];

        // img.Image? images = img.decodeImage(editedFile.readAsBytesSync());
        // List<int> pngBytes = img.encodePng(images!);
        String base64Image = base64Encode(editedFile.readAsBytesSync());

        var tanggal = controller.getTanggal();
        var waktu = controller.getWaktu();
        final bodyApi = {
          'em_id_penerima': widget.emIdPenerima,
          'em_id_pengirim': widget.emIdPengirim,
          'pesan': caption,
          'tanggal': tanggal,
          'waktu': waktu,
          'type': ".png",
          'lampiran': base64Image,
          'dibaca': '0',
          'status': '1',
          
        };

        var connect = Api.connectionApi("post", bodyApi, "chatting");
        connect.then((dynamic res) {
          if (res.statusCode == 200) {
            //_fetchPesan();

            final bodyWebsocket = {
              'em_id_penerima': widget.emIdPenerima,
              'em_id_pengirim': widget.emIdPengirim,
              'pesan': caption,
              'tanggal': tanggal,
              'waktu': waktu,
              'type': 'message',
              'lampiran': lampiran.value,
              'dibaca': '0',
              'status': '1',
            };

            widget.webSocketChannel.sink.add(jsonEncode(bodyWebsocket));
            _messageController.clear();
            // _fetchPesan();
            // _pesans.add(jsonEncode(bodyWebsocket));
            // _fetchPesan();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
          } else {
            UtilsAlert.showToast("koneksi buruk pesan tidak terkirim");
          }
        });

        Get.back();
      }
    } on PlatformException {
      Get.back();
    }
  }

  void showImagePickerBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Agar latar belakang transparan
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.1,
              maxChildSize: 0.3,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Warna latar belakang bottom sheet
                      borderRadius:
                          BorderRadius.circular(20.0), // Sudut rounded
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ImagePickerBottomSheet(onTap: pickImage),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> kirimPesan(Message m) async {
    controller.statuspengiriman.value = false;

    var body = {
      'em_id_penerima': m.emIdPenerima,
      'em_id_pengirim': m.emIdPengirim,
      'pesan': m.pesan,
      'tanggal': m.tanggal,
      'waktu': m.waktu,
      // 'type': m.type,
      'lampiran': m.lampiran,
      'dibaca': m.dibaca,
      'status': m.status,
      'type': 'message'
    };

    try {
      var response = await Request(url: 'chatting', body: body).post();
      var resp = jsonDecode(response.body);
      if (response.statusCode == 200) {
        widget.webSocketChannel.sink.add(jsonEncode(body));
        //_messageController.clear();

        var bodyWekSoket = {
          'em_id_penerima': m.emIdPenerima,
          'em_id_pengirim': m.emIdPengirim,
          'pesan': m.pesan,
          'tanggal': m.tanggal,
          'waktu': m.waktu,
          // 'type': m.type,
          'lampiran': m.lampiran,
          'dibaca': m.dibaca,
          'status': m.status,
          'type': 'message',
          'id': resp['insertId']
        };

        widget.webSocketChannel.sink.add(bodyWekSoket);
        print('pesan ${m.pesan}');
        deleteItemById(m.id.toString());

        _fetchPesan1(m, resp['insertId'], m.id);
        controller.statuspengiriman.value = true;
      } else {
        controller.statuspengiriman.value = true;
      }
    } catch (e) {
      controller.statuspengiriman.value = true;
    }

    // var connect=await Api.connectionApi("post", body, "chatting");
    // connect.then((dynamic res) {
    //   if (res.statusCode == 200) {
    //      UtilsAlert.showToast("koneksi buruk pesan tidak terkirim news");
    //      _fetchPesan();
    //   } else {
    //     UtilsAlert.showToast("koneksi buruk pesan tidak terkirim");
    //   }
    // });
  }

  Future<void> deleteItemById(String id) async {
    print('id delete ${id}');

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil daftar item yang disimpan
    List<String>? itemListJson = prefs.getStringList('messages');
    print('id delete ${itemListJson}');

    if (itemListJson != null) {
      // Konversi JSON ke List<Item>
      List<Message> items = itemListJson
          .map((item) => Message.fromJson(jsonDecode(item)))
          .toList();
      print('id delete newws ${items.length}');
      print('id delete newws ${items[0].id}');

      // Hapus item dengan ID yang sesuai
      items.removeWhere((item) => item.id.toString() == id.toString());

      // Konversi kembali List<Item> ke List<String>
      List<String> updatedItemListJson =
          items.map((item) => jsonEncode(item.toJson())).toList();

      // Simpan kembali daftar yang telah diperbarui ke SharedPreferences
      await prefs.setStringList('messages', updatedItemListJson);
    }
  }

  Future<void> savePesanTemporary({
    required String pesan,
  }) async {
    var tanggal = controller.getTanggal();
    var waktu = controller.getWaktu();
    // final body = {
    //   'em_id_penerima': widget.emIdPenerima,
    //   'em_id_pengirim': widget.emIdPengirim,
    //   'pesan': pesan,
    //   'tanggal': tanggal,
    //   'waktu': waktu,
    //   'type': 'message',
    //   'lampiran': '',
    //   'dibaca': '0',
    //   'status': '1',
    //   'is_kirim':0

    // };
    // widget.webSocketChannel.sink.add(jsonEncode(body));
    // _messageController.clear();
    // _pesans.add(body);
    //  _fetchPesan();

    int timestampInSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    Message message = Message(
        id: timestampInSeconds,
        pesan: pesan,
        tanggal: tanggal,
        waktu: waktu,
        emIdPengirim: widget.emIdPengirim,
        emIdPenerima: widget.emIdPenerima,
        lampiran: '',
        dibaca: '0',
        type: 'message',
        status: '1',
        tipeLampiran: 'message',
        isKirim: 0);
    List<Message> messages = await getItemList();
    List<Message> tempMessage = messages;
    tempMessage.add(message);
    _pesans.add(message);
    _scrollToBottomnew();
    saveItemList(tempMessage);
  }

//   Future<void> saveUserToSession(Message user) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   String userJson = jsonEncode(user.toJson()); // Serialize to JSON
//   await prefs.setString('message', userJson); // Save JSON string to SharedPreferences
// }

  Future<void> saveItemList(List<Message> items) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> itemListJson =
        items.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('messages', itemListJson);
  }

  Future<List<Message>> getItemList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? itemListJson = prefs.getStringList('messages');

    if (itemListJson != null) {
      return itemListJson
          .map((item) => Message.fromJson(jsonDecode(item)))
          .toList();
    } else {
      return []; // Mengembalikan list kosong jika tidak ada data
    }
  }

  void _fetchPesan() async {
    var connect = Api.connectionApi('get', {}, 'chatting/history',
        params:
            "&em_id_pengirim=${widget.emIdPengirim}&em_id_penerima=${widget.emIdPenerima}");

    connect.then((dynamic res) async {
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print("resbody:${res.body}");
        _pesans.value = Message.fromJsonToList(data['data']);
        List<Message> messages = await getItemList();
        messages.sort((a, b) => (a.id).compareTo(b.id));
        _pesans.addAll(Message.fromJsonToList(messages));

        _scrollToBottomnew();
      } else {
        UtilsAlert.showToast("tes");
      }
    });
  }

  void _fetchPesan1(Message message, id, idLama) async {
    _pesans.forEach((element) {
      if (element.id == idLama) {
        element.id = id;
        element.isKirim = 1;
      }
    });
    _pesans.refresh();
    // var connect = Api.connectionApi('get', {}, 'chatting/history',
    //     params:
    //         "&em_id_pengirim=${widget.emIdPengirim}&em_id_penerima=${widget.emIdPenerima}");

    // connect.then((dynamic res) {
    //   if (res.statusCode == 200) {
    //     var data = jsonDecode(res.body);
    //     print("resbody:${res.body}");
    //     _pesans.value = data['data'];

    //   } else {
    //     UtilsAlert.showToast("tes");
    //   }
    // });
  }

  Future<void> _tandaSudahDibaca() async {
    var connect = Api.connectionApi("post", {}, "chatting/update-status",
        params:
            "&em_id_pengirim=${widget.emIdPengirim}&em_id_penerima=${widget.emIdPenerima}");
    connect.then((dynamic res) {
      if (res.statusCode != 200) {
        UtilsAlert.showToast("koneksi buruk pesan tidak terkirim");
      }
    });
  }

  void _scrollToBottom() {
    if (_pesans.isNotEmpty) {
      // _scrollController.jumpTo(
      //   index: _pesans.length - 1,
      //   // duration: const Duration(milliseconds: 0),
      //   // curve: Curves.easeOut,
      // );
    }
  }

  void _scrollToBottomnew() {
    if (_pesans.isNotEmpty) {
      // _scrollController.jumpTo(
      //   index: _pesans.length - 1,
      //   // duration: const Duration(milliseconds: 0),
      //   // curve: Curves.easeOut,
      // );

      _scrollController.scrollTo(
          index: _pesans.length - 1, // Indeks terakhir
          duration: Duration(seconds: 1),
          curve: Curves.linear // Durasi 0 untuk menghindari animasi
          );
    }
  }

  void deletePesan() async {
    UtilsAlert.showLoadingIndicator(context);
    print("Message Data new: ${controller.selectedMessage.value!.id}");
    final body = {
      'id': controller.selectedMessage.value!.id,
    };
    print(body);

    var request = await Request(
            url: 'chatting/delete',
            body: body,
            params:
                "&em_id_pengirim=${widget.emIdPengirim}&em_id_penerima=${widget.emIdPenerima}")
        .post();

    var response = jsonDecode(request.body);
    if (request.statusCode == 200) {
      deleteTemporaryData(controller.selectedMessage.value!.id);
      Get.back();

      // List<Message> updatePesan = _pesans.u((p0) =>
      //     p0.id.toString() == controller.selectedMessage.value!.id.toString()).toList();
      // if (updatePesan.isNotEmpty) {
      //   updatePesan[0].status = '0';
      // }

      final data = {
        'type': 'deleteData',
        'id': controller.selectedMessage.value!.id,
        'em_id_pengirim': widget.emIdPengirim,
        'em_id_penerima': widget.emIdPenerima
      };
      widget.webSocketChannel.sink.add(jsonEncode(data));
    } else {}
    // await Api.connectionApi("post", body, "chatting/delete",
    //     params:
    //         "&em_id_pengirim=${widget.emIdPengirim}&em_id_penerima=${widget.emIdPenerima}");

    // // connect.then((dynamic res) {
    // //   if (res.statusCode != 200) {
    // //     UtilsAlert.showToast("koneksi buruk pesan tidak terkirim");
    // //   }
    // // });
    // // _fetchPesan();
    controller.resetSelection();
    controller.releasePesan();
  }

  void deleteTemporaryData(id) {
    _pesans.forEach((element) {
      if (element.id.toString() ==
          controller.selectedMessage.value!.id.toString()) {
        element.status = '0';
      }
    });
    _pesans.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (controller.isSelectionMode.value) {
            controller.resetSelection();
            controller.releasePesan(); // Reset seleksi dan pesan yang dipilih
            return false;
          }
          widget.webSocketChannel.sink.close();
          return true;
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight) * 1,
            child: Obx(
              () => AppBar(
                backgroundColor: Constanst.colorWhite,
                elevation: 0,
                leadingWidth: 50,
                titleSpacing: 0,
                centerTitle: false,
                title: controller.isSelectionMode.value
                    ? Text(
                        'Pesan dipilih',
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Constanst.fgPrimary,
                            fontWeight: FontWeight.w500),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          widget.imageProfil == ""
                              ? Expanded(
                                  flex: 15,
                                  child: SvgPicture.asset(
                                    'assets/avatar_default.svg',
                                    width: 40,
                                    height: 40,
                                  ),
                                )
                              : Expanded(
                                  flex: 15,
                                  child: CircleAvatar(
                                    radius: 25,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${Api.UrlfotoProfile}${widget.imageProfil}",
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Container(
                                          alignment: Alignment.center,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          color: Colors.white,
                                          child: SvgPicture.asset(
                                            'assets/avatar_default.svg',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                        fit: BoxFit.cover,
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                  ),
                                ),
                          Expanded(
                            flex: 60,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.fullNamePenerima}",
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Constanst.fgPrimary,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${widget.title}",
                                    style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: Constanst.fgSecondary,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                leading: controller.isSelectionMode.value
                    ? IconButton(
                        icon: Icon(
                          Iconsax.arrow_left,
                          color: Constanst.fgPrimary,
                          size: 24,
                        ),
                        onPressed: () {
                          controller.resetSelection();
                          controller.releasePesan();
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          Iconsax.arrow_left,
                          color: Constanst.fgPrimary,
                          size: 24,
                        ),
                        onPressed: Get.back,
                      ),
                actions: controller.isSelectionMode.value
                    ? <Widget>[
                        IconButton(
                          icon: Icon(
                            Iconsax.trash,
                            color: Constanst.fgPrimary,
                            size: 24,
                          ),
                          onPressed: deletePesan,
                        ),
                        // IconButton(
                        //   icon: Icon(
                        //     Iconsax.forward_square,
                        //     color: Constanst.fgPrimary,
                        //     size: 24,
                        //   ),
                        //   onPressed: _forwardPesan,
                        // ),
                      ]
                    : null,
              ),
            ),
          ),
          resizeToAvoidBottomInset: true,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: widget.webSocketChannel.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        // Handle errors
                      }
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          final message = snapshot.data.toString();

                          print('mesasge data new new ${message}');
                          final messageData = jsonDecode(message);
                          if (messageData['type'] != 'error') {
                            //_tandaSudahDibaca();
                            _fetchPesan();
                            // _pesans.add(Message(
                            //     id: messageData['id'],
                            //     pesan: messageData['pesan'],
                            //     tanggal: messageData['tanggal'],
                            //     waktu: messageData['waktu'],
                            //     emIdPengirim: messageData['em_id_pengirim'],
                            //     emIdPenerima: messageData['em_id_penerima'],
                            //     lampiran: lampiran,
                            //     dibaca: messageData['dibaca'],
                            //     type: messageData['type'],
                            //     status: messageData['status'],
                            //     tipeLampiran: messageData['tipe_lampiran'],
                            //     isKirim: 1));
                            // _scrollToBottomnew();

                            // _tandaSudahDibaca();
                          }
                          if (messageData['type'] == 'deleteData') {
                            _fetchPesan();
                          }
                        }
                      }
                      return Obx(
                        () => _pesans.isEmpty
                            ? SizedBox()
                            : ScrollablePositionedList.builder(
                                itemScrollController: _scrollController,
                                itemCount: _pesans.length,
                                initialScrollIndex: _pesans.length - 1,
                                itemBuilder: (context, index) {
                                  var messageData = _pesans[index];
                                  final isKirim = messageData.isKirim;

                                  final messageText = messageData.pesan;
                                  final dibacaText = messageData.dibaca == 1 ||
                                      messageData.dibaca == "1";
                                  final statusText = messageData.status == 1 ||
                                      messageData.status == "1";

                                  final waktuText =
                                      messageData.waktu.substring(0, 5);

                                  final isSender = messageData.emIdPengirim ==
                                      "${widget.emIdPengirim}";

                                  final isImage = messageData.lampiran != "";
                                  final urlImage = messageData.lampiran;

                                  return GestureDetector(
                                    onLongPressStart: (_) {
                                      controller.isSelectionMode.value = false;
                                      Future.delayed(
                                          const Duration(milliseconds: 200),
                                          () {
                                        if (!controller.isSelectionMode.value) {
                                          if (isSender && statusText) {
                                            controller
                                                .tekanLamaPesan(messageData);
                                          }
                                        }
                                      });
                                    },
                                    onLongPressEnd: (_) {
                                      controller.releasePesan();
                                    },
                                    child: Obx(
                                      () => Stack(
                                        children: [
                                          if (messageData ==
                                              controller
                                                  .selectedMessage.value) ...[
                                            Positioned.fill(
                                              child: Container(
                                                color: Color.fromARGB(
                                                    29, 0, 22, 103),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                            ),
                                          ],
                                          Align(
                                            alignment: isSender
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            child: Container(
                                              margin: const EdgeInsets.all(8.0),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 8.0),
                                              decoration: BoxDecoration(
                                                color: isSender
                                                    ? controller.isSelectionMode
                                                                .value &&
                                                            messageData ==
                                                                controller
                                                                    .selectedMessage
                                                                    .value
                                                        ? const Color.fromARGB(
                                                            41, 0, 22, 103)
                                                        : Constanst.onPrimary
                                                    : Constanst.greyLight100,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              constraints: isImage
                                                  ? statusText
                                                      ? BoxConstraints(
                                                          maxWidth: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.65,
                                                        )
                                                      : BoxConstraints(
                                                          maxWidth: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                        )
                                                  : const BoxConstraints(),
                                              child: Column(
                                                crossAxisAlignment: (isSender &&
                                                        isImage &&
                                                        messageText.isNotEmpty)
                                                    ? CrossAxisAlignment.start
                                                    : (isSender
                                                        ? CrossAxisAlignment.end
                                                        : CrossAxisAlignment
                                                            .start),
                                                children: [
                                                  if (isImage) ...[
                                                    statusText
                                                        ? InkWell(
                                                            onTap: () {
                                                              showDialog(
                                                                barrierColor: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        1),
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return Dialog(
                                                                    insetPadding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .black,
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        InteractiveViewer(
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            imageUrl:
                                                                                "${Api.urlFotoChat}$urlImage",
                                                                            fit:
                                                                                BoxFit.contain,
                                                                            placeholder: (context, url) =>
                                                                                const Center(
                                                                              child: CircularProgressIndicator(),
                                                                            ),
                                                                            errorWidget: (context, url, error) =>
                                                                                const Center(
                                                                              child: Icon(
                                                                                Icons.error,
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          right:
                                                                              10,
                                                                          top:
                                                                              10,
                                                                          child:
                                                                              IconButton(
                                                                            icon:
                                                                                const Icon(Icons.close, color: Colors.white),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: Center(
                                                              child: Container(
                                                                  // width: 350,
                                                                  height: 350,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                  ),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0), // Adjust the radius as needed
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl:
                                                                          "${Api.urlFotoChat}$urlImage",
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      width:
                                                                          250,
                                                                      progressIndicatorBuilder: (context,
                                                                              url,
                                                                              downloadProgress) =>
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.5,
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        child: CircularProgressIndicator(
                                                                            value:
                                                                                downloadProgress.progress),
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          const Icon(
                                                                              Icons.error),
                                                                    ),
                                                                  )),
                                                            ),
                                                          )
                                                        : Container(),
                                                  ],
                                                  if (isImage &&
                                                      messageText != "") ...[
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    mainAxisSize: isImage
                                                        ? MainAxisSize.max
                                                        : MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      statusText
                                                          ? Flexible(
                                                              child: Text(
                                                                messageText ??
                                                                    "",
                                                                style:
                                                                    TextStyle(
                                                                  color: isSender
                                                                      ? Constanst
                                                                          .colorWhite
                                                                      : Constanst
                                                                          .colorText3,
                                                                ),
                                                              ),
                                                            )
                                                          : Flexible(
                                                              child: Text(
                                                                isSender
                                                                    ? "Anda menghapus pesan ini"
                                                                    : "Pesan ini dihapus",
                                                                style:
                                                                    TextStyle(
                                                                  color: isSender
                                                                      ? Constanst
                                                                          .colorText2
                                                                      : Constanst
                                                                          .colorText2,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      if (isSender) ...[
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              "$waktuText",
                                                              style: const TextStyle(
                                                                  fontSize: 8,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            const SizedBox(
                                                              width: 2,
                                                            ),
                                                            isKirim.toString() ==
                                                                    '1'
                                                                ? Icon(
                                                                    Icons.check,
                                                                    color: dibacaText
                                                                        ? Constanst
                                                                            .color5
                                                                        : Constanst
                                                                            .color1,
                                                                    size: 12,
                                                                    weight:
                                                                        1000,
                                                                  )
                                                                : Icon(
                                                                    Iconsax
                                                                        .timer_1,
                                                                    color: Constanst
                                                                        .color1,
                                                                    size: 12,
                                                                    weight:
                                                                        1000,
                                                                  ),
                                                          ],
                                                        ),
                                                      ],
                                                      if (!isSender) ...[
                                                        Text(
                                                          "$waktuText",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 8),
                                                        )
                                                      ],
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: null,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Constanst.colorWhite,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            // border: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(10),
                            //   borderSide: BorderSide(
                            //     color: Constanst.onPrimary,
                            //   ),
                            // ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Constanst.onPrimary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Constanst.onPrimary,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.attach_file,
                                size: 28,
                                color: Constanst.onPrimary,
                              ),
                              onPressed: () async {
                                showImagePickerBottomSheet(context);
                              },
                            ),
                          ),
                          style: TextStyle(
                            color: Constanst.colorText3,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Constanst.onPrimary,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Iconsax.send_1,
                            color: Constanst.colorWhite,
                          ),
                          onPressed: () async {
                            final message = _messageController.text;
                            if (message.isNotEmpty) {
                              //  await kirimPesan(pesan: message);
                              await savePesanTemporary(pesan: message);
                              _messageController.clear();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
