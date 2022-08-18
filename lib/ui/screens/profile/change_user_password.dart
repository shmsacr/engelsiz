import 'package:engelsiz/ui/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool chechCurrentPasswordValid = true;
  final _formKey = GlobalKey<FormState>();
  var newPassword = '';
  var newPasswordController = TextEditingController();
  var repeatPasswordController = TextEditingController();
  var currentUser = FirebaseAuth.instance.currentUser;
  var currentPassController = TextEditingController();
  @override
  void dispose() {
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          height: 300,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
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
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Yeni Şifreniz',
                    hintStyle: TextStyle(
                        fontSize: 20, color: AppColors.primaryContainer),
                  ),
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
