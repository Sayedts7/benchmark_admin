
import 'package:benchmark_estimate_admin_panel/view_model/provider/category_tag_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/MySize.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/textStyles.dart';
import '../../utils/custom_widgets/custom_button.dart';
import '../../utils/custom_widgets/custom_textfield.dart';
import '../../utils/custom_widgets/reusable_container.dart';
import '../../utils/utils.dart';
import '../../view_model/provider/loader_view_provider.dart';

class SubCategoryView extends StatefulWidget {
  const SubCategoryView({super.key});

  @override
  State<SubCategoryView> createState() => _SubCategoryViewState();
}

class _SubCategoryViewState extends State<SubCategoryView> {

  @override
  Widget build(BuildContext context) {

    return Consumer<CategoryTagProvider>(
      builder: (context, value, child){
        return ReusableContainer(
          height: 600,
          width: double.infinity,
          bgColor: whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child:Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sub Categories',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomButton8(text: 'Edit', onPressed: () {
                      showCustomDialog(context, true, value.category,value.id );
                    }, width: MySize. size150, height: MySize.size45,)
                  ],
                ),
                SizedBox(height: MySize.size20),
                // Main Content
                SizedBox(
                  height: MySize.size550,
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: value.tags.map((tag) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Chip(
                            label: Text(tag, style: const TextStyle(fontSize: 16, color: primaryColor),),
                            backgroundColor: primaryColor.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(29),
                              side: const BorderSide(color: Color(0xFF3B6FD4), width: 1),
                            ),

                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )

              ],
            ),
          ),
        );
      },

    );
  }

  Future<void> showCustomDialog(BuildContext context, bool editing, String cat,String docId  ) async {
    final TextEditingController firstController = TextEditingController();
    final TextEditingController secondController = TextEditingController();
    if(editing == true) {
      firstController.text = cat;
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<CategoryTagProvider>(
          builder: (context, tagProvider, child) {
            return Dialog(
              backgroundColor: whiteColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: whiteColor,

                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: MySize.size400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          editing == true? 'Edit Category':
                          'Add Category',

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField13(
                          hintText: 'Category',
                          controller: firstController,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField13(
                          hintText: 'Sub Category',
                          controller: secondController,
                          sufixIcon: IconButton(icon: const Icon(Icons.add),
                            onPressed: (){
                              tagProvider.addTag(secondController.text);
                              secondController.clear();
                            },),
                        ),
                        SizedBox(height: 10,),
                        DottedBorder(
                          borderType: BorderType.RRect,
                          color: primaryColor,
                          strokeWidth: 1,
                          dashPattern: [5, 2],
                          radius: Radius.circular(10),
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: appColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .center,
                                children: [
                                  Text('Upload CVS',
                                    style: AppTextStylesInter
                                        .label14700P,)
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: tagProvider.tag.length < 5 ? 100 : 200,
                          child: SingleChildScrollView(
                            child: Wrap(
                              children: tagProvider.tags.map((tag) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Chip(
                                    label: Text(tag, style: const TextStyle(fontSize: 16, color: primaryColor),),
                                    backgroundColor: primaryColor.withOpacity(0.2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(29),
                                      side: const BorderSide(color: Color(0xFF3B6FD4), width: 1),
                                    ),
                                    deleteIcon: Icon(Icons.close,color: primaryColor, size: MySize.size15,),
                                    onDeleted: () => tagProvider.removeTag(tag),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton8(
                              onPressed: () {
                                tagProvider.tag.clear();
                                Navigator.of(context).pop();},
                              text: 'Cancel',
                              backgroundColor: whiteColor,
                              textColor: blackColor,

                              height: MySize.size40,
                              width: MySize.size100,
                            ),
                            SizedBox(width: MySize.size10),
                            CustomButton8(
                              onPressed: () {
                                final obj = Provider.of<LoaderViewProvider>(context, listen: false);

                                // Add your action for 'Add' button here
                                if(editing){
                                  obj.changeShowLoaderValue(true);
                                  FirebaseFirestore.instance.collection('Categories').doc(docId).update({
                                    'categoryName': firstController.text,
                                    'subCategory': tagProvider.tag
                                  }).then((value) {
                                    obj.changeShowLoaderValue(false);
                                    Utils.toastMessage('Category Updated');
                                    tagProvider.tag.clear();

                                  }).onError((error, stackTrace) {
                                    Utils.toastMessage(error.toString());
                                    print(error);
                                    obj.changeShowLoaderValue(false);
                                    tagProvider.tag.clear();


                                  });
                                }else{
                                  var id = DateTime.now().millisecondsSinceEpoch.toString();
                                  obj.changeShowLoaderValue(true);
                                  FirebaseFirestore.instance.collection('Categories').doc(id).set({
                                    'id': id,
                                    'categoryName': firstController.text,
                                    'subCategory': tagProvider.tag
                                  }).then((value) {
                                    obj.changeShowLoaderValue(false);
                                    Utils.toastMessage('Category Added');
                                    tagProvider.tag.clear();

                                  }).onError((error, stackTrace) {
                                    Utils.toastMessage(error.toString());
                                    print(error);

                                    obj.changeShowLoaderValue(false);
                                    tagProvider.tag.clear();


                                  });
                                }

                                Navigator.of(context).pop();
                              },
                              text: editing == true ? 'Update':'Add',
                              height: MySize.size40,
                              width:  MySize.size100,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }



}
