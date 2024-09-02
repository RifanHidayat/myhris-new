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
import 'package:siscom_operasional/screen/pesan/pesan%20copy.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/image_editing.dart';
import 'package:siscom_operasional/utils/widget/image_picker_bottom_sheet.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:flutter_image_compress/flutter_image_compress.dart';

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
  var _pesans = [].obs;
  var lampiran = ''.obs;
  var isLoading = false.obs;
final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    
    super.initState();
    _tandaSudahDibaca();
    _fetchPesan();
    _setData();
    // _focusNode.addListener(() {
    //     print('masuk sini fokus');
    //   if (_focusNode.hasFocus) {
      
    //     // Fungsi yang dijalankan saat TextFormField pertama kali diaktifkan
    //     _scrollToBottom();
    //   }
    // });
  }
 void dispose() {
    _focusNode.dispose();
 
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
            _fetchPesan();

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

            //WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
           // });
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
      'dibaca': '0',
      'status': '1',
      'database':AppData.selectedDatabase
    };
    widget.webSocketChannel.sink.add(jsonEncode(body));
    _messageController.clear();
    _pesans.add(jsonEncode(body));
    _fetchPesan();
    //WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    //});

    // await Api.connectionApi("post", body, "chatting");
    // connect.then((dynamic res) {
    //   if (res.statusCode == 200) {
    //   } else {
    //     UtilsAlert.showToast("koneksi buruk pesan tidak terkirim");
    //   }
    // });
    
    // _fetchPesan();
  }

  void _fetchPesan() async {
    var connect = Api.connectionApi('get', {}, 'chatting/history',
        params:
            "&em_id_pengirim=${widget.emIdPengirim}&em_id_penerima=${widget.emIdPenerima}");

    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print("resbody:${res.body}");
        var formattedData = (data['data']).map((pesan) {
          return {
            'id': pesan['id'],
            'em_id_penerima': pesan['em_id_penerima'],
            'em_id_pengirim': pesan['em_id_pengirim'],
            'pesan': pesan['pesan'],
            'tanggal': pesan['tanggal'],
            'waktu': pesan['waktu'],
            'type': 'message',
            'lampiran': pesan['lampiran'],
            'dibaca': pesan['dibaca'],
            'status': pesan['status'],
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

      //  WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
       // });
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
    if (_pesans.isNotEmpty) {
    
  _scrollController.scrollTo(
              index:  _pesans.length - 1, // Indeks terakhir
              duration: Duration(seconds: 1),
   curve: Curves.linear // Durasi 0 untuk menghindari animasi
            );
      _scrollController.jumpTo(
        index: _pesans.length - 1,
        // duration: const Duration(milliseconds: 0),
        // curve: Curves.easeOut,
      );
    }
  }

  void deletePesan() async {
    print("Message Data: ${controller.selectedMessage.value}");
    final body = {
      'id': controller.selectedMessage.value!.id
    };
    print(body);
    await Api.connectionApi("post", body, "chatting/delete",
        params:
            "&em_id_pengirim=${widget.emIdPengirim}&em_id_penerima=${widget.emIdPenerima}");
    final data = {
      'type': 'deleteData',
    };
    //_fetchPesan();
    // widget.webSocketChannel.sink.add(jsonEncode(data));
    // connect.then((dynamic res) {
    //   if (res.statusCode != 200) {
    //     UtilsAlert.showToast("koneksi buruk pesan tidak terkirim");
    //   }
    // });
    // _fetchPesan();
    controller.resetSelection();
    controller.releasePesan();
    _scrollToBottom();
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
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Expanded(
                child: Container(
                   height: double.maxFinite,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          height: double.maxFinite,

                        
                          child: Expanded(
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
                                      _tandaSudahDibaca();
                                      _fetchPesan();
                                      // _pesans.add(message);
                                    
                                      //WidgetsBinding.instance.addPostFrameCallback((_) {
                                        _scrollToBottom();
                                     // });
                                    }
                                  }
                                }
                                return Obx(
                                  () => _pesans.isEmpty?SizedBox(): ScrollablePositionedList.builder(
                                    itemScrollController: _scrollController,
                                    //  initialScrollIndex: _pesans.length - 1,
                                    itemCount: _pesans.length,
                                    itemBuilder: (context, index) {
                                      final messageData =
                                          jsonDecode(_pesans[index].toString());
                                    
                                      final messageText = messageData['pesan'];
                                      final dibacaText = messageData['dibaca'] == 1 ||
                                          messageData['dibaca'] == "1";
                                      final statusText = messageData['status'] == 1 ||
                                          messageData['status'] == "1";
                                    
                                      final waktuText =
                                          messageData['waktu'].substring(0, 5);
                                    
                                      final isSender = messageData['em_id_pengirim'] ==
                                          "${widget.emIdPengirim}";
                                    
                                      final isImage = messageData['lampiran'] != "";
                                      final urlImage = messageData['lampiran'];
                                    
                                      return GestureDetector(
                                        onLongPressStart: (_) {
                                          controller.isSelectionMode.value = false;
                                          Future.delayed(
                                              const Duration(milliseconds: 500), () {
                                            if (!controller.isSelectionMode.value) {
                                              if (isSender && statusText) {
                                                controller.tekanLamaPesan(messageData);
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
                                                  controller.selectedMessage.value) ...[
                                                Positioned.fill(
                                                  child: Container(
                                                    color: Color.fromARGB(29, 0, 22, 103),
                                                    width:
                                                        MediaQuery.of(context).size.width,
                                                  ),
                                                ),
                                              ],
                                              Align(
                                                alignment: isSender
                                                    ? Alignment.centerRight
                                                    : Alignment.centerLeft,
                                                child: Container(
                                                  margin: const EdgeInsets.all(8.0),
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 8.0, vertical: 8.0),
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
                                                              maxWidth:
                                                                  MediaQuery.of(context)
                                                                          .size
                                                                          .width *
                                                                      0.65,
                                                            )
                                                          : BoxConstraints(
                                                              maxWidth:
                                                                  MediaQuery.of(context)
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
                                                            : CrossAxisAlignment.start),
                                                    children: [
                                                      if (isImage) ...[
                                                        statusText
                                                            ? InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                    barrierColor: Colors
                                                                        .black
                                                                        .withOpacity(1),
                                                                    context: context,
                                                                    builder: (context) {
                                                                      return Dialog(
                                                                        insetPadding:
                                                                            EdgeInsets
                                                                                .zero,
                                                                        backgroundColor:
                                                                            Colors.black,
                                                                        child: Stack(
                                                                          children: [
                                                                            InteractiveViewer(
                                                                              child:
                                                                                  CachedNetworkImage(
                                                                                imageUrl:
                                                                                    "${Api.urlFotoChat}$urlImage",
                                                                                fit: BoxFit
                                                                                    .contain,
                                                                                placeholder:
                                                                                    (context, url) =>
                                                                                        const Center(
                                                                                  child:
                                                                                      CircularProgressIndicator(),
                                                                                ),
                                                                                errorWidget: (context,
                                                                                        url,
                                                                                        error) =>
                                                                                    const Center(
                                                                                  child:
                                                                                      Icon(
                                                                                    Icons
                                                                                        .error,
                                                                                    color:
                                                                                        Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              right: 10,
                                                                              top: 10,
                                                                              child:
                                                                                  IconButton(
                                                                                icon: const Icon(
                                                                                    Icons
                                                                                        .close,
                                                                                    color:
                                                                                        Colors.white),
                                                                                onPressed:
                                                                                    () {
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
                                                                      height: 350,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius
                                                                                .circular(
                                                                                    12.0),
                                                                      ),
                                                                      child: ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius
                                                                                .circular(
                                                                                    12.0), // Adjust the radius as needed
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          imageUrl:
                                                                              "${Api.urlFotoChat}$urlImage",
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          width: 250,
                                                                          progressIndicatorBuilder:
                                                                              (context,
                                                                                      url,
                                                                                      downloadProgress) =>
                                                                                  Container(
                                                                            alignment:
                                                                                Alignment
                                                                                    .center,
                                                                            height: MediaQuery.of(
                                                                                        context)
                                                                                    .size
                                                                                    .height *
                                                                                0.5,
                                                                            width: MediaQuery.of(
                                                                                    context)
                                                                                .size
                                                                                .width,
                                                                            child: CircularProgressIndicator(
                                                                                value: downloadProgress
                                                                                    .progress),
                                                                          ),
                                                                          errorWidget: (context,
                                                                                  url,
                                                                                  error) =>
                                                                              const Icon(Icons
                                                                                  .error),
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
                                                                    messageText ?? "",
                                                                    style: TextStyle(
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
                                                                    style: TextStyle(
                                                                      color: isSender
                                                                          ? Constanst
                                                                              .colorText2
                                                                          : Constanst
                                                                              .colorText2,
                                                                      fontStyle: FontStyle
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
                                                                  CrossAxisAlignment.end,
                                                              children: [
                                                                Text(
                                                                  "$waktuText",
                                                                  style: const TextStyle(
                                                                      fontSize: 8,
                                                                      color:
                                                                          Colors.white),
                                                                ),
                                                                const SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Icon(
                                                                  Icons.check,
                                                                  color: dibacaText
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
                                                              style: const TextStyle(
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
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                               focusNode: _focusNode, 
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
                                  await kirimPesan(pesan: message);
                                  _messageController.clear();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
