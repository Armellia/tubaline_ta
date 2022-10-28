import 'dart:io';

import 'package:flutter/material.dart';

import 'package:tubaline_ta/models/profile.dart';
import 'package:tubaline_ta/models/user.dart';
import 'package:tubaline_ta/services/service_profile.dart';
import 'package:tubaline_ta/services/service_user.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({super.key, required this.id});
  final String id;
  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  File? image;
  bool isRead = true;
  Future<ProfileModel>? dataProfile;
  ProfileModel? profileModel;
  User? dataUser;
  DateTime? date;
  ServiceProfile serviceProfile = ServiceProfile();
  ServiceUser serviceUser = ServiceUser();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<User> setData({ProfileModel? model}) async {
    final id = model!.userId!;
    return serviceUser.getUserDocs(id);
  }

  Future<DateTime> _selectDdate(
      BuildContext context, ProfileModel? profile) async {
    DateTime? dateTime;
    final selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2030));
    if (selected == null) return DateTime.now();
    dateTime = selected;
    return dateTime;
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
          emailController.text = dataUser!.email;
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
      margin: EdgeInsets.all(5.0),
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: TextStyle(fontSize: 24),
            controller: textEditingController,
            readOnly: readOnly,
            decoration: InputDecoration(
              label: Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    title!,
                    style: TextStyle(
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
                    print(profileModel!.imageUrl);
                    setState(() {
                      isRead = !isRead;
                    });
                  },
                  child: Text(
                    isRead ? "Edit" : "Save",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
        body: dataUser == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isRead) return;

                          serviceProfile.uploadGallery().then((value) {
                            setState(() {
                              if (value == null || value == "") return;
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
                                      ? AssetImage('assets/images/profile.png')
                                      : Image.network(profileModel!.imageUrl!)
                                          .image,
                                  radius: 60.0,
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _buildTextField(
                          context: context,
                          readOnly: isRead,
                          textEditingController: nameController,
                          title: "Nama"),
                      _buildTextField(
                          context: context,
                          readOnly: isRead,
                          textEditingController: emailController,
                          title: "Email"),
                      Container(
                        color: Colors.white54,
                        margin: EdgeInsets.all(5.0),
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Icon(Icons.date_range),
                              title: Text(
                                "Pilih Tanggal",
                                style: TextStyle(fontSize: 12),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  date != null ? date.toString() : "",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              onTap: () async {
                                await _selectDdate(context, profileModel)
                                    .then((value) {
                                  setState(() {
                                    date = value;
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
              ));
  }
}