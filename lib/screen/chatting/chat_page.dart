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
import 'package:image/image.dart' as img;

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
  var lampiran = ''.obs;
  // final Rx<File?> imgFile = Rx<File?>(null);

  @override
  void initState() {
    super.initState();
    _tandaSudahDibaca();
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
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        maxWidth: 2056,
        maxHeight: 2056,
        imageQuality: 75,
      );
      if (image == null) return;

      File? imgFile;
      imgFile = File(image.path);
      img.Image? images = img.decodeImage(imgFile.readAsBytesSync());
      List<int> pngBytes = img.encodePng(images!);

      String base64Image = base64Encode(pngBytes);

      // var type = controller.getFileExtension(pngBytes.toString());
      var tanggal = controller.getTanggal();
      var waktu = controller.getWaktu();
      final bodyApi = {
        'em_id_penerima': widget.emIdPenerima,
        'em_id_pengirim': widget.emIdPengirim,
        'pesan': '',
        'tanggal': tanggal,
        'waktu': waktu,
        'type': ".png",
        'lampiran': base64Image,
        'dibaca': '0'
      };

      var connect = Api.connectionApi("post", bodyApi, "chatting");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          _fetchPesan();

          final bodyWebsocket = {
            'em_id_penerima': widget.emIdPenerima,
            'em_id_pengirim': widget.emIdPengirim,
            'pesan': '',
            'tanggal': tanggal,
            'waktu': waktu,
            'type': 'message',
            'lampiran': lampiran.value,
            'dibaca': '1'
          };

          widget.webSocketChannel.sink.add(jsonEncode(bodyWebsocket));
          _messageController.clear();
          _pesans.add(jsonEncode(bodyWebsocket));

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        } else {
          UtilsAlert.showToast("koneksi buruk pesan tidak terkirim");
        }
      });

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
    _pesans.add(jsonEncode(body));

    var connect = Api.connectionApi("post", body, "chatting");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
      } else {
        UtilsAlert.showToast("koneksi buruk pesan tidak terkirim");
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _fetchPesan() async {
    var connect = Api.connectionApi('get', {}, 'chatting/history',
        params:
            "&em_id_pengirim=${widget.emIdPengirim}&em_id_penerima=${widget.emIdPenerima}");

    connect.then((dynamic res) {
      print("${res.statusCode}");
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print("resbody:${res.body}");
        var formattedData = (data['data']).map((pesan) {
          return {
            'em_id_penerima': pesan['em_id_penerima'],
            'em_id_pengirim': pesan['em_id_pengirim'],
            'pesan': pesan['pesan'],
            'tanggal': pesan['tanggal'],
            'waktu': pesan['waktu'],
            'type': 'message',
            'lampiran': pesan['lampiran'],
            'dibaca': pesan['dibaca'],
          };
        }).toList();

        for (var element in formattedData) {
          _pesans.add(jsonEncode(element));
          lampiran.value = element['lampiran'];
        }

        if (formattedData.isNotEmpty) {
          var lastLampiran = formattedData.last['lampiran'];
          lampiran.value = lastLampiran;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    });
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
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 200), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        });
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

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _scrollToBottom();
                            });

                            _tandaSudahDibaca();
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
                            final statusText = messageData['dibaca'] == 1 ||
                                messageData['dibaca'] == "1";

                            final waktuText =
                                messageData['waktu'].substring(0, 5);

                            final isSender = messageData['em_id_pengirim'] ==
                                "${widget.emIdPengirim}";

                            final isImage = messageData['lampiran'] != "";
                            final urlImage = messageData['lampiran'];

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
                                constraints: isImage
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
                                    if (isImage) ...[
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
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "${Api.urlFotoChat}$urlImage",
                                                        fit: BoxFit.contain,
                                                        placeholder:
                                                            (context, url) =>
                                                                const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Center(
                                                          child: Icon(
                                                            Icons.error,
                                                            color: Colors.white,
                                                          ),
                                                        ),
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
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "${Api.urlFotoChat}$urlImage",
                                              fit: BoxFit.cover,
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      Container(
                                                alignment: Alignment.center,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.5,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child:
                                                    CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        if (!isImage) ...[
                                          Flexible(
                                            child: Text(
                                              messageText ??
                                                  "${Api.urlFotoChat}$urlImage",
                                              style: TextStyle(
                                                color: isSender
                                                    ? Constanst.colorWhite
                                                    : Constanst.colorText3,
                                              ),
                                            ),
                                          ),
                                        ],
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
