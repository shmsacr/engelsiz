import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controller/auth_controller.dart';
import '../login/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late File _uploadFile;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;
  String? picUrl;
  var fullName = 'loading...';
  var role = 'loading...';
  var gender = 'loading...';
  var phoneNumber = 'loading';
  var stName = 'loading...';

  void initState() {
    super.initState();
    loadUserData();
    getImage();

    //WidgetsBinding.instance.addPostFrameCallback((_) => getImage());
  }

  void loadUserData() {
    _firestore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .get()
        .then((snapshot) {
      setState(() {
        fullName = snapshot.data()!['fullName'];
        role = snapshot.data()!['role'];
        gender = snapshot.data()!['gender'];
        phoneNumber = snapshot.data()!['phoneNumber'];
      });
    });
  }

  getImage() async {
    String getImageUrl = await storage
        .ref()
        .child('profilResimleri')
        .child(auth.currentUser!.uid)
        .child('profilResmi.png')
        .getDownloadURL();
    setState(() {
      picUrl = getImageUrl;
    });
  }

  Future<void> upLoadCamere() async {
    XFile? getFile = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _uploadFile = File(getFile!.path);
    });
    storegeSave();
  }

  Future<void> upLoadGallery() async {
    XFile? getFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _uploadFile = File(getFile!.path);
    });
    storegeSave();
  }

  void storegeSave() async {
    Reference refPath = storage
        .ref()
        .child('profilResimleri')
        .child(auth.currentUser!.uid)
        .child('profilResmi.png');
    UploadTask uploadTask = refPath.putFile(_uploadFile);
    String url = await (await uploadTask).ref.getDownloadURL();
    setState(() {
      picUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffb7c6d8),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Flexible(
              flex: 1,
              child: Container(
                height: 150,
                margin: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Stack(children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.all(15),
                        height: 120,
                        width: 120,
                        child: ClipOval(
                          child: Image.network(
                            picUrl ??
                                'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: IconButton(
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      alertDialog()),
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                              )),
                        ),
                      )
                    ]),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${fullName}',
                              style: const TextStyle(
                                fontSize: 25,
                                fontFamily: 'Montserrat',
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //
                        //   ],
                        // ),
                        Row(
                          children: [
                            Text(
                              '${role}',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black54,
                                  fontFamily: 'Montserrat'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                height: 400,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 24,
                  right: 24,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "PROFILE",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    listProfile(Icons.person, "İsim Soyisim", "${fullName}"),
                    listProfile(Icons.male, "Cinsiyet", "${gender}"),
                    listProfile(
                        Icons.mail, 'Mail', '${auth.currentUser!.email}'),
                    listProfile(Icons.lock, 'Rol', '${role}'),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                height: 190,
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 24,
                  right: 24,
                ),
                margin: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: ListView(
                  children: [
                    listTileWidget('Şifre', () {}, Icons.key),
                    listTileWidget(
                        '${phoneNumber}', () {}, Icons.phone_android),
                    Row(
                      children: [
                        const _SignOutButton(),
                      ],
                    )

                    // ListTile(
                    //   onTap: () {},
                    //   title: const Text(
                    //     'Şifre',
                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 18,
                    //     ),
                    //   ),
                    //   leading: Icon(
                    //     Icons.key,
                    //     color: Colors.black87,
                    //   ),
                    //   trailing: Icon(Icons.arrow_forward_ios),
                    // ),
                    // // Row(
                    // //   children: [
                    // //     TextButton.icon(
                    // //       onPressed: () {},
                    // //       icon: const Icon(
                    // //         Icons.key,
                    // //         color: Colors.black87,
                    // //       ),
                    // //       label: const Text(
                    // //         'Şifre',
                    // //         style: TextStyle(
                    // //           color: Colors.black,
                    // //           fontSize: 18,
                    // //         ),
                    // //       ),
                    // //     ),
                    // //   ],
                    // // ),
                    // Row(
                    //   children: [
                    //     TextButton.icon(
                    //       onPressed: () {},
                    //       icon: const Icon(
                    //         Icons.phone_android,
                    //         color: Colors.black87,
                    //       ),
                    //       label: Text(
                    //         '${phoneNumber}',
                    //         style: const TextStyle(
                    //           color: Colors.black,
                    //           fontSize: 18,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   children: [const _SignOutButton()],
                    // ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget listTileWidget(String text1, Function onTap, IconData icon) {
    return ListTile(
      onTap: () {
        onTap;
      },
      title: Text(text1),
      leading: Icon(icon),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }

  Widget alertDialog() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 300,
          width: 400,
          child: AlertDialog(
            title: const Text('Lütfen yükleme tipini seçiniz'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    upLoadCamere();
                  },
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Kamera',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    upLoadGallery();
                  },
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Galeri',
                        style: TextStyle(color: Colors.purple),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget listProfile(IconData icon, String text1, String text2) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
          ),
          const SizedBox(
            width: 24,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Montserrat",
                  fontSize: 14,
                ),
              ),
              Text(
                text2,
                style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SignOutButton extends ConsumerWidget {
  const _SignOutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      icon: const Icon(
        Icons.exit_to_app,
        color: Colors.black,
      ),
      //style: ElevatedButton.styleFrom(primary: AppColors.textFaded),
      onPressed: () async {
        await _revokeToken();
        ref
            .read(firebaseAuthProvider)
            .signOut()
            .then((_) => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                ))
            .onError((error, stackTrace) => debugPrint(error.toString()));
        ref.read(tokenProvider.notifier).update((state) => null);
        await ref.read(clientProvider).disconnectUser();
      },
      label: const Text(
        "Çıkış Yap",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }
}

Future<void> _revokeToken() async {
  try {
    await FirebaseFunctions.instance
        .httpsCallable('ext-auth-chat-revokeStreamUserToken')
        .call();
    debugPrint('Stream user token revoked');
  } on FirebaseFunctionsException catch (error) {
    debugPrint(error.code);
    debugPrint(error.details);
    debugPrint(error.message);
  }
}
