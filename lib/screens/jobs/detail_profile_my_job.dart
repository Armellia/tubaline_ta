import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tubaline_ta/models/experience.dart';
import 'package:tubaline_ta/models/job.dart';
import 'package:tubaline_ta/models/myapply.dart';
import 'package:tubaline_ta/models/profile.dart';
import 'package:tubaline_ta/models/user.dart';
import 'package:tubaline_ta/services/service_experience.dart';
import 'package:tubaline_ta/services/service_myapply.dart';
import 'package:tubaline_ta/services/service_user.dart';

class DetailProfileMyJob extends StatefulWidget {
  const DetailProfileMyJob(
      {super.key, required this.job, required this.profile});
  final Job job;
  final ProfileModel profile;
  @override
  State<DetailProfileMyJob> createState() => _DetailProfileMyJobState();
}

ServiceUser serviceUser = ServiceUser();
ServiceMyApply serviceMyApply = ServiceMyApply();
ServiceExperience serviceExperience = ServiceExperience();

class _DetailProfileMyJobState extends State<DetailProfileMyJob> {
  MyApply? myApply;
  List<Experience>? experience;
  Stream<User> streamUser() async* {
    yield await serviceUser.getUserDocs(widget.profile.userId!);
  }

  String createdData(DateTime date) {
    String? month;
    switch (date.month) {
      case 1:
        month = "Januari";
        break;
      case 2:
        month = "Februari";
        break;
      case 3:
        month = "Maret";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "Mei";
        break;
      case 6:
        month = "Juni";
        break;
      case 7:
        month = "Juli";
        break;
      case 8:
        month = "Agustus";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "Oktober";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "Desember";
        break;
      default:
    }
    return '${date.day}-$month-${date.year}';
  }

  @override
  void initState() {
    super.initState();
    serviceExperience.getExperience(widget.profile.id!).then((value) {
      if (value.isEmpty) {
        experience = null;
      } else {
        experience!.addAll(value);
      }
    });
    serviceMyApply.getMyApply(widget.job, widget.profile).then((value) {
      setState(() {
        myApply = value;
      });
      if (kDebugMode) {
        print(myApply.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profile.name!),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: streamUser(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (myApply == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.88,
                margin: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.79,
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          CircleAvatar(
                            radius: 60.0,
                            child: widget.profile.imageUrl == null
                                ? Image.asset(
                                    'assets/images/profile.png',
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(widget.profile.imageUrl!,
                                    fit: BoxFit.cover),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  const Text(
                                    "Profile",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  _columnfield(widget.profile.name!, "nama"),
                                  _columnfield(
                                      widget.profile.numberPhone.toString(),
                                      "No. Telepon"),
                                  _columnfield(snapshot.data!.email, "Email"),
                                  _columnfield(
                                      createdData(myApply!.createdAt!.toDate()),
                                      "Dilamar pada"),
                                ],
                              ),
                            ),
                          ),
                          const Divider(
                            height: 5,
                          ),
                          Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  const Text(
                                    "Profile",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  experience == null
                                      ? const Text("Kosong")
                                      : ListView.builder(
                                          itemBuilder: (context, index) {
                                            return Text(experience!
                                                .elementAt(index)
                                                .experienceAt!);
                                          },
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.10,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      side: const BorderSide(
                                          width: 3, color: Colors.blueAccent),
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      // print(data!.then((value) {
                                      //   print(value.id);
                                      // }));
                                    },
                                    child: const Center(
                                      child: Text("Tolak"),
                                    )),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      side: const BorderSide(
                                          width: 3, color: Colors.blueAccent),
                                      backgroundColor: Colors.blue,
                                    ),
                                    onPressed: () {
                                      // print(data!.then((value) {
                                      //   print(value.id);
                                      // }));
                                    },
                                    child: const Center(
                                      child: Text("Lamar"),
                                    )),
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _columnfield(String data, String title) {
    return ListTile(
      minVerticalPadding: 5,
      horizontalTitleGap: 20,
      title: Text(title),
      subtitle: Text(data),
    );
  }
}
