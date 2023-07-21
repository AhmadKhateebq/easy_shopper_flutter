import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../Apis/product/product_api.dart';
import '../../../Style/borders.dart';
import '../../../providers/productProvider.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  String imageUrl = '';
  File? img;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        child: SizedBox(
                                          width: 150,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.photo),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "from Gallery",
                                              ),
                                            ],
                                          ),
                                        ),
                                        onPressed: () async {
                                          ImagePicker imagePicker =
                                              ImagePicker();
                                          XFile? file =
                                              (await imagePicker.pickImage(
                                                  source:
                                                      ImageSource.gallery))!;
                                          var imageTemporary = File(file.path);
                                          setState(() {
                                            img = imageTemporary;
                                          });

                                          if (file == null) return;
                                          Reference referenceRoot =
                                              FirebaseStorage.instance.ref();
                                          Reference referenceDirImages =
                                              referenceRoot.child('images');
                                          var number = Random().nextInt(100000);
                                          Reference referenceImageToUpload =
                                              referenceDirImages
                                                  .child('name $number');

                                          try {
                                            //Store the file
                                            await referenceImageToUpload
                                                .putFile(File(file.path));
                                            //Success: get the download URL

                                            imageUrl =
                                                await referenceImageToUpload
                                                    .getDownloadURL();
                                          } catch (error) {
                                            //Some error occurred
                                          }
                                        }),
                                    Divider(),
                                    ElevatedButton(
                                        child: SizedBox(
                                          width: 150,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.camera_alt),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "from Camera",
                                              ),
                                            ],
                                          ),
                                        ),
                                        onPressed: () async {
                                          ImagePicker imagePicker =
                                              ImagePicker();
                                          XFile? file =
                                              await imagePicker.pickImage(
                                                  source: ImageSource.camera);

                                          print('${file?.path}');
                                          var imageTemporary = File(file!.path);
                                          setState(() {
                                            img = imageTemporary;
                                          });
                                          if (file == null) return;
                                          Reference referenceRoot =
                                              FirebaseStorage.instance.ref();
                                          Reference referenceDirImages =
                                              referenceRoot.child('images');
                                          var number = Random().nextInt(100000);
                                          Reference referenceImageToUpload =
                                              referenceDirImages
                                                  .child('name $number');

                                          try {
                                            //Store the file
                                            await referenceImageToUpload
                                                .putFile(File(file.path));
                                            //Success: get the download URL
                                            imageUrl =
                                                await referenceImageToUpload
                                                    .getDownloadURL();
                                            print(imageUrl);
                                          } catch (error) {
                                            //Some error occurred
                                          }
                                        }),
                                  ],
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  child: const Text("Ok"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.black), // Optional border
                      ),
                      child: img != null
                          ? Center(
                              child: Image.file(
                                img!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: Image.asset(
                                "lib/Assets/Images/chooseImage.jpg",
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill,
                              ),
                            ),
                    )),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    labelStyle: TextStyle(color: Colors.red),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .red), // Red border color when the field is focused
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .red), // Red border color when the field is not focused
                    ),
                  ),
                  controller: productNameController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Brand',
                    labelStyle: TextStyle(color: Colors.red),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .red), // Red border color when the field is focused
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .red), // Red border color when the field is not focused
                    ),
                  ),
                  controller: brandController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: Colors.red),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .red), // Red border color when the field is focused
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .red), // Red border color when the field is not focused
                    ),
                  ),
                  controller: categoryController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                TextFormField(
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.red),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .red), // Red border color when the field is focused
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .red), // Red border color when the field is not focused
                    ),
                  ),
                  controller: descriptionController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: AppBorders.btnStyle(),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      ProductApi productApi = ProductApi();
                      productApi.addProductApi(
                          productNameController.text,
                          brandController.text,
                          categoryController.text,
                          imageUrl,
                          descriptionController.text);
                    }
                    Navigator.pop(context) ;
                  },
                  child: Text('Add Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
