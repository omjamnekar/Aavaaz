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
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool isRecording = false;
  String selectedLanguage = 'English';
  String targetLanguage = 'German';
  final AudioRecorder _audioRecorder = AudioRecorder();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (isRecording) {
      await _audioRecorder.stopRecording();
      _controller.stop();

      await Future.delayed(const Duration(milliseconds: 1400));
      // only After 1400 time playRecording will start
      await _audioRecorder.playRecording();
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
      body: Container(
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
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(AssetsConstants.logo, width: 20, height: 20),
                      CircleAvatar(
                        backgroundImage:
                            AssetImage(AssetsConstants.userProfile),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                flex: 10,
                child: GestureDetector(
                  onTap: () => _toggleRecording(),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (_, __) => CustomPaint(
                          painter: MicWavePainter(
                            progress: _controller.value,
                            color: Colors.blueGrey.shade900,
                          ),
                          size: const Size(250, 250),
                        ),
                      ),
                      Image.asset(
                        AssetsConstants.mic,
                        width: 150,
                        height: 150,
                      ),
                    ],
                  ),
                ),
              ),

              // Language Selection Panel
              Flexible(
                flex: 2,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 140,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(57, 37, 37, 37).withOpacity(0.4),
                            Color.fromARGB(255, 41, 41, 41).withOpacity(0.2),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              selectedLanguage,
                              style: const TextStyle(color: Colors.white),
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
                            dropdownColor: Colors.black.withOpacity(0.7),
                            items: const [
                              DropdownMenuItem(
                                value: 'English',
                                child: Text('English',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              DropdownMenuItem(
                                value: 'German',
                                child: Text('German',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              DropdownMenuItem(
                                value: 'French',
                                child: Text('French',
                                    style: TextStyle(color: Colors.white)),
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
