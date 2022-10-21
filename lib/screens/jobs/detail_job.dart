// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:tubaline_ta/models/user.dart';
import 'package:tubaline_ta/services/service_job.dart';

class DetailJob extends StatefulWidget {
  const DetailJob({super.key, required this.id});
  final String id;
  @override
  State<DetailJob> createState() => _DetailJobState();
}

class _DetailJobState extends State<DetailJob> {
  final serviceJob = ServiceJob();
  late Future<User> getUser;

  @override
  void initState() {
    super.initState();
    getUser = serviceJob.getUser(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id.toString(),
          style: const TextStyle(color: Colors.white60),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white60,
          ),
        ),
      ),
      body: FutureBuilder(
          future: getUser,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.9,
                child: Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: ListView.builder(
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(snapshot.data!.email),
                                subtitle: Text(snapshot.data!.password),
                              ),
                            );
                          }),
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
                            onPressed: () =>
                                print(snapshot.data!.createAt.toDate()),
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
}
