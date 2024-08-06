// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:get/utils.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:siscom_operasional/database/database_services.dart';
// import 'package:siscom_operasional/utils/app_data.dart';
// import 'package:siscom_operasional/utils/constans.dart';
// import 'package:siscom_operasional/utils/widget/text_labe.dart';
// import 'package:sqflite/sqflite.dart';

// import '../../controller/chatting.dart';
// import '../../utils/api.dart';

// class ChattingPage extends StatefulWidget {
//   var image, fullName, title,em_id;
//   ChattingPage({super.key, this.image, this.fullName, this.title,this.em_id});

//   @override
//   State<ChattingPage> createState() => _ChattingPageState();


// }


// var chattingCtr=Get.put(ChattingController());
//     Database? db;


  

// class _ChattingPageState extends State<ChattingPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
   
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
        
//         child: Container(
//          color: Constanst.greyLight300,
//           child: Column(
//             children: [_appBar(),
//           Expanded(
//             child: Container(
//               height: double.maxFinite,
//               child: Column(
//                 children: [
//                     Expanded(
//                 child: Container(
//                   height: double.maxFinite,
//                   child: SingleChildScrollView(
//                     reverse: true,
//                     child: bodyChat()),
//                 ),
//               ),
//               _bottomNavigationBar()
//                 ],
//               ),
//             ),
//           )
//             ],
//           ),
//         ),
//       ),
//     );
//   }



// Widget bodyChat(){
//   return Container(
  
  
//     alignment: Alignment.bottomCenter,
//     padding: EdgeInsets.all(12 ),
//     child: Align(
//       alignment: Alignment.bottomCenter,
//       child: Obx(() => Column(
//    crossAxisAlignment: CrossAxisAlignment.end,
//    mainAxisAlignment: MainAxisAlignment.end,
      
//         children:chattingCtr.chat.map((item)   {
//           var data=item;
//           return Container(
//              padding: EdgeInsets.only(top: 6),
//             width: MediaQuery.of(context).size.width,
//             child: AppData.informasiUser![0].em_id.toString()==data.emIdPengirim.toString()? Align(
//               alignment: Alignment.centerRight,
//               child:   Container(
//                 constraints: BoxConstraints(
//               maxWidth: MediaQuery.of(context).size.width * 0.8, // Set max width here
//             ),
//                 child: IntrinsicWidth(
//                   child: Container(
                        
//                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Constanst.colorPrimary),
//                     padding: EdgeInsets.all(8),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         TextLabell(text: data.message.toString(),color:Colors.white,),
//                         SizedBox(height: 4,),
//                         Row(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                              TextLabell(text: data.waktu.toString(),color: Constanst.greyLight100,),
//                              SizedBox(width: 4,),
//                              Icon(Icons.check,size: 13,color: Constanst.greyLight50,)
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             )
            
//             : Padding(
//               padding: EdgeInsets.only(top: 6),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child:Container(
//                   constraints: BoxConstraints(
//                 maxWidth: MediaQuery.of(context).size.width * 0.8, // Set max width here
//               ),
//                   child: IntrinsicWidth(
//                     child: Container(
//                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.white),
//                       padding: EdgeInsets.all(8),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           TextLabell(text: data.message.toString(),color: Constanst.blackSurface,),
//                           SizedBox(height: 4,),
//                           Row(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                         mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                                TextLabell(text: data.waktu.toString(),color: Constanst.blackSurface.withOpacity(0.5),),
                              
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }).toList()
//       ),)
//     ),
//   );
// }



// Widget _bottomNavigationBar(){
//   return Container(
//     padding: EdgeInsets.only(left: 12,right: 12,top: 12,bottom: 12),
//         child: Row(
//           children: [
//             Expanded(
//               flex: 85,
//               child: TextField(
//                 controller: chattingCtr.messageCtr.value,
//                 decoration: InputDecoration(
//                  border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(32.0),
                  
//                 ),
                
                  
//                   hintText: 'Message....',
//                 ),
                
//               ),
//             ),
//             Expanded(
//               flex: 15,
//               child:  Obx(() => chattingCtr.messageCtr.value.text==""?InkWell(
//                 onTap: () async{
//                       db = await DatabaseService.database;
//                   print(widget.em_id.toString());
//                   chattingCtr.insert(db!, emIdPengirim: AppData.informasiUser![0].em_id.toString(), emIdPenerima: widget.em_id.toString(), pesan: chattingCtr.messageCtr.value.text);

//                 },
//                 child: CircleAvatar(
//                   radius: 20,
//                   backgroundColor: Constanst.colorWhite,
//                   child: Icon(Iconsax.send_1,color: Colors.black,)),
//               ): InkWell(
//                 onTap: () async{
//                     db = await DatabaseService.database;

//                     chattingCtr.insert(db!, emIdPengirim: AppData.informasiUser![0].em_id.toString(), emIdPenerima: widget.em_id.toString(), pesan: chattingCtr.messageCtr.value.text);
//                 },
//                 child: CircleAvatar(
//                   radius: 20,
//                   backgroundColor: Constanst.onPrimary,
//                   child: Icon(Iconsax.send_1,color: Colors.white,)),
//               )))
//           ],
//         ),
//       );
// }
//   Widget _appBar() {
//     return Material(
//       elevation: 2,
//       child: Padding(
//         padding: EdgeInsets.only(top: 38, left: 12, bottom: 12, right: 12),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             InkWell(
//                 onTap: () {
//                   Get.back();
//                 },
//                 child: Icon(Iconsax.arrow_left, size: 24, weight: 40)),
//             SizedBox(
//               width: 4,
//             ),
//             widget.image == ""
//                 ? Expanded(
//                     flex: 15,
//                     child: SvgPicture.asset(
//                       'assets/avatar_default.svg',
//                       width: 50,
//                       height: 50,
//                     ),
//                   )
//                 : CircleAvatar(
//                     radius: 25,
//                     child: ClipOval(
//                       child: CachedNetworkImage(
//                         imageUrl: "${Api.UrlfotoProfile}${widget.image}",
//                         progressIndicatorBuilder:
//                             (context, url, downloadProgress) => Container(
//                           alignment: Alignment.center,
//                           height: MediaQuery.of(context).size.height * 0.5,
//                           width: MediaQuery.of(context).size.width,
//                           child: CircularProgressIndicator(
//                               value: downloadProgress.progress),
//                         ),
//                         errorWidget: (context, url, error) => Container(
//                           color: Colors.white,
//                           child: SvgPicture.asset(
//                             'assets/avatar_default.svg',
//                             width: 50,
//                             height: 50,
//                           ),
//                         ),
//                         fit: BoxFit.cover,
//                         width: 50,
//                         height: 50,
//                       ),
//                     ),
//                   ),
//             Padding(
//               padding: const EdgeInsets.only(left: 12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "${widget.fullName}",
//                     style: GoogleFonts.inter(
//                         fontSize: 16,
//                         color: Constanst.fgPrimary,
//                         fontWeight: FontWeight.w500),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     "${widget.title}",
//                     style: GoogleFonts.inter(
//                         fontSize: 12,
//                         color: Constanst.fgSecondary,
//                         fontWeight: FontWeight.w400),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
