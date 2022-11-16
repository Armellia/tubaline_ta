import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:tubaline_ta/models/job.dart';
import 'package:tubaline_ta/models/profile.dart';
import 'package:tubaline_ta/screens/jobs/detail_my_job.dart';
import 'package:tubaline_ta/services/service_job.dart';

class MyJob extends StatefulWidget {
  const MyJob({super.key, required this.model});
  final ProfileModel model;
  @override
  State<MyJob> createState() => _MyJobState();
}

class _MyJobState extends State<MyJob> {
  ServiceJob serviceJob = ServiceJob();
  Stream<List<Job>> fetchJob() async* {
    yield await serviceJob.getJobByProfile(widget.model.id!);
  }

  String countLamar(Job jobModel) {
    if (jobModel.pelamarId == null) return "0";
    final data = jobModel.pelamarId as LinkedHashMap;
    return data.length.toString();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("data"),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: fetchJob(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text("Tidak ada data"),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return card(snapshot.data![index]);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget card(Job job) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailMyJob(data: job),
            )).whenComplete(() {
          setState(() {
            fetchJob();
          });
        });
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
                  trailing: Text("${countLamar(job)} Pelamar"),
                  horizontalTitleGap: 5,
                ),
                const Divider(
                  height: 5,
                ),
                ListTile(
                  title: Text(
                    "Dipost tanggal : ${createdData(job.createdAt!.toDate())}",
                    style: TextStyle(color: Colors.blue[300], fontSize: 14),
                  ),
                  horizontalTitleGap: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
