import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show ByteData, kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' show post;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'env.dart';

class TextToSpeechWidget extends StatefulWidget {
  final String text;

  const TextToSpeechWidget({Key? key, required this.text}) : super(key: key);

  @override
  State createState() => _TextToSpeechWidgetState();
}

class _TextToSpeechWidgetState extends State<TextToSpeechWidget> {
  late final AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<Uri> _writeToFile(ByteData data) async {
    if (kIsWeb) {
      final base64Data = base64.encode(data.buffer.asUint8List());
      final url = 'data:audio/mpeg;base64,$base64Data';
      return Uri.parse(url);
    } else {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/output.mp3');
      await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
      return file.uri;
    }
  }

  Future<void> _convertTextToSpeech() async {
    final endpoint = Uri.parse(
        'https://$msTtsRegion.tts.speech.microsoft.com/cognitiveservices/v1');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/ssml+xml',
      'Ocp-Apim-Subscription-Key': msTtsKey,
      'X-Microsoft-OutputFormat': 'audio-48khz-192kbitrate-mono-mp3',
    };
    final ssml =
        '''<speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xml:lang="bg-BG">
                  <voice name="bg-BG-KalinaNeural">${widget.text}</voice>
                  </speak>''';
    final response = await post(endpoint, headers: headers, body: ssml);

    if (response.statusCode != 200) {
      throw Exception('Failed to convert text to speech');
    }

    final uri = await _writeToFile(response.bodyBytes.buffer.asByteData());
    await _player.setUrl(uri.toString());
  }

  Future<void> _play() async {
    if (_player.processingState == ProcessingState.completed) {
      await _player.seek(Duration.zero);
    }
    if (_player.playing) {
      return;
    }
    await _player.play();

    await for (final playbackState in _player.playbackEventStream) {
      if (playbackState.processingState == ProcessingState.completed) {
        setState(() {
          _player.stop();
        });
        break;
      }
    }
    setState(() {});
  }

  Future<void> _pause() async {
    if (_player.playing) {
      await _player.pause();
    }
  }

  Future<void> _stop() async {
    await _player.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FutureBuilder(
          future: _convertTextToSpeech(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return StreamBuilder<PlayerState>(
                stream: _player.playerStateStream,
                builder: (context, snapshot) {
                  final playing = _player.playing;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: playing
                            ? const Icon(Icons.pause)
                            : const Icon(Icons.play_arrow),
                        onPressed: playing ? _pause : _play,
                      ),
                      IconButton(
                        icon: const Icon(Icons.stop),
                        onPressed: _stop,
                      ),
                    ],
                  );
                },
              );
            } else {
              return const Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
