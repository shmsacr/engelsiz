import 'package:engelsiz/ui/screens/dashboard.dart';
import 'package:engelsiz/controller/auth_controller.dart';
import 'package:engelsiz/ui/screens/login/users.dart';
import 'package:engelsiz/ui/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 225);

  static const String routeName = "login";

  Future<String?> _loginUser(LoginData data, WidgetRef ref) async {
    try {
      await ref.read(firebaseAuthProvider).signInWithEmailAndPassword(
          email: data.name, password: data.password);
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  // Future<String?> _signupUser(SignupData data, WidgetRef ref) async {
  //   try {
  //     final UserCredential userCredential = await ref
  //         .read(firebaseAuthProvider)
  //         .createUserWithEmailAndPassword(
  //             email: data.name!, password: data.password!);
  //     await userCredential.user?.updateDisplayName([
  //       data.additionalSignupData!["name"]!,
  //       data.additionalSignupData!["surname"]!
  //     ].join(" "));
  //   } catch (e) {
  //     return e.toString();
  //   }
  //   return null;
  // }

  Future<String?> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  // Future<String?> _signupConfirm(String error, LoginData data) {
  //   return Future.delayed(loginTime).then((_) {
  //     return null;
  //   });
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlutterLogin(
      logo: const AssetImage('assets/images/logo.jpeg'),
      navigateBackAfterRecovery: true,
      theme: LoginTheme(
        primaryColor: AppColors.primary,
        errorColor: AppColors.error,
        primaryColorAsInputLabel: true,
      ),
      // onConfirmRecover: _signupConfirm,
      // onConfirmSignup: _signupConfirm,
      loginAfterSignUp: false,
      termsOfService: [
        TermOfService(
            id: 'general-term',
            mandatory: true,
            text: 'Kullanıcı Koşulları',
            linkUrl: 'https://www.ilksesgazetesi.com'),
      ],
      // additionalSignupFields: const [
      //   // const UserFormField(
      //   //     keyName: 'username', icon: Icon(FontAwesomeIcons.userAlt)),
      //   UserFormField(keyName: 'name', displayName: "İsim"),
      //   UserFormField(keyName: 'surname', displayName: "Soyisim"),
      //   // UserFormField(
      //   //   keyName: 'phone_number',
      //   //   displayName: 'Phone Number',
      //   //   userType: LoginUserType.phone,
      //   //   fieldValidator: (value) {
      //   //     var phoneRegExp = RegExp(
      //   //         '^(\\+\\d{1,2}\\s)?\\(?\\d{3}\\)?[\\s.-]?\\d{3}[\\s.-]?\\d{4}\$');
      //   //     if (value != null &&
      //   //         value.length < 7 &&
      //   //         !phoneRegExp.hasMatch(value)) {
      //   //       return "This isn't a valid phone number";
      //   //     }
      //   //     return null;
      //   //   },
      //   // ),
      // ],
      initialAuthMode: AuthMode.login,
      userValidator: (value) {
        if (!value!.contains('@') || !value.endsWith('.com')) {
          return "E-posta şunları içermelidir '@', '.com'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value!.isEmpty) {
          return 'Şifre boş bırakılamaz';
        }
        return null;
      },
      onLogin: (loginData) {
        debugPrint('Login info');
        debugPrint('Name: ${loginData.name}');
        debugPrint('Password: ${loginData.password}');
        return _loginUser(loginData, ref);
      },
      // onSignup: (signupData) {
      //   debugPrint('Signup info');
      //   debugPrint('Name: ${signupData.name}');
      //   debugPrint('Password: ${signupData.password}');
      //
      //   signupData.additionalSignupData?.forEach((key, value) {
      //     debugPrint('$key: $value');
      //   });
      //   if (signupData.termsOfService.isNotEmpty) {
      //     debugPrint('Terms of service: ');
      //     for (var element in signupData.termsOfService) {
      //       debugPrint(
      //           ' - ${element.term.id}: ${element.accepted == true ? 'accepted' : 'rejected'}');
      //     }
      //   }
      //   return _signupUser(signupData, ref);
      // },
      onSubmitAnimationCompleted: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
          (route) => false,
        );
      },
      onRecoverPassword: (name) {
        debugPrint('Recover password info');
        debugPrint('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
      // children: [
      //   Positioned(
      //     bottom: MediaQuery.of(context).size.height * .05,
      //     child: ElevatedButton(
      //       onPressed: () async {
      //         await loginAnonymously();
      //         if (ref.watch(userProvider) != null) {
      //           await context.router.pushAndPopUntil(
      //             const HomeBaseRoute(),
      //             predicate: (route) => false,
      //           );
      //         }
      //       },
      //       style: ElevatedButton.styleFrom(
      //         fixedSize: const Size(double.infinity, 40.0),
      //       ),
      //       child: const Text(
      //         "Giriş yapmadan devam et",
      //         style: TextStyle(
      //           color: AppColors.primaryColor,
      //         ),
      //       ),
      //     ),
      //   )
      // ],
      messages: LoginMessages(
        userHint: 'E-posta',
        passwordHint: 'Şifre',
        confirmPasswordHint: 'Şifeyi Onayla',
        loginButton: 'Giriş Yap',
        signupButton: 'Kayıt Ol',
        forgotPasswordButton: 'Şifrenizi mi Unuttunuz ?',
        recoverPasswordButton: 'Gönder',
        goBackButton: 'Geri Dön',
        confirmPasswordError: 'Eşleşme Sağlanamadı',
        recoverPasswordIntro: 'Lütfen e-posta adresinizi giriniz.',
        recoverPasswordDescription: '',
        recoverPasswordSuccess: 'Şifreyi kurtarma başarılı',
        flushbarTitleError: 'Bir şeyler ters gitti!',
        flushbarTitleSuccess: 'Başarılı!',
        recoverCodePasswordDescription:
            "E-posta adresinize kurtarma kodu gönderilecektir.",
      ),
      // scrollable: true,
      // hideProvidersTitle: false,
      // loginAfterSignUp: false,
      // hideForgotPasswordButton: true,
      // hideSignUpButton: true,
      // disableCustomPageTransformer: true,

      // theme: LoginTheme(
      //   primaryColor: Colors.teal,
      //   accentColor: Colors.yellow,
      //   errorColor: Colors.deepOrange,
      //   pageColorLight: Colors.indigo.shade300,
      //   pageColorDark: Colors.indigo.shade500,
      //   logoWidth: 0.80,
      //   titleStyle: TextStyle(
      //     color: Colors.greenAccent,
      //     fontFamily: 'Quicksand',
      //     letterSpacing: 4,
      //   ),
      //   // beforeHeroFontSize: 50,
      //   // afterHeroFontSize: 20,
      //   bodyStyle: TextStyle(
      //     fontStyle: FontStyle.italic,
      //     decoration: TextDecoration.underline,
      //   ),
      //   textFieldStyle: TextStyle(
      //     color: Colors.orange,
      //     shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
      //   ),
      //   buttonStyle: TextStyle(
      //     fontWeight: FontWeight.w800,
      //     color: Colors.yellow,
      //   ),
      //   cardTheme: CardTheme(
      //     color: Colors.yellow.shade100,
      //     elevation: 5,
      //     margin: EdgeInsets.only(top: 15),
      //     shape: ContinuousRectangleBorder(
      //         borderRadius: BorderRadius.circular(100.0)),
      //   ),
      //   inputTheme: InputDecorationTheme(
      //     filled: true,
      //     fillColor: Colors.purple.withOpacity(.1),
      //     contentPadding: EdgeInsets.zero,
      //     errorStyle: TextStyle(
      //       backgroundColor: Colors.orange,
      //       color: Colors.white,
      //     ),
      //     labelStyle: TextStyle(fontSize: 12),
      //     enabledBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
      //       borderRadius: inputBorder,
      //     ),
      //     focusedBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
      //       borderRadius: inputBorder,
      //     ),
      //     errorBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.red.shade700, width: 7),
      //       borderRadius: inputBorder,
      //     ),
      //     focusedErrorBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.red.shade400, width: 8),
      //       borderRadius: inputBorder,
      //     ),
      //     disabledBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.grey, width: 5),
      //       borderRadius: inputBorder,
      //     ),
      //   ),
      //   buttonTheme: LoginButtonTheme(
      //     splashColor: Colors.purple,
      //     backgroundColor: Colors.pinkAccent,
      //     highlightColor: Colors.lightGreen,
      //     elevation: 9.0,
      //     highlightElevation: 6.0,
      //     shape: BeveledRectangleBorder(
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //     // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      //     // shape: CircleBorder(side: BorderSide(color: Colors.green)),
      //     // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
      //   ),
      // ),

      // showDebugButtons: true,
    );
  }
}

Future<UserCredential> loginAnonymously() async {
  try {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    debugPrint("Signed in with temporary account.");
    return userCredential;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "operation-not-allowed":
        return Future.error(
            "Anonymous auth hasn't been enabled for this project.");
      default:
        return Future.error("Unknown error.");
    }
  }
}
