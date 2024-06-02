
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prodigit_test/screens/home_page.dart';
import 'package:prodigit_test/services/authentication_service.dart';
import 'package:prodigit_test/utils/colors.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService();
  bool _isLoading = false;
  bool _isGmailLoading = false;
  final _formKey = GlobalKey<FormState>();



  void _signInWithEmailAndPassword({required Function onSuccess, required Function onError }) async {

    setState(() {
      _isLoading = true;
    });

    var result = await _authService.signInWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['user'] != null) {
      onSuccess();
    } else {
      onError(result['error']);
    }



  }

  void _signInWithGoogle({required onSuccess, required onError}) async {

    setState(() {
      _isGmailLoading = true;
    });

    var result = await _authService.signInWithGoogle();
    setState(() {
      _isGmailLoading = false;
    });

    if (result['user'] != null) {
      onSuccess();
    } else {
      onError(result['error']);
    }


  }
  
  
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: secondaryBackgroundColor));

    return Scaffold(
      backgroundColor: secondaryBackgroundColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Text(
                        "Welcome back!",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                        "Please login to your account",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 21,),
                    TextFormField(
                      validator: (email){
                        if(email!.isEmpty){
                          return "Please enter your email";
                        }else if(!email.contains('@')){
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                            hintText: "Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)
                            )
                        ),

                    ),

                    const SizedBox(height: 16,),


                    TextFormField(
                      controller: _passwordController,
                      validator: (email){
                        if(email!.isEmpty){
                          return "Please enter your Password";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                          hintText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)
                          )
                      ),
                      obscureText: true,

                    ),
                    const SizedBox(height: 50),


                    _isLoading ? const CircularProgressIndicator(
                      color: brandColor,
                    ) : Builder(
                      builder: (context) {
                        return SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: brandColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: (){
                              _formKey.currentState!.validate();
                              _signInWithEmailAndPassword(
                                onSuccess: (){

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HomePage()),
                                  );
                                },
                                onError: (e){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
                                }
                              );
                            },
                            child:  Text("Login",
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }
                    ),

                    const SizedBox(height: 35),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Colors.black38,
                          ),
                        ),
                        Text("  Or Login with  ",
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 35),

                    _isGmailLoading ? const CircularProgressIndicator(
                      color: brandColor,
                    ) : Builder(
                      builder: (context) {
                        return SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              side: const BorderSide(color: Colors.black38,width: 1),
                            ),
                            onPressed: (){
                              _signInWithGoogle(
                                onSuccess: (){
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HomePage()),
                                  );
                                },
                                onError: (e){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));

                                }
                              );
                            },
                            label:  Text("Login with Google",
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            icon: const Icon(FontAwesomeIcons.google,color: Colors.red,),
                          ),
                        );
                      }
                    ),


                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

