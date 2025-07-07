import 'dart:typed_data';
import 'dart:io' if (dart.library.html) 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:helloworld/video_player_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:video_player/video_player.dart';

class ChatDetails extends StatefulWidget {
  final Map<String, dynamic> chat;

  ChatDetails({Key? key, required this.chat}) : super(key: key);

  @override
  _ChatDetailsState createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ImagePicker _picker = ImagePicker();

  void _sendMessage({String? text, Uint8List? imageBytes, XFile? videoFile}) {
    if ((text == null || text.isEmpty) && imageBytes == null && videoFile == null) return;

    setState(() {
      _messages.add({
        'text': text,
        'imageBytes': imageBytes,
        'videoFile': videoFile,
        'timestamp': DateTime.now(),
      });
    });

    _messageController.clear();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        _sendMessage(imageBytes: bytes);
      }
    } catch (e) {
      _showError("Error picking image: $e");
    }
  }

  Future<void> _pickVideo() async {
    try {
      final pickedVideo = await _picker.pickVideo(source: ImageSource.gallery);
      if (pickedVideo != null) {
        _sendMessage(videoFile: pickedVideo);
      }
    } catch (e) {
      _showError("Error picking video: $e");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final chat = widget.chat;
    return Scaffold(
      appBar: AppBar(
        title: Text('${chat['first_name']} ${chat['last_name']}'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return Align(
                  alignment: Alignment.centerRight,
                  child: Card(
                    color: Colors.green[50],
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message['imageBytes'] != null)
                            Image.memory(
                              message['imageBytes'],
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          if (message['videoFile'] != null)
                            VideoPlayerWidget(file: message['videoFile']),
                          if (message['text'] != null &&
                              message['text'].toString().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                message['text'],
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            color: Colors.grey[100],
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: Icon(Icons.videocam),
                  onPressed: _pickVideo,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () =>
                      _sendMessage(text: _messageController.text.trim()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
