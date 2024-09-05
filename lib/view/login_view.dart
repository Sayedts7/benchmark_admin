

import 'package:benchmark_estimate_admin_panel/view/landing_view/landing_view_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/common_function.dart';
import '../../utils/utils.dart';
import '../utils/constants/MySize.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/image_path.dart';
import '../utils/constants/textStyles.dart';
import '../utils/custom_widgets/circular_container.dart';
import '../utils/custom_widgets/custom_button.dart';
import '../utils/custom_widgets/custom_textfield.dart';
import '../utils/custom_widgets/loader_view.dart';
import '../view_model/firebase/auth_services.dart';
import '../view_model/provider/admin_provider.dart';
import '../view_model/provider/checkbox_provider.dart';
import '../view_model/provider/loader_view_provider.dart';
import '../view_model/provider/obsecure_provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isChecked = false;
  final AuthServices _authService = AuthServices();


  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loadingProvider = Provider.of<LoaderViewProvider>(context,listen: false);
    MySize().init(context);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body:  MySize.screenWidth > 700?
          Row(
            children: [
              Container(
                  color: primaryColor,
                  height: MySize.screenHeight,
                  width: MediaQuery.of(context).size.width *0.5,
                  child:               Padding(
                    padding:  EdgeInsets.symmetric( vertical: MySize.size40),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal:MySize.size58,),
                            child: Image(image: AssetImage(logo_t),height: MySize.size40,),
                          ),
                          SizedBox(height: MySize.size62,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                            height:MySize.size600, width: MySize.screenWidth > 1200? MySize.size600 : MySize.size400,
                                  child: Image.asset(login_bg,)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
              ),
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width *0.5,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: MySize.screenWidth > 1100? MySize.size165 : MySize.size60, ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height:  MySize.screenHeight >1100? MySize.size80 : MySize.size40,),
                               const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    'Sign In to your Account',
                                    style:  AppTextStylesInter.label24700B
                                ),
                              ),
                              SizedBox(
                                height: MySize.size12,
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    'Welcome Back! please enter your details',
                                    style:  AppTextStylesInter.label14400BTC
                                ),
                              ),
                              SizedBox(
                                height: MySize.size32,
                              ),
                              CustomTextField13(
                                controller: _emailController,
                                prefixIcon: Padding(
                                  padding:  EdgeInsets.all(MySize.size15),
                                  child: SvgPicture.asset(email),
                                ),
                                hintText: 'Enter Your Email',
                                fillColor: backgroundColor,
                              ),
                              SizedBox(
                                height: MySize.size16,
                              ),
                              Consumer<ObscureProvider>(
                                builder: (BuildContext context, ObscureProvider value, Widget? child) {
                                  return  CustomTextField13(
                                    controller: _passwordController,
                                    prefixIcon: Padding(
                                      padding:  EdgeInsets.all(MySize.size15),
                                      child: SvgPicture.asset(password),
                                    ),
                                    hintText: 'Password',
                                    obscureText: value.obsecureText,
                                    fillColor: backgroundColor,
                                    sufixIcon: Padding(
                                      padding:  EdgeInsets.all(MySize.size15),
                                      child: GestureDetector(
                                        onTap: (){
                                          value.setObsecureText(!value.obsecureText);
                                        },
                                        child: SvgPicture.asset(obscure),
                                      ),
                                    ),
                                  );

                                },
                              ),
                              SizedBox(
                                height: MySize.size16,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Consumer<CheckBoxProvider>(

                                        builder: (BuildContext context, CheckBoxProvider value, Widget? child) {
                                          return GestureDetector(
                                            onTap: () {
                                              value.updateCheckBox(!value.isChecked);

                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                // shape: BoxShape.circle,
                                                borderRadius: BorderRadius.circular(3),
                                                border: Border.all(
                                                  color: value.isChecked ? primaryColor : Colors.grey,
                                                  width: 2.0,
                                                ),
                                                color: value.isChecked? backgroundColor : Colors.transparent,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: value.isChecked
                                                    ? const Icon(
                                                  Icons.check,
                                                  size: 14.0,
                                                  color: primaryColor,
                                                )
                                                    : Container(
                                                  width: 14.0,
                                                  height: 14.0,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },

                                      ),
                                      SizedBox(width: MySize.size15,),
                                      const Text('Remember me', style: AppTextStylesInter.label12400BTC),
                                    ],
                                  ),

                                ],
                              ),
                              SizedBox(
                                height: MySize.size32,
                              ),
                              CustomButton8(text: 'Sign in', onPressed: (){
                                _submitForm();
                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>  LandingView()));

                              }),



                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ):
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MySize.size20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                        SizedBox(height:  MySize.screenHeight >500? MySize.size180 : MySize.size100,),


                       Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            'Sign In to your Account',
                            style:  AppTextStylesInter.label24700B
                        ),
                      ),
                      SizedBox(
                        height: MySize.size12,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            'Welcome Back! please enter your details',
                            style:  AppTextStylesInter.label14400BTC
                        ),
                      ),
                      SizedBox(
                        height: MySize.size32,
                      ),
                      CustomTextField13(
                        controller: _emailController,
                        prefixIcon: Padding(
                          padding:  EdgeInsets.all(MySize.size15),
                          child: SvgPicture.asset(email),
                        ),
                        hintText: 'Enter Your Email',
                        fillColor: backgroundColor,
                      ),
                      SizedBox(
                        height: MySize.size16,
                      ),
                      Consumer<ObscureProvider>(
                        builder: (BuildContext context, ObscureProvider value, Widget? child) {
                          return  CustomTextField13(
                            controller: _passwordController,
                            prefixIcon: Padding(
                              padding:  EdgeInsets.all(MySize.size15),
                              child: SvgPicture.asset(password),
                            ),
                            hintText: 'Password',
                            obscureText: value.obsecureText,
                            fillColor: backgroundColor,
                            sufixIcon: Padding(
                              padding:  EdgeInsets.all(MySize.size15),
                              child: GestureDetector(
                                onTap: (){
                                  value.setObsecureText(!value.obsecureText);
                                },
                                child: SvgPicture.asset(obscure),
                              ),
                            ),
                          );

                        },
                      ),
                      SizedBox(
                        height: MySize.size16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Consumer<CheckBoxProvider>(

                                builder: (BuildContext context, CheckBoxProvider value, Widget? child) {
                                  return GestureDetector(
                                    onTap: () {
                                      value.updateCheckBox(!value.isChecked);

                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        // shape: BoxShape.circle,
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                          color: value.isChecked ? primaryColor : Colors.grey,
                                          width: 2.0,
                                        ),
                                        color: value.isChecked? backgroundColor : Colors.transparent,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: value.isChecked
                                            ? const Icon(
                                          Icons.check,
                                          size: 14.0,
                                          color: primaryColor,
                                        )
                                            : Container(
                                          width: 14.0,
                                          height: 14.0,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },

                              ),
                              SizedBox(width: MySize.size15,),
                              const Text('Remember me', style: AppTextStylesInter.label12400BTC),
                            ],
                          ),

                        ],
                      ),
                      SizedBox(
                        height: MySize.size32,
                      ),
                      CustomButton8(text: 'Sign in', onPressed: (){
                        print('helooooooooooooooooooooooooooooooooooooo');
                        _submitForm();
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>  LandingView()));

                      }),



                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const LoaderView()
      ],
    );
  }
  void _submitForm() async {
    final obj = Provider.of<LoaderViewProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      // Form is valid, perform login or other actions
      String email = _emailController.text;
      String password = _passwordController.text;
      bool isCOnnected;
      if(kIsWeb){
        isCOnnected =true;
      }else{
        isCOnnected = await Utils.checkInternetConnection();
      }
      //this line of code starts the loading
      obj.changeShowLoaderValue(true);
      if (isCOnnected == true) {
        // String? userType = await getUserType(email);
        // String? userStatus= await getUserStatus(email);
        // bool? userDeleteStatus = await getUserDeleteStatus(email);

        try {
          final adminProvider = Provider.of<AdminProvider>(context, listen: false);
          obj.changeShowLoaderValue(true);

          final UserCredential? userCredential =
          await _authService.signInWithEmail(context, email, password);
          if (userCredential != null) {
            // String? phoneNull = await getPhone();

            obj.changeShowLoaderValue(false);
            // if(phoneNull == ''){
            //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignInWithPhone())) ;
            // }else{
            print('UID ${FirebaseAuth.instance.currentUser!.uid}');
            await adminProvider.fetchAdminData(FirebaseAuth.instance.currentUser!.uid);
            print(adminProvider.paymentE);
            print(adminProvider.clientsE);
            print(adminProvider.adminsE);
            print(adminProvider.categoryE);
            print(adminProvider.ordersE);

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LandingView()));
            // }
            // Authentication successful, navigate to the next screen


          } else {
            obj.changeShowLoaderValue(false);
          }
        } catch (e) {
          obj.changeShowLoaderValue(false);
          Utils.toastMessage(e.toString());
          print('Exception is here bro: $e, Type: ${e.runtimeType}');


        }


      } else {
        obj.changeShowLoaderValue(false);
        //show the dialog if internet is not available
        CommonFunctions.showNoInternetDialog(context);
      }

      // } else {
      //   //
      //   print('Authentication failed, display an error message');
      //
      //   // ...
      //
      // }

      // Perform login logic here
      if (kDebugMode) {
        print('Login with Email: $email, Password: $password');
      }
    }
  }

}
