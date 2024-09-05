import 'package:benchmark_estimate_admin_panel/utils/utils.dart';
import 'package:benchmark_estimate_admin_panel/view_model/firebase/auth_services.dart';
import 'package:benchmark_estimate_admin_panel/view_model/firebase/firebase_functions.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/admin_provider.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/landing_view_provider.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/pagination_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/MySize.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_path.dart';
import '../../../utils/constants/textStyles.dart';
import '../../../view_model/firebase/push_notifications.dart';
import '../../login_view.dart';
import '../../orders/orders_view.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
      final pageProvider = Provider.of<PaginationProvider>(context, listen: false);
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    return Consumer<LandingViewProvider>(
      builder: (context,lvp, child){
        return  Container(
          width: MySize.size300,
          height: double.infinity,
          color: whiteColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:  EdgeInsets.all(MySize.size30),
                  child: Image.asset(logo_tb),
                ),
                const Divider(),
                // SizedBox(height: MySize.size40,),
                Padding(
                  padding:  EdgeInsets.all(MySize.size15),
                  child: Column(
                    children: [



                      lvp.index == 1?
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: const Color(0xffF8FAFC),
                            borderRadius: BorderRadius.circular(12)

                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(overview,),
                            SizedBox(width: MySize.size16,),
                            const Text('Overview', style: AppTextStylesInter.label14700P,),
                          ],
                        ),
                      )
                          :
                      InkWell(
                        onTap: (){
                          lvp.updateIndex(1);
                          pageProvider.setPageNumber();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            // color: Color(0xffF8FAFC),
                              borderRadius: BorderRadius.circular(12)

                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(overview, color: greyColor),
                              SizedBox(width: MySize.size16,),
                              const Text('Overview', style: AppTextStylesInter.label14700Color,),
                            ],
                          ),
                        ),
                      ),

                      Visibility(
                        visible: adminProvider.paymentE,
                        child:
                      lvp.index == 2?
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: const Color(0xffF8FAFC),
                            borderRadius: BorderRadius.circular(12)

                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(analytics, color: primaryColor,),
                            SizedBox(width: MySize.size16,),
                            const Text('Payment', style: AppTextStylesInter.label14700P,),
                          ],
                        ),
                      ):
                      InkWell(
                        onTap: (){
                          pageProvider.setPageNumber();
                          lvp.updateIndex(2);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            // color: Color(0xffF8FAFC),
                              borderRadius: BorderRadius.circular(12)

                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(analytics),
                              SizedBox(width: MySize.size16,),
                              const Text('Payment', style: AppTextStylesInter.label14700Color,),
                            ],
                          ),
                        ),
                      ),),

                     Visibility(
                       visible: adminProvider.clientsE,

                       child:  lvp.index == 3?
                     Container(
                       padding: const EdgeInsets.all(16),
                       decoration: BoxDecoration(
                           color: const Color(0xffF8FAFC),
                           borderRadius: BorderRadius.circular(12)

                       ),
                       child: Row(
                         children: [
                           SvgPicture.asset(clients,),
                           SizedBox(width: MySize.size16,),
                           const Text('Clients', style: AppTextStylesInter.label14700P,),
                         ],
                       ),
                     )
                         :
                     InkWell(
                       onTap: (){
                         pageProvider.setPageNumber();
                         lvp.updateIndex(3);
                       },
                       child: Container(
                         padding: const EdgeInsets.all(16),
                         decoration: BoxDecoration(
                           // color: Color(0xffF8FAFC),
                             borderRadius: BorderRadius.circular(12)

                         ),
                         child: Row(
                           children: [
                             SvgPicture.asset(clients, color: greyColor),
                             SizedBox(width: MySize.size16,),
                             const Text('Clients', style: AppTextStylesInter.label14700Color,),
                           ],
                         ),
                       ),
                     ),),

                     Visibility(
                       visible:  adminProvider.adminsE,
                       child:  lvp.index == 4?
                     Container(
                       padding: const EdgeInsets.all(16),
                       decoration: BoxDecoration(
                           color: const Color(0xffF8FAFC),
                           borderRadius: BorderRadius.circular(12)

                       ),
                       child: Row(
                         children: [
                           SvgPicture.asset(clients,),
                           SizedBox(width: MySize.size16,),
                           const Text('Admin', style: AppTextStylesInter.label14700P,),
                         ],
                       ),
                     )
                         :
                     InkWell(
                       onTap: (){
                         pageProvider.setPageNumber();
                         lvp.updateIndex(4);
                       },
                       child: Container(
                         padding: const EdgeInsets.all(16),
                         decoration: BoxDecoration(
                           // color: Color(0xffF8FAFC),
                             borderRadius: BorderRadius.circular(12)

                         ),
                         child: Row(
                           children: [
                             SvgPicture.asset(clients, color: greyColor),
                             SizedBox(width: MySize.size16,),
                             const Text('Admin', style: AppTextStylesInter.label14700Color,),
                           ],
                         ),
                       ),
                     ),),

                     Visibility(
                       visible:  adminProvider.categoryE,
                       child:  lvp.index == 5?
                     Container(
                       padding: const EdgeInsets.all(16),
                       decoration: BoxDecoration(
                           color: const Color(0xffF8FAFC),
                           borderRadius: BorderRadius.circular(12)

                       ),
                       child: Row(
                         children: [
                           SvgPicture.asset(categories,color: primaryColor,),
                           SizedBox(width: MySize.size16,),
                           const Text('Categories', style: AppTextStylesInter.label14700P,),
                         ],
                       ),
                     ):
                     InkWell(
                       onTap: (){
                         pageProvider.setPageNumber();
                         lvp.updateIndex(5);
                       },
                       child: Container(
                         padding: const EdgeInsets.all(16),
                         decoration: BoxDecoration(
                           // color: Color(0xffF8FAFC),
                             borderRadius: BorderRadius.circular(12)

                         ),
                         child: Row(
                           children: [
                             SvgPicture.asset(categories),
                             SizedBox(width: MySize.size16,),
                             const Text('Categories', style: AppTextStylesInter.label14700Color,),
                           ],
                         ),
                       ),
                     ),
                     ),

                     Visibility(
                       visible:  adminProvider.ordersE,
                       child:  lvp.index == 6?
                     Container(
                       padding: const EdgeInsets.all(16),
                       decoration: BoxDecoration(
                           color: const Color(0xffF8FAFC),
                           borderRadius: BorderRadius.circular(12)

                       ),
                       child: Row(
                         children: [
                           SvgPicture.asset(orders, color: primaryColor,),
                           SizedBox(width: MySize.size16,),
                           const Text('Orders', style: AppTextStylesInter.label14700P,),
                         ],
                       ),
                     ):
                     InkWell(
                       onTap: (){
                         pageProvider.setPageNumber();
                         lvp.changeClientOrderStatus();
                         recalculateTotalDocuments(context);

                           lvp.updateIndex(6);

                       },
                       child: Container(
                         padding: const EdgeInsets.all(16),
                         decoration: BoxDecoration(
                           // color: Color(0xffF8FAFC),
                             borderRadius: BorderRadius.circular(12)

                         ),
                         child: Row(
                           children: [
                             SvgPicture.asset(orders),
                             SizedBox(width: MySize.size16,),
                             const Text('Orders', style: AppTextStylesInter.label14700Color,),
                           ],
                         ),
                       ),
                     ),),

                      // lvp.index == 7?
                      // Container(
                      //   padding: EdgeInsets.all(16),
                      //   decoration: BoxDecoration(
                      //     color: Color(0xffF8FAFC),
                      //       borderRadius: BorderRadius.circular(12)
                      //
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       SvgPicture.asset(messages, color: primaryColor,),
                      //       SizedBox(width: MySize.size16,),
                      //       Text('Message', style: AppTextStylesInter.label14700P,),
                      //     ],
                      //   ),
                      // ):
                      // InkWell(
                      //   onTap: (){
                      //     lvp.updateIndex(7);
                      //   },
                      //   child: Container(
                      //     padding: EdgeInsets.all(16),
                      //     decoration: BoxDecoration(
                      //       // color: Color(0xffF8FAFC),
                      //         borderRadius: BorderRadius.circular(12)
                      //
                      //     ),
                      //     child: Row(
                      //       children: [
                      //         SvgPicture.asset(messages),
                      //         SizedBox(width: MySize.size16,),
                      //         Text('Message', style: AppTextStylesInter.label14700Color,),
                      //       ],
                      //     ),
                      //   ),
                      // ),



                      // InkWell(
                      //   onTap: ()async{
                      //    // String? token = await FirestoreService().getTokenFromUserCollection(FirebaseAuth.instance.currentUser!.uid);
                      //    //  NotificationServices().sendNotification(
                      //    //    token!,
                      //    //      context, 'Quote Received', 'You have received a quote for your project');
                      //
                      //     AuthServices().signOut().then((value){
                      //       Navigator.pushAndRemoveUntil(context,
                      //           MaterialPageRoute(builder: (context)=> const LoginView()), (route) => false);
                      //     }).onError((error, stackTrace) => Utils.toastMessage(error.toString()));
                      //   },
                      //   child: Container(
                      //     padding: const EdgeInsets.all(16),
                      //     decoration: BoxDecoration(
                      //       // color: Color(0xffF8FAFC),
                      //         borderRadius: BorderRadius.circular(12)
                      //
                      //     ),
                      //     child: Row(
                      //       children: [
                      //         SvgPicture.asset(logout),
                      //         SizedBox(width: MySize.size16,),
                      //         const Text('Log Out', style: AppTextStylesInter.label14700Color,),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    ) ;
  }
}
