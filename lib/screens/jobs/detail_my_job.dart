import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tubaline_ta/models/job.dart';
import 'package:tubaline_ta/models/profile.dart';
import 'package:tubaline_ta/screens/jobs/detail_profile_my_job.dart';
import 'package:tubaline_ta/services/service_job.dart';

class DetailMyJob extends StatefulWidget {
  const DetailMyJob({super.key, required this.data});
  final Job data;
  @override
  State<DetailMyJob> createState() => _DetailMyJobState();
}

final serviceJob = ServiceJob();

class _DetailMyJobState extends State<DetailMyJob> {
  bool loading = true;
  LinkedHashMap? pelamar;
  List dataPelamar = [];
  List<ProfileModel> dataProfile = [];
  List<ProfileModel> dataProfileFilter = [];
  DocumentReference? data;
  List dataList = [];
  @override
  void initState() {
    super.initState();
    pelamar = widget.data.pelamarId;
    dataPelamar = pelamar!.values.toList();
    serviceJob.fetchProfile().then((value) {
      dataProfile.addAll(value);
      for (var element in dataPelamar) {
        data = element as DocumentReference;
        saveData(data!);
      }
      setState(() {
        loading = false;
      });
    });
  }

  saveData(DocumentReference doc) {
    dataProfileFilter
        .add(dataProfile.where((element) => element.id == doc.id).first);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.data.title!),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  elevation: 2,
                  padding: const EdgeInsets.all(8.0),
                ),
                onPressed: () {
                  serviceJob.deactiveJob(widget.data.id!, context);
                },
                child: const Text("Matikan Post"),
              ),
            )
          ],
        ),
        body: widget.data.pelamarId == null
            ? const Text("Tidak ada data")
            : loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: dataProfileFilter.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        elevation: 5.0,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailProfileMyJob(
                                    job: widget.data,
                                    profile: dataProfileFilter.elementAt(index),
                                  ),
                                ));
                          },
                          trailing: Text(
                            "Lihat",
                            style: TextStyle(
                                color: Colors.blue[200], fontSize: 12),
                          ),
                          visualDensity: const VisualDensity(vertical: 4),
                          title: Text(
                              style: const TextStyle(fontSize: 18),
                              dataProfileFilter.elementAt(index).name == null
                                  ? "Nama Belum Diset"
                                  : dataProfileFilter
                                      .elementAt(index)
                                      .name
                                      .toString()),
                          leading: CircleAvatar(
                            foregroundImage: dataProfileFilter
                                        .elementAt(index)
                                        .imageUrl ==
                                    null
                                ? const AssetImage('assets/images/profile.png')
                                : Image.network(dataProfileFilter
                                        .elementAt(index)
                                        .imageUrl!)
                                    .image,
                            radius: 30.0,
                          ),
                        ),
                      );
                    },
                  ));
  }
}
