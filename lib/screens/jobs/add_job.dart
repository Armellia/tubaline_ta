import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubaline_ta/models/job.dart';
import 'package:tubaline_ta/providers/loading_provier.dart';
import 'package:tubaline_ta/services/service_job.dart';
import 'package:tubaline_ta/widgets/loading.dart';

class AddJob extends StatefulWidget {
  const AddJob({super.key});

  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController gajiController = TextEditingController();
  ServiceJob serviceJob = ServiceJob();

  void addData() {
    context.read<LoadingProvider>().setLoading(true);
    Job data = Job(
        title: titleController.text,
        description: descController.text,
        isActive: 1);
    serviceJob.addJob(data).whenComplete(() {
      context.read<LoadingProvider>().setLoading(false);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tambah"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.9,
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Column(
                    children: [
                      _buildtextfield(
                          title: "Title",
                          textEditingController: titleController),
                      const Divider(
                        height: 10,
                      ),
                      _buildtextfield(
                          title: "Description",
                          textEditingController: descController,
                          maxLine: 5),
                      _buildtextfield(
                        title: "Bayaran",
                        textEditingController: gajiController,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildButton(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildtextfield(
      {required String title,
      required TextEditingController textEditingController,
      int? maxLine}) {
    return TextField(
      maxLines: maxLine ?? 1,
      controller: textEditingController,
      cursorWidth: 2,
      decoration: InputDecoration(
        labelText: title,
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.black38),
            borderRadius: BorderRadius.circular(30.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.black38),
            borderRadius: BorderRadius.circular(30.0)),
        labelStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.bold,
          fontFamily: 'PTSans',
        ),
      ),
    );
  }

  Widget _buildButton() {
    return SizedBox(
      height: 64,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(6),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
            ),
          ),
        ),
        child: const Text(
          'Simpan',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        onPressed: () {
          addData();
        },
      ),
    );
  }
}
