import 'package:flutter/material.dart';
import 'package:tubaline_ta/models/user.dart';
import 'package:tubaline_ta/screens/jobs/detail_job.dart';
import 'package:tubaline_ta/services/service_job.dart';

class ListJob extends StatefulWidget {
  const ListJob({super.key, required this.keyword, required this.sort});
  final String keyword;
  final bool sort;

  @override
  State<ListJob> createState() => _ListJobState();
}

class _ListJobState extends State<ListJob> {
  final serviceJob = ServiceJob();

  Stream<List<User>> fetchStream() async* {
    yield await serviceJob.fetchAllUser(widget.sort);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StreamBuilder(
      stream: fetchStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView(
              children:
                  snapshot.data!.map((doc) => Card(child: card(doc))).toList());
        }
      },
    ));
  }

  Widget card(User user) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailJob(
            id: user.id.toString(),
          ),
        ));
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 10,
          shadowColor: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                ListTile(
                  title: Text(user.id.toString()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
