import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:tubaline_ta/models/job.dart';
import 'package:tubaline_ta/models/profile.dart';
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
  @override
  void initState() {
    super.initState();
    pelamar = widget.data.pelamarId;
    dataPelamar = pelamar!.values.toList();
    serviceJob.fetchProfile().then((value) {
      dataProfile.addAll(value);
      dataPelamar.forEach((element) {
        data = element as DocumentReference;
        dataProfileFilter.addAll(dataProfile
            .where((element) => element.id!.compareTo(data!.id) == 0)
            .toList());
      });
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.data.title!),
          centerTitle: true,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(8.0),
            child: widget.data.pelamarId == null
                ? Center(
                    child: Text("Tidak ada pelamar"),
                  )
                : loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: dataProfileFilter.length,
                        itemBuilder: (context, index) {
                          return Text(dataProfileFilter[index].name!);
                        },
                      )));
  }
}
