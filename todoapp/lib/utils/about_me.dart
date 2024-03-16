// ignore_for_file: prefer_const_constructors_in_immutables, non_constant_identifier_names

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class AboutMe extends StatefulWidget {
  AboutMe({super.key});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> with TickerProviderStateMixin {
  final asset = 'assets/videos/kucingRain.mp4';
  late VideoPlayerController _videoPlayerController;
  bool _isVideoLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    _videoPlayerController = VideoPlayerController.asset(asset)
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..setVolume(0);
    await _videoPlayerController.initialize();
    setState(() {
      _isVideoLoading = false;
      _videoPlayerController.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;
    return Container(
      width: phoneWidth,
      color: Colors.black,
      child: _isVideoLoading
        ? const Center(child: CircularProgressIndicator()) 
        : Stack(
          children: [
            VideoPlayer(_videoPlayerController),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                color: Colors.grey.shade900.withOpacity(0.2),
              ),
            ),
            Container(
              height: phoneHeight/2.2,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(100)
                )
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: phoneHeight/2.2,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100)
                    )
                  )
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
              ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(phoneWidth/20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RafiePP(phoneWidth),
                        Name(phoneWidth),
                        Major(phoneWidth),
                        Born(phoneWidth),
                        Email(phoneWidth)
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
    );
  }

  Widget RafiePP(double phoneWidth) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white, width: phoneWidth/150),
        boxShadow: List.generate(
          2, (index) {
            return BoxShadow(
              color: Colors.white.withOpacity(0.2),
              blurRadius: 50
            );
          }
        )
      ),
      child: CircleAvatar(
        radius: phoneWidth/7,
        backgroundImage: const AssetImage('assets/images/pprafie.jpg'),
      ),
    );
  }

  Widget Name(double phoneWidth) {
    return Container(
      margin: EdgeInsets.only(top: phoneWidth/25),
      child: Text(
        'Rafie Asadel Tarigan',
        style: TextStyle(
          color: Colors.white,
          fontSize: phoneWidth/30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget Major(double phoneWidth) {
    return Container(
      margin: EdgeInsets.only(top: phoneWidth/15),
      child: Text(
        'Sistem Informasi',
        style: TextStyle(
          color: Colors.white,
          fontSize: phoneWidth/30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget Born(double phoneWidth) {
    return Container(
      margin: EdgeInsets.only(top: phoneWidth/20),
      child: Text(
        DateFormat('MMMM-dd-yyyy').format(DateTime(2005, 03, 07)),
        style: TextStyle(
          color: Colors.white,
          fontSize: phoneWidth/30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget Email(double phoneWidth) {
    return Text(
      'rafieasadel@gmail.com',
      style: TextStyle(
        color: Colors.white,
        fontSize: phoneWidth/30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

}
