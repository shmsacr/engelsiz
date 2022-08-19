import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engelsiz/ui/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ChangePhone extends StatefulWidget {
  const ChangePhone({Key? key}) : super(key: key);

  @override
  State<ChangePhone> createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone> {
  final _firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormBuilderState>();
  final _phoneNumberController = TextEditingController(text: "+90");
  void initState() {
    super.initState();

    PhoneInputFormatter.replacePhoneMask(
      countryCode: 'TR',
      newMask: '+00 (000) 000 00 00',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Telefon Numarası',
            style: TextStyle(color: Colors.white),
          ),
          leading: GestureDetector(
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
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
          padding: const EdgeInsets.all(50),
          height: 340,
          child: SingleChildScrollView(
            child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Telefon Numarası Gir',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  FormBuilderTextField(
                    controller: _phoneNumberController,
                    name: 'phoneNumber',
                    inputFormatters: [PhoneInputFormatter()],
                    decoration:
                        const InputDecoration(labelText: 'Telefon Numarası'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Bu alan boş bırakılamaz."),
                      FormBuilderValidators.equalLength(
                        19,
                        errorText:
                            "Doğru formatta bir telefon numarası giriniz.",
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                        Colors.blue,
                      )),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) upDataPhone();
                      },
                      //changePassword();

                      child: const Text(
                        'Numarayı Güncelle',
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

  upDataPhone() {
    _firestore.collection('users').doc(auth.currentUser!.uid).set(
        {'phoneNumber': _phoneNumberController.text},
        SetOptions(merge: true)).whenComplete(
      () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.primary,
          content: Text('Telefon Numarası Güncellendi'),
        ),
      ),
    );
    Navigator.pop(context);
  }
}
