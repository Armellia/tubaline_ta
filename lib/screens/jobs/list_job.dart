import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubaline_ta/models/job.dart';
import 'package:tubaline_ta/models/profile.dart';
import 'package:tubaline_ta/screens/jobs/detail_job.dart';
import 'package:tubaline_ta/services/service_job.dart';
import 'package:tubaline_ta/widgets/alert.dart';

class ListJob extends StatefulWidget {
  const ListJob({super.key, required this.keyword, required this.sort});
  final String keyword;
  final bool sort;

  @override
  State<ListJob> createState() => _ListJobState();
}

ServiceJob serviceJob = ServiceJob();

class _ListJobState extends State<ListJob> {
  List<ProfileModel> dataProfile = [];
  bool loading = true;
  String? id;
  Stream<List<Job>> fetchData() async* {
    yield await serviceJob.fetchJobs(widget.sort);
  }

  String time(DateTime date) {
    Duration selisih = DateTime.now().difference(date);
    if (selisih.inDays >= 1) {
      return "${selisih.inDays} Hari Yang Lalu";
    } else if (selisih.inHours >= 1) {
      return "${selisih.inHours} Jam Yang Lalu";
    } else if (selisih.inMinutes >= 1) {
      return "${selisih.inMinutes} Menit Yang Lalu";
    } else {
      return "${selisih.inSeconds} Detik Yang Lalu";
    }
  }

  Future _onRefresh() async {
    setState(() {
      fetchData();
    });
  }

  ProfileModel filter(Job job) {
    return dataProfile
        .where((element) => element.id!.contains(job.pembuatId!.id))
        .first;
  }

  bool check(Job job) {
    if (job.pelamarId == null) return false;
    final data = job.pelamarId as LinkedHashMap;
    final idP = db.doc('profile/$id');
    return data.containsValue(idP);
  }

  @override
  void initState() {
    super.initState();
    serviceJob.fetchProfile().then((value) {
      SharedPreferences.getInstance().then((val) {
        id = val.getString('profile');
        setState(() {
          dataProfile.addAll(value);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StreamBuilder(
      stream: fetchData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.data!.isEmpty) {
          return const Center(child: Text("Tidak Ada Data"));
        } else {
          return dataProfile.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: card(snapshot.data![index],
                            filter(snapshot.data![index])),
                      );
                    },
                  ),
                );
        }
      },
    ));
  }

  Widget card(Job job, ProfileModel model) {
    return GestureDetector(
      onTap: () {
        if (job.pembuatId!.id.compareTo(id!) == 0) {
          Alert()
              .show(context, "Kamu tidak dapat melamar pekerjaanmu sendiri")
              .whenComplete(() {
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (context) => DetailJob(
                id: job.id.toString(),
              ),
            ));
          });
        } else {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => DetailJob(
              done: check(job),
              id: job.id.toString(),
            ),
          ));
        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 10,
          shadowColor: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    job.title.toString(),
                    style: TextStyle(color: Colors.blue[300], fontSize: 28),
                  ),
                  horizontalTitleGap: 5,
                  subtitle: Text(
                    model.name ?? "Nama Belum Diset",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Divider(
                  height: 5,
                ),
                ListTile(
                  title: Text(
                    time(job.createdAt!.toDate()),
                    style: const TextStyle(color: Colors.black54, fontSize: 11),
                  ),
                  trailing: check(job)
                      ? Text(
                          'Kamu telah melamar pekerjaan ini',
                          style: TextStyle(color: Colors.red[200]),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
