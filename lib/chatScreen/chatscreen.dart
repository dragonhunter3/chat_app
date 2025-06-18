import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:chat_app/chatScreen/audio_controller.dart';
import 'package:chat_app/chatScreen/my_chat_video_player.dart';
import 'package:chat_app/models/firendmodel.dart';
import 'package:chat_app/models/static_Data.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatScreen extends StatefulWidget {
  final String chatroomId;

  final Firendmodel profileModel;

  const ChatScreen({
    super.key,
    required this.chatroomId,
    required this.profileModel,
  });
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msgController = TextEditingController();
  bool isRecording = false;
  var isSending = false.obs;
  var end = DateTime.now().obs;
  int total = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isemoji = false;
  void onsendMessage(String type, String msg, String duration) async {
    if (msg.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendBy": StaticData.model!.userName,
        "message": msg,
        "time": FieldValue.serverTimestamp(),
        "type": type,
        "duration": duration
      };
      await _firestore
          .collection('chatroom')
          .doc(widget.chatroomId)
          .collection('chats')
          .add(messages);
      msgController.clear();
    } else {
      print("Enter Some Text");
    }
  }

  Future<XFile?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      XFile file = XFile(result.files.single.path!);
      await uploadFileToFirestore(file);
      OpenFile.open(file.path);
      return file;
    }
    return null;
  }

  Future<void> uploadFileToFirestore(XFile pickedFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child('file/$fileName');
    UploadTask uploadTask = storageReference.putFile(
        File(pickedFile.path), SettableMetadata(contentType: "file"));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String fileUrl = await taskSnapshot.ref.getDownloadURL();
    onsendMessage("file", fileUrl, "");
  }

  Future<XFile?> pickImage() async {
    ImagePicker picker = ImagePicker();
    XFile? selectedImage = await picker.pickImage(source: ImageSource.gallery);
    print(selectedImage!.path);
    uploadImageToFirestore(selectedImage);
    return selectedImage;
  }

  Future<void> uploadImageToFirestore(XFile pickedImage) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child('images/$fileName');

    UploadTask uploadTask = storageReference.putFile(File(pickedImage.path));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    print(imageUrl);

    onsendMessage("image", imageUrl, "");
    print('Image uploaded successfully!');
  }

  Future<XFile?> pickVideo() async {
    ImagePicker picker = ImagePicker();
    XFile? selectedVideo = await picker.pickVideo(source: ImageSource.gallery);
    print(selectedVideo!.path);
    uploadVideoToFirestore(selectedVideo);
    return selectedVideo;
  }

  Future<void> uploadVideoToFirestore(XFile pickedImage) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child('videos/$fileName');

    UploadTask uploadTask = storageReference.putFile(
        File(pickedImage.path), SettableMetadata(contentType: 'video/mp4'));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String videoUrl = await taskSnapshot.ref.getDownloadURL();
    print(videoUrl);

    onsendMessage("video", videoUrl, "");
    print('Video uploaded successfully!');
  }

  late String recordFilePath;
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  AudioController audioController = Get.put(AudioController());

  @override
  void initState() {
    super.initState();
    _recorder.openRecorder();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = "${storageDirectory.path}/recordings";
    Directory directory = Directory(sdPath);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    return "$sdPath/test_${i++}_${DateTime.now().microsecondsSinceEpoch}.aac";
  }

  void startRecord() async {
    try {
      bool hasPermission = await checkPermission();
      if (hasPermission) {
        recordFilePath = await getFilePath();
        await _recorder.startRecorder(
          toFile: recordFilePath,
          codec: Codec.aacMP4,
        );
        audioController.isRecording.value = true;
        setState(() {});
      }
    } catch (e) {
      print("Error starting recorder: $e");
    }
  }

  var audioPlayer = AudioPlayer();

  void stopRecord() async {
    await _recorder.stopRecorder();
    audioController.end.value = DateTime.now();
    audioController.calcDuration();

    var ap = AudioPlayer();
    await ap.play(AssetSource("Notification.mp3"));
    ap.onPlayerComplete.listen((a) {});

    audioController.isRecording.value = false;
    audioController.isSending.value = true;
    await uploadAudio();
  }

  String audioURL = "";

  uploadAudio() async {
    // Check if the file exists at the specified path
    File audioFile = File(recordFilePath);

    if (!audioFile.existsSync()) {
      // If the file doesn't exist, print an error and return
      print('File does not exist at path: $recordFilePath');
      return;
    }

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child('audio/$fileName');

    UploadTask uploadTask = storageReference.putFile(audioFile);

    try {
      TaskSnapshot snapshot = await uploadTask;
      audioURL = await snapshot.ref.getDownloadURL();
      String strVal = audioURL.toString();
      setState(() {
        audioController.isSending.value = false;
        onsendMessage("audio", strVal, audioController.total);
      });
    } on FirebaseException catch (e) {
      setState(() {
        audioController.isSending.value = false;
      });
      Flushbar(
        message: e.message ?? e.toString(),
        duration: Duration(seconds: 3),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: height,
          width: width,
          child: Column(
            children: [
              Container(
                color: Color.fromARGB(255, 71, 26, 160),
                height: height * 0.04,
              ),
              Container(
                height: height * 0.08,
                width: width,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 71, 26, 160),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Padding(
                  padding:
                      EdgeInsets.only(right: width * 0.02, left: width * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: height * 0.05,
                        width: width * 0.12,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Icon(Icons.person,
                            color: Color.fromARGB(255, 151, 71, 255)),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${widget.profileModel.friendName}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Expanded(
                          child: SizedBox(
                        width: width,
                      )),
                      GestureDetector(
                          onTap: () {},
                          child: Icon(Icons.call,
                              color: Colors.white, size: width * 0.05)),
                      SizedBox(
                        width: width * 0.05,
                      ),
                      Icon(Icons.video_call,
                          color: Colors.white, size: width * 0.05),
                      SizedBox(
                        width: width * 0.02,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('chatroom')
                        .doc(widget.chatroomId)
                        .collection('chats')
                        .orderBy("time", descending: false)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data != null) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> map =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            return messages(
                                MediaQuery.of(context).size, map, index);
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
              Divider(color: Color.fromARGB(255, 151, 71, 255)),
              SizedBox(
                height: height * 0.07,
                width: width,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.03,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: height,
                        width: width * 0.2,
                        decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(10))),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height: height * 0.5,
                                      child: EmojiPicker(
                                        onEmojiSelected: (category, emoji) {
                                          setState(() {
                                            msgController.text = emoji.emoji;
                                          });
                                          Navigator.pop(context);
                                        },
                                        textEditingController: msgController,
                                        config: Config(
                                          checkPlatformCompatibility: true,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Icon(
                                Icons.emoji_emotions,
                                size: 28,
                                color: Color.fromARGB(255, 151, 71, 255),
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                        height: 100,
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        pickImage();
                                                      },
                                                      icon: Icon(Icons.image)),
                                                  IconButton(
                                                      onPressed: () {
                                                        pickVideo();
                                                      },
                                                      icon: Icon(Icons
                                                          .video_file_outlined)),
                                                  IconButton(
                                                      onPressed: () {
                                                        pickFile();
                                                      },
                                                      icon: Icon(Icons
                                                          .document_scanner)),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(Icons
                                                          .location_on_outlined))
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Icon(Icons.attachment)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(10),
                              )),
                          child: Padding(
                            padding: EdgeInsets.only(left: width * 0.02),
                            child: Center(
                              child: TextField(
                                controller: msgController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: GestureDetector(
                                        onLongPress: () async {
                                          print("start");
                                          var audioPlayer = AudioPlayer();
                                          await audioPlayer.play(
                                              AssetSource("Notification.mp3"));
                                          audioPlayer.onPlayerComplete
                                              .listen((a) {
                                            audioController.start.value =
                                                DateTime.now();
                                            startRecord();
                                            audioController.isRecording.value =
                                                true;
                                          });
                                          setState(() {
                                            isRecording = isRecording;
                                          });
                                        },
                                        onLongPressEnd: (v) {
                                          print("cancel");
                                          setState(() {
                                            isRecording = isRecording;
                                          });
                                          stopRecord();
                                        },
                                        child: Icon(isRecording
                                            ? Icons.stop
                                            : Icons.mic))),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      InkWell(
                          onTap: () {
                            onsendMessage("text", msgController.text, "");
                          },
                          child: Container(
                            height: height,
                            width: width * 0.14,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 151, 71, 255)),
                            child: const Center(
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _audio({
    required String message,
    required bool isCurrentUser,
    required int index,
    required String time,
    required String duration,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? Color.fromARGB(255, 151, 71, 255)
              : Color.fromARGB(255, 151, 71, 255).withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                audioController.onPressedPlayButton(index, message);
                // changeProg(duration: duration);
              },
              onSecondaryTap: () {
                audioPlayer.stop();
                audioController.completedPercentage.value = 0.0;
              },
              child: Obx(
                () => (audioController.isRecordPlaying &&
                        audioController.currentId == index)
                    ? Icon(
                        Icons.cancel,
                        color: isCurrentUser
                            ? Colors.white
                            : Color.fromARGB(255, 151, 71, 255),
                      )
                    : Icon(
                        Icons.play_arrow,
                        color: isCurrentUser
                            ? Colors.white
                            : Color.fromARGB(255, 151, 71, 255),
                      ),
              ),
            ),
            Obx(
              () => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      LinearProgressIndicator(
                        minHeight: 5,
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCurrentUser
                              ? Colors.white
                              : Color.fromARGB(255, 151, 71, 255),
                        ),
                        value: (audioController.isRecordPlaying &&
                                audioController.currentId == index)
                            ? audioController.completedPercentage.value
                            : audioController.totalDuration.value.toDouble(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              duration,
              style: TextStyle(
                fontSize: 12,
                color: isCurrentUser
                    ? Colors.white
                    : Color.fromARGB(255, 151, 71, 255),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, int index) {
    return Container(
      width: size.width,
      alignment: map['sendBy'] == StaticData.model!.userName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: map['type'] == "image"
          ? Container(
              height: size.height * 0.2,
              width: size.width * 0.4,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      fit: BoxFit.fill, image: NetworkImage(map['message']))),
            )
          : map['type'] == "file"
              ? Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () async {
                      // Handle file opening
                      final result = await OpenFile.open(map['message']);
                      if (result.type != ResultType.done) {
                        print('Failed to open file: ${result.message}');
                      }
                    },
                    child: Container(
                      height: size.height / 10,
                      width: size.width / 1.5,
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.file_present,
                              color: Color.fromARGB(255, 151, 71, 255)),
                          SizedBox(width: 8),
                          Text(
                            "File",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : map['type'] == "audio"
                  ? _audio(
                      message: map['message'],
                      isCurrentUser:
                          map['sendBy'] == StaticData.model!.userName,
                      index: index,
                      time: map['time'].toString(),
                      duration: map['duration'].toString())
                  : map['type'] == "video"
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  appBar: AppBar(
                                    title: Text("Video Player"),
                                  ),
                                  body: Center(
                                    child: ChatVideoPlayer(
                                        videoUrl: map['message']),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: size.height * 0.3,
                            width: size.width * 0.5,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 14),
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 14),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: map['sendBy'] == StaticData.model!.userName
                                ? Color.fromARGB(255, 151, 71, 255)
                                : Colors.red[100],
                          ),
                          child: Text(
                            map['message'],
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color:
                                    map['sendBy'] == StaticData.model!.userName
                                        ? Colors.white
                                        : Colors.black),
                          ),
                        ),
    );
  }
}
