import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:siscom_operasional/controller/chat_controller.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/image_picker_bottom_sheet.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

TextEditingController _messageController = TextEditingController();
ScrollController _scrollController = ScrollController();

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
  var _pesans = [].obs;
  final Rx<File?> imgFile = Rx<File?>(null);

  @override
  void initState() {
    super.initState();
    // _tandaSudahDibaca();
    _fetchPesan();
    _setData();
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
    var base64fotoUser = ''.obs;
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      File? imgFile;
      imgFile = File(image.path);

      var bytes = imgFile.readAsBytesSync();
      base64fotoUser.value = base64Encode(bytes);

      var type = controller.getFileExtension(imgFile.toString());

      final body = {
        'em_id_penerima': widget.emIdPenerima,
        'em_id_pengirim': widget.emIdPengirim,
        'pesan': '',
        'tanggal': controller.getTanggal(),
        'waktu': controller.getWaktu(),
        'type': type,
        'lampiran': '$base64fotoUser',
        'dibaca': false
      };
      final body2 =
          "{'em_id_penerima': '${widget.emIdPenerima}','em_id_pengirim': '${widget.emIdPengirim}','pesan': '','tanggal': '${controller.getTanggal()}','waktu': '${controller.getWaktu()}','type': '$type','lampiran': '$base64fotoUser','dibaca': '0'}";
      widget.webSocketChannel.sink.add(jsonEncode(body));
      _messageController.clear();

      var connect = Api.connectionApi("post", body, "chatting");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          _pesans.add(body2.toString());
        } else {
          UtilsAlert.showToast("koneksi buruk pesan tidak terkirim");
        }
      });

      _scrollToBottom();

      Get.back();
    } on PlatformException {
      // print(e);
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
    // controller.img.value = null;
  }

  Future<void> kirimPesan({
    required String pesan,
  }) async {
    var tanggal = controller.getTanggal();
    var waktu = controller.getWaktu();
    final body = {
      'em_id_penerima': widget.emIdPenerima,
      'em_id_pengirim': widget.emIdPengirim,
      'pesan': pesan,
      'tanggal': tanggal,
      'waktu': waktu,
      'type': 'message',
      'lampiran': '',
      'dibaca': '0'
    };
    widget.webSocketChannel.sink.add(jsonEncode(body));
    _messageController.clear();

    var connect = Api.connectionApi("post", body, "chatting");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        _pesans.add(jsonEncode(body));
      } else {
        UtilsAlert.showToast("koneksi buruk pesan tidak terkirim");
      }
    });

    _scrollToBottom();
  }

  void _fetchPesan() async {
    var connect = Api.connectionApi('get', {}, 'chatting/history',
        params: {widget.emIdPengirim, widget.emIdPenerima});

    connect.then((dynamic res) {
      print("${res.statusCode}");
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print("resbody:${res.body}");
        final formattedData = data.map((pesan) {
          return {
            'em_id_penerima': pesan["em_id_penerima"].toString(),
            'em_id_pengirim': pesan["em_id_pengirim"].toString(),
            'pesan': pesan["pesan"].toString(),
            'tanggal': pesan["tanggal"].toString(),
            'waktu': pesan["waktu"].toString(),
            'type': 'message',
            'lampiran': pesan["lampiran"].toString(),
          };
        }).toList();

        // for (var element in formattedData) {
        //   _pesans.add(jsonEncode(element));
        // }

        _scrollToBottom();
      }
    });
  }

  Future<void> _tandaSudahDibaca() async {
    var connect = Api.connectionApi("post", {}, "chatting/update-status",
        params: {widget.emIdPengirim, widget.emIdPenerima});
    connect.then((dynamic res) {
      if (res.statusCode != 200) {
        UtilsAlert.showToast("koneksi buruk pesan tidak terkirim");
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          widget.webSocketChannel.sink.close();
          return true;
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight) * 1,
            child: AppBar(
              backgroundColor: Constanst.colorWhite,
              elevation: 0,
              leadingWidth: 50,
              titleSpacing: 0,
              centerTitle: false,
              title: Row(
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  width: MediaQuery.of(context).size.width,
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.progress),
                                ),
                                errorWidget: (context, url, error) => Container(
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
              // Text(
              //   "Change Log",
              //   style: GoogleFonts.inter(
              //       color: Constanst.fgPrimary,
              //       fontWeight: FontWeight.w500,
              //       fontSize: 20),
              // ),
              leading: IconButton(
                icon: Icon(
                  Iconsax.arrow_left,
                  color: Constanst.fgPrimary,
                  size: 24,
                ),
                onPressed: Get.back,
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
                          final messageData = jsonDecode(message);
                          if (messageData['type'] != 'error') {
                            _pesans.add(message);
                            _scrollToBottom();
                            // _tandaSudahDibaca();
                            print(message);
                          }
                        }
                      }
                      return Obx(
                        () => ListView.builder(
                          controller: _scrollController,
                          itemCount: _pesans.length,
                          itemBuilder: (context, index) {
                            final messageData =
                                jsonDecode(_pesans[index].toString());

                            final messageText = messageData['pesan'];
                            final statusText = messageData['dibaca'] == "1";
                            final waktuText =
                                messageData['waktu'].substring(0, 5);

                            final isSender = messageData['em_id_pengirim'] ==
                                "${widget.emIdPengirim}";

                            var img = false.obs;
                            if (messageData['lampiran'] != '' ||
                                messageData['lampiran'] != "null") {
                              // img = true.obs;
                            }

                            return Align(
                              alignment: isSender
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                  color: isSender
                                      ? Constanst.onPrimary
                                      : Constanst.greyLight100,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                constraints: img.isTrue
                                    ? BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.65,
                                      )
                                    : const BoxConstraints(),
                                child: Column(
                                  crossAxisAlignment: isSender
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    if (img.isTrue) ...[
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            barrierColor:
                                                Colors.black.withOpacity(1),
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                insetPadding: EdgeInsets.zero,
                                                backgroundColor: Colors.black,
                                                child: Stack(
                                                  children: [
                                                    InteractiveViewer(
                                                      child: Image.file(
                                                        imgFile.value!,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: 10,
                                                      top: 10,
                                                      child: IconButton(
                                                        icon: const Icon(
                                                            Icons.close,
                                                            color:
                                                                Colors.white),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
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
                                            height: 300,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                image: DecorationImage(
                                                  image:
                                                      FileImage(imgFile.value!),
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                    // Padding(
                                    //   padding:
                                    //       const EdgeInsets.only(bottom: 8.0),
                                    //   child: Image.network(
                                    //     imageUrl,
                                    //     width: 150, // Sesuaikan ukuran gambar
                                    //     height: 150,
                                    //     fit: BoxFit.cover,
                                    //   ),
                                    // ),

                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        if (img.isFalse)
                                          Flexible(
                                            child: Text(
                                              messageText ?? "",
                                              style: TextStyle(
                                                color: isSender
                                                    ? Constanst.colorWhite
                                                    : Constanst.colorText3,
                                              ),
                                            ),
                                          ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        if (isSender) ...[
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "$waktuText",
                                                style: const TextStyle(
                                                    fontSize: 8,
                                                    color: Colors.white),
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              Icon(
                                                Icons.check,
                                                color: statusText
                                                    ? Constanst.color5
                                                    : Constanst.color1,
                                                size: 12,
                                                weight: 1000,
                                              ),
                                            ],
                                          ),
                                        ],
                                        if (!isSender) ...[
                                          Text(
                                            "$waktuText",
                                            style: const TextStyle(fontSize: 8),
                                          )
                                        ],
                                      ],
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
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () async {
                          showImagePickerBottomSheet(context);
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: null,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          final message = _messageController.text;
                          if (message.isNotEmpty) {
                            await kirimPesan(pesan: message);
                            _messageController.clear();
                          }
                        },
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
