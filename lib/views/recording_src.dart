import 'dart:ui';
import 'package:aavaazflutter/constants/assets_constants.dart';
import 'package:aavaazflutter/viewmodels/audio_vm.dart';
import 'package:aavaazflutter/widgets/mic_wave.dart';
import 'package:flutter/material.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _MicWaveModeState();
}

class _MicWaveModeState extends State<RecordingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  bool isRecording = false;
  String selectedLanguage = 'English';
  String targetLanguage = 'German';
  bool isSound = false;
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Fade in time
    )..forward();
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (isPlaying) {
      await _audioRecorder.stopPlayRecording();
      setState(() {
        isPlaying = !isPlaying;
      });
    }

    if (isRecording) {
      await _audioRecorder.stopRecording();
      _controller.stop();

      setState(() {
        isPlaying = true;
        isSound = true;
      });

      await _audioRecorder.playRecording().then(
        (value) {
          if (isSound) {
            setState(() => isSound = !isSound);
          }
        },
      );
    } else {
      await _audioRecorder.startRecording();
      _controller.repeat(reverse: true);
    }

    setState(() => isRecording = !isRecording);
  }

  void _swapLanguages() {
    setState(() {
      String temp = selectedLanguage;
      selectedLanguage = targetLanguage;
      targetLanguage = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D2B),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AssetsConstants.backgroundImage),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
            ),
          ),
          child: SafeArea(
            child: GestureDetector(
              onTap: () {},
              child: Column(
                children: [
                  Flexible(
                      flex: 1,
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              AssetsConstants.logo,
                              width: 40,
                              height: 40,
                            ),
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage(
                                AssetsConstants.userProfile,
                              ),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                    flex: 10,
                    child: GestureDetector(
                      onTap: () => _toggleRecording(),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedOpacity(
                            opacity: isPlaying ? 0.0 : 1.0,
                            duration: const Duration(milliseconds: 500),
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (_, __) => CustomPaint(
                                painter: MicWavePainter(
                                  progress: _controller.value,
                                  color: Colors.blueGrey.shade900,
                                ),
                                size: const Size(250, 250),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: isPlaying ? 0.0 : 1.0,
                            duration: const Duration(milliseconds: 500),
                            child: Image.asset(
                              AssetsConstants.mic,
                              width: 150,
                              height: 150,
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: isPlaying ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 500),
                            child: Container(
                              margin: EdgeInsets.all(15),
                              padding: EdgeInsets.only(
                                  top: 50, left: 20, right: 20, bottom: 50),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(57, 37, 37, 37)
                                        .withOpacity(0.4),
                                    Color.fromARGB(255, 41, 41, 41)
                                        .withOpacity(0.2),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                              ),
                              child: Text(
                                "Hello my name is John. This is the dummy text that will appear after the recording is complete.\n\nThe transcription of the recorded audio should play here when mic turns off.",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          // height: 140,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(57, 37, 37, 37).withOpacity(0.4),
                                Color.fromARGB(255, 41, 41, 41)
                                    .withOpacity(0.2),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: Column(
                            children: [
                              if (!isPlaying)
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.black.withOpacity(0.4),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          selectedLanguage,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _swapLanguages,
                                        child: Icon(
                                          Icons.swap_horiz,
                                          size: 30,
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                      ),
                                      DropdownButton<String>(
                                        value: targetLanguage,
                                        underline: const SizedBox.shrink(),
                                        dropdownColor:
                                            Colors.black.withOpacity(0.7),
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'English',
                                            child: Text('English',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                          DropdownMenuItem(
                                            value: 'German',
                                            child: Text('German',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                          DropdownMenuItem(
                                            value: 'French',
                                            child: Text('French',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            targetLanguage = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              if (isPlaying)
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            AssetImage("assets/gifs/audio.gif"),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
