import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';
import 'package:onboarding/onboarding.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:siscom_operasional/screen/login.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late Material materialButton;
  late int index;
  final onboardingPagesList = [
    //------------page 1
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 0.0,
            color: Colors.white,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(45.0, 90.0, 45.0, 45.0),
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/bg1.svg',
                      ),
                      Positioned(
                        bottom: 28,
                        child: Container(
                          width: MediaQuery.of(Get.context!).size.width - 130,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: MediaQuery.of(Get.context!).size.width / 2,
                              child: Align(
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  'assets/bg1-onboarding.svg',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // child: Image.asset('assets/logo_splash.png',
                  //          color: Colors.white,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Selamat datang di SISCOM HRIS!',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 32.0,
                        letterSpacing: -0.021,
                        fontWeight: FontWeight.w600,
                        color: HexColor('#202327'),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 45.0, vertical: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'SISCOM HRIS memberikan solusi untuk proses HR online di Perusahaan Anda. Kini, semua kebutuhan HR dapat terintegrasi dalam satu aplikasi dengan data yang akurat dan real time.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.011,
                          color: HexColor('#202327')),
                    ),
                  ),
                ),
                // const Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       'Keep your files in closed safe so you can\'t lose them. Consider TrueNAS.',
                //       style: pageInfoStyle,
                //       textAlign: TextAlign.left,
                //     ),
                //   ),
                // ),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Keep your files in closed safe so you can\'t lose them. Consider TrueNAS.',
                      style: pageInfoStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Keep your files in closed safe so you can\'t lose them. Consider TrueNAS.',
                      style: pageInfoStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    //------------page 2
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 0.0,
            color: Colors.white,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 90.0,
                ),
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      'assets/bg2.svg',
                    ),
                    Positioned(
                      bottom: 28,
                      child: Container(
                        width: MediaQuery.of(Get.context!).size.width - 130,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: MediaQuery.of(Get.context!).size.width / 2,
                            child: Align(
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                'assets/bg2-onboarding.svg',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // child: Image.asset('assets/logo_splash.png',
                //          color: Colors.white,),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Akses Informasi HR dengan Cepat',
                    style: TextStyle(
                      fontSize: 23.0,
                      wordSpacing: 1,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                      color: HexColor('#202327'),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Akses Informasi HR Anda dari mana saja dengan HRIS Mobile. Seperti Informasi Kantor, Slip Gaji, Riwayat Pengajuan, dan Riwayat Absensi dengan mudah.',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16.0, color: HexColor('#202327')),
                  ),
                ),
              ),
              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       'Keep your files in closed safe so you can\'t lose them. Consider TrueNAS.',
              //       style: pageInfoStyle,
              //       textAlign: TextAlign.left,
              //     ),
              //   ),
              // ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Keep your files in closed safe so you can\'t lose them. Consider TrueNAS.',
                    style: pageInfoStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Keep your files in closed safe so you can\'t lose them. Consider TrueNAS.',
                    style: pageInfoStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    //------------page 3
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 0.0,
            color: Colors.white,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 90.0,
                ),
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      'assets/bg3.svg',
                    ),
                    Positioned(
                      bottom: 28,
                      child: Container(
                        width: MediaQuery.of(Get.context!).size.width - 130,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: MediaQuery.of(Get.context!).size.width / 2,
                            child: Align(
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                'assets/bg3-onboarding.svg',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // child: Image.asset('assets/logo_splash.png',
                //          color: Colors.white,),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Self Service yang Mudah dan Efisiensi!',
                    style: TextStyle(
                      fontSize: 23.0,
                      wordSpacing: 1,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                      color: HexColor('#202327'),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Buat dan kelola pengajuan Cuti, Lembur, Klaim Pengeluaran, pantau Performa Kerja, Absen dengan teknologi Face Rocognition dan nikmati fitur canggih lainnya.',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16.0, color: HexColor('#202327')),
                  ),
                ),
              ),
              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       'Keep your files in closed safe so you can\'t lose them. Consider TrueNAS.',
              //       style: pageInfoStyle,
              //       textAlign: TextAlign.left,
              //     ),
              //   ),
              // ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Keep your files in closed safe so you can\'t lose them. Consider TrueNAS.',
                    style: pageInfoStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Keep your files in closed safe so you can\'t lose them. Consider TrueNAS.',
                    style: pageInfoStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    materialButton = _skipButton();
    index = 0;
  }

  Material _skipButton({void Function(int)? setIndex, i}) {
    return Material(
      borderRadius: BorderRadius.circular(360),
      color: Constanst.colorPrimary,
      child: InkWell(
        onTap: () {
          print(AppData.isOnboarding);

          if (setIndex != null) {
            index = i + 1;

            setIndex(i + 1);
          }
        },
        child: Container(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10),
          child: const Icon(
            Iconsax.arrow_right_1,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }

  Material get _signupButton {
    return Material(
        child: InkWell(
      onTap: () {
        onBoardingInActive();
        Get.offAll(Login());
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(360),
            border: Border.all(width: 1, color: Constanst.Secondary)),
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 12),
        child: TextLabell(text: "Login"),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SISCOM HRIS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: Onboarding(
          pages: onboardingPagesList,
          onPageChange: (int pageIndex) {
            index = pageIndex;
          },
          startPageIndex: 0,
          footerBuilder: (context, dragDistance, pagesLength, setIndex) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 0.0,
                  color: Colors.white,
                ),
              ),
              child: ColoredBox(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      index == pagesLength - 1
                          ? Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      onBoardingInActive();
                                      Get.offAll(Login());
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Constanst.colorPrimary,
                                          borderRadius:
                                              BorderRadius.circular(32),
                                          border: Border.all(
                                            width: 1,
                                          )),
                                      padding: EdgeInsets.only(
                                          left: 32,
                                          right: 32,
                                          top: 8,
                                          bottom: 8),
                                      child: Row(
                                        children: [
                                          TextLabell(
                                            text: "Mulai",
                                            color: Colors.white,
                                            size: 16,
                                            weight: FontWeight.w700,
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Icon(
                                            Iconsax.arrow_right_1,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    onBoardingInActive();
                                    Get.offAll(Login());
                                  },
                                  child: Material(
                                      borderRadius: BorderRadius.circular(360),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Constanst.colorWhite,
                                            borderRadius:
                                                BorderRadius.circular(360),
                                            border: Border.all(
                                                width: 1.5,
                                                color: HexColor('#E2E8F0'))),
                                        padding: const EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            bottom: 10,
                                            top: 10),
                                        child: TextLabell(
                                          text: "Login",
                                          size: 14,
                                          weight: FontWeight.w500,
                                          color: Constanst.onPrimary,
                                        ),
                                      )),
                                ),
                                index == pagesLength - 1
                                    ? _signupButton
                                    : _skipButton(setIndex: setIndex, i: index)
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  onBoardingInActive() {
    AppData.isOnboarding = true;
  }
}
