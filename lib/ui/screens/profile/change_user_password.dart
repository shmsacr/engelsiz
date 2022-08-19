import 'package:engelsiz/ui/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool chechCurrentPasswordValid = true;
  final _formKey = GlobalKey<FormState>();
  var newPassword = '';
  var newPasswordController = TextEditingController();
  var repeatPasswordController = TextEditingController();
  var currentUser = FirebaseAuth.instance.currentUser;
  var currentPassController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Şifre ',
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          leading: GestureDetector(
            child: const Icon(
              Icons.close,
              color: Colors.black,
              size: 50,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          // iconTheme: IconThemeData(color: AppColors.accent),
          // backgroundColor: Colors.red,
          // automaticallyImplyLeading: true,
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          height: 400,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Şifren en az 6 karakter olmalı ve rakamlar,harfler ve özel karakterlerden (!@%&*) oluşmalıdır',
                    style: TextStyle(
                      fontWeight: FontWeight.w100,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 25),
                  TextFormField(
                    controller: currentPassController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Eski Şifreniz',
                        hintStyle: TextStyle(
                            fontSize: 20, color: AppColors.primaryContainer),
                        errorText: chechCurrentPasswordValid
                            ? null
                            : 'Şifrenizi kontrol ediniz '),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Yeni Şifreniz',
                      hintStyle: TextStyle(
                          fontSize: 20, color: AppColors.primaryContainer),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: repeatPasswordController,
                    validator: (value) {
                      return newPasswordController.text == value
                          ? null
                          : 'Şifreler uyuşmuyor';
                    },
                    decoration: const InputDecoration(
                      hintText: 'Tekrar giriniz',
                      hintStyle: TextStyle(
                          fontSize: 20, color: AppColors.primaryContainer),
                    ),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColors.textFaded)),
                      onPressed: () async {
                        chechCurrentPasswordValid =
                            await validatePassword(currentPassController.text);

                        setState(() {
                          newPassword = newPasswordController.text;
                        });

                        if (_formKey.currentState!.validate() &&
                            chechCurrentPasswordValid) {
                          //changePassword();
                          currentUser?.updatePassword(newPassword);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: AppColors.primary,
                              content: Text('Şifreniz Güncellendi..'),
                            ),
                          );

                          Navigator.pop(context);
                        }
                        //changePassword();
                      },
                      //changePassword();

                      child: const Text(
                        'Şifremi Güncelle',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> validatePassword(String password) async {
    var firebaseUser = await _auth.currentUser;

    var authCredentials = EmailAuthProvider.credential(
        email: firebaseUser!.email!, password: password);
    try {
      var authResult =
          await firebaseUser.reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
