import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tubaline_ta/models/profile.dart';
import 'package:tubaline_ta/models/user.dart';
import 'package:tubaline_ta/providers/loading_provier.dart';
import 'package:tubaline_ta/services/service_profile.dart';
import 'package:tubaline_ta/services/service_user.dart';
import 'package:tubaline_ta/widgets/loading.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({super.key, required this.id});
  final String id;
  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  Timestamp? birthDay;
  String? url;
  DateTime? dateTime;
  File? image;
  bool isRead = true;
  Future<ProfileModel>? dataProfile;
  ProfileModel? profileModel;
  User? dataUser;
  ServiceProfile serviceProfile = ServiceProfile();
  ServiceUser serviceUser = ServiceUser();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();

  Future<User> setData({ProfileModel? model}) async {
    final id = model!.userId!;
    return serviceUser.getUserDocs(id);
  }

  Future<DateTime> _selectDdate(
      BuildContext context, ProfileModel? profile) async {
    final selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2030));
    if (selected == null) return DateTime.now();
    dateTime = selected;
    return dateTime!;
  }

  updateProfile() {
    if (isRead) {
      setState(() {
        isRead = !isRead;
      });
    } else {
      setState(() {
        context.read<LoadingProvider>().setLoading(true);
      });
      birthDay = Timestamp.fromDate(dateTime!);
      final ProfileModel updateData = ProfileModel(
          name: nameController.text,
          updatedAt: Timestamp.now(),
          birthDay: birthDay ?? profileModel!.birthDay,
          numberPhone: int.parse(teleponController.text),
          imageUrl: url ?? profileModel!.imageUrl!);
      setState(() {
        serviceProfile.updateProfile(updateData).whenComplete(() {
          context.read<LoadingProvider>().setLoading(false);
          Navigator.pop(context, true);
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    dataProfile = serviceProfile.getProfile(widget.id);
    dataProfile!.then((value) {
      setData(model: value).then(
        (valueU) {
          if (!mounted) return;
          setState(() {
            profileModel = value;
            dataUser = valueU;
          });
          nameController.text = profileModel?.name ?? "";
          teleponController.text = profileModel?.numberPhone.toString() ?? "";
          emailController.text = dataUser!.email;
          dateTime = profileModel?.birthDay?.toDate();
        },
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildTextField({
    required BuildContext context,
    required bool readOnly,
    String? title,
    TextEditingController? textEditingController,
  }) {
    return Container(
      color: Colors.white54,
      margin: const EdgeInsets.all(5.0),
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus!.unfocus();
            },
            style: const TextStyle(fontSize: 24),
            controller: textEditingController,
            readOnly: readOnly,
            decoration: InputDecoration(
              label: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PTSans',
                    ),
                  )),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {
                    updateProfile();
                  },
                  child: Text(
                    isRead ? "Edit" : "Save",
                    style: const TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
        body: dataUser == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : LoadingScreen(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (isRead) return;

                            serviceProfile.uploadGallery().then((value) {
                              setState(() {
                                if (value == null || value == "") return;
                                url = value;
                                image = File(value);
                              });
                            });
                          },
                          child: Center(
                            child: image != null
                                ? CircleAvatar(
                                    foregroundImage: Image.file(image!).image,
                                    radius: 60.0,
                                  )
                                : CircleAvatar(
                                    foregroundImage: profileModel!.imageUrl ==
                                            null
                                        ? const AssetImage(
                                            'assets/images/profile.png')
                                        : Image.network(profileModel!.imageUrl!)
                                            .image,
                                    radius: 60.0,
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildTextField(
                            context: context,
                            readOnly: isRead,
                            textEditingController: nameController,
                            title: "Nama"),
                        _buildTextField(
                            context: context,
                            readOnly: true,
                            textEditingController: emailController,
                            title: "Email"),
                        _buildTextField(
                            context: context,
                            readOnly: isRead,
                            textEditingController: teleponController,
                            title: "No. Telepon"),
                        Container(
                          color: Colors.white54,
                          margin: const EdgeInsets.all(5.0),
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: const Icon(Icons.date_range),
                                title: const Text(
                                  "Pilih Tanggal",
                                  style: TextStyle(fontSize: 12),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    dateTime != null ? dateTime.toString() : "",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                onTap: () async {
                                  await _selectDdate(context, profileModel)
                                      .then((value) {
                                    setState(() {
                                      dateTime = value;
                                    });
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
