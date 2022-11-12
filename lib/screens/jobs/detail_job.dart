// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:tubaline_ta/models/job.dart';
import 'package:tubaline_ta/models/myapply.dart';
import 'package:tubaline_ta/services/service_job.dart';

class DetailJob extends StatefulWidget {
  const DetailJob({super.key, required this.id});
  final String id;
  @override
  State<DetailJob> createState() => _DetailJobState();
}

class _DetailJobState extends State<DetailJob> {
  final serviceJob = ServiceJob();
  late Future<Job> getJob;
  Future<MyApply>? data;
  @override
  void initState() {
    super.initState();
    getJob = serviceJob.getJob(widget.id);
    data = serviceJob.checkApply(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail",
          style: TextStyle(color: Colors.white70),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getJob,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.9,
                child: Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Card(
                        child: ListTile(
                          title: Text(snapshot.data!.description!),
                        ),
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
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  width: 3, color: Colors.blueAccent),
                              backgroundColor: Colors.white70,
                              foregroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              print(data!.then((value) {
                                print(value.id);
                              }));
                              // lamar(snapshot.data!.id!);
                            },
                            child: const Center(
                              child: Text("Lamar"),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  void lamar(String id) async {
    await serviceJob.lamarJob(context, id).whenComplete(() {
      Navigator.pop(context);
    });
  }
}
