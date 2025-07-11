import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/screen/login.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  onBoardingInActive() {
    AppData.isOnboarding = true;
  }

  List<Map<String, String>> onboardingData = [
    {
      'title': 'Selamat datang di SISCOM HRIS!',
      'description':
          'SISCOM HRIS memberikan solusi untuk proses HR online di Perusahaan Anda. Kini, semua kebutuhan HR dapat terintegrasi dalam satu aplikasi dengan data yang akurat dan real time.',
      'svgPicture': 'assets/bg1.svg',
      'svgPictureBg': 'assets/bg1-onboarding.svg',
      // 'width': '300.0',
      // 'height': '350.0',
    },
    {
      'title': 'Akses Informasi HR dengan Cepat',
      'description':
          'Akses Informasi HR Anda dari mana saja dengan HRIS Mobile. Seperti Informasi Kantor, Slip Gaji, Riwayat Pengajuan, dan Riwayat Absensi dengan mudah.',
      'svgPicture': 'assets/bg2.svg',
      'svgPictureBg': 'assets/bg2-onboarding.svg',
      // 'width': '300.0',
      // 'height': '280.0',
    },
    {
      'title': 'Self Service yang Mudah dan Efisiensi!',
      'description':
          'Buat dan kelola pengajuan Cuti, Lembur, Klaim Pengeluaran, pantau Performa Kerja, Absen dengan teknologi Face Rocognition dan nikmati fitur canggih lainnya.',
      'svgPicture': 'assets/bg3.svg',
      'svgPictureBg': 'assets/bg3-onboarding.svg',
      // 'width': '300.0',
      // 'height': '240.0',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: _currentPage == onboardingData.length - 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          onBoardingInActive();
                          Get.offAll(Login());
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Constanst.colorPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(360),
                          ),
                          // padding: const EdgeInsets.fromLTRB(20, 12, 20, 12)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Mulai",
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Iconsax.arrow_right_1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          onBoardingInActive();
                          Get.offAll(Login());
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          foregroundColor: Constanst.colorPrimary,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(360),
                          ),
                          side: BorderSide(
                              width: 1.5, color: HexColor('#E2E8F0')),
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        ),
                        child: Text(
                          "Login",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              color: Constanst.onPrimary,
                              fontSize: 14),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: 40,
                        child: Material(
                          borderRadius: BorderRadius.circular(360),
                          color: Constanst.colorPrimary,
                          child: InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(360),
                            ),
                            onTap: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 10, top: 10),
                              child: const Icon(
                                Iconsax.arrow_right_1,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                return OnboardingPage(
                  title: onboardingData[index]['title'].toString(),
                  description: onboardingData[index]['description'].toString(),
                  svgPicture: onboardingData[index]['svgPicture'].toString(),
                  svgPictureBg:
                      onboardingData[index]['svgPictureBg'].toString(),
                  width: onboardingData[index]['width'].toString(),
                  height: onboardingData[index]['height'].toString(),
                );
              },
            ),
          ),


          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
              (index) => buildDot(index),
            ),
          ),

          const SizedBox(height: 12.0),

          // ElevatedButton(
          //   onPressed: () {
          //     if (_currentPage == onboardingData.length - 1) {
          //       // Navigate to the next screen when the last onboarding page is reached.
          //       // You can replace this with your desired navigation logic.
          //       print('Navigating to the next screen...');
          //     } else {
          //       _pageController.nextPage(
          //         duration: Duration(milliseconds: 300),
          //         curve: Curves.ease,
          //       );
          //     }
          //   },
          //   child: Text(_currentPage == onboardingData.length - 1
          //       ? 'Get Started'
          //       : 'Next'),
          // ),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      height: 4.0,
      width: _currentPage == index ? 24.0 : 12.0,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Constanst.infoLight
            : Constanst.colorNeutralBgTertiary,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String svgPicture;
  final String svgPictureBg;
  final String width;
  final String height;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.svgPicture,
    required this.svgPictureBg,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 45.0),
              child: Stack(
                children: [
                  SvgPicture.asset(
                    svgPicture,
                  ),
                  Positioned(
                    bottom: 22,
                    child: SizedBox(
                      width: MediaQuery.of(Get.context!).size.width - 130,
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: MediaQuery.of(Get.context!).size.width / 2,
                          child: Align(
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              svgPictureBg,
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
            Text(
              title,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 32.0,
                letterSpacing: -0.021,
                fontWeight: FontWeight.w600,
                color: HexColor('#202327'),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.011,
                    color: HexColor('#202327')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
