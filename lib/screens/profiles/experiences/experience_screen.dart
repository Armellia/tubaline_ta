import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:tubaline_ta/models/experience.dart';
import 'package:tubaline_ta/providers/loading_provier.dart';
import 'package:tubaline_ta/services/service_experience.dart';
import 'package:tubaline_ta/widgets/loading.dart';
import 'package:tubaline_ta/widgets/snackbar.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  final ServiceExperience serviceExperience = ServiceExperience();
  final TextEditingController pengalamanController = TextEditingController();
  final TextEditingController tahunController = TextEditingController();

  Stream<List<Experience>> fetchStream() async* {
    yield await serviceExperience.fetchExperience();
  }

  void clear() {
    pengalamanController.text = "";
    tahunController.text = "";
  }

  void addExperience() {
    if (tahunController.text == "" || pengalamanController.text == "") {
      SnackBars().showSnackBar(context, "Lengkapi kolom text terlebih dahulu");
    }
    Navigator.pop(context);
    context.read<LoadingProvider>().setLoading(true);
    Experience data = Experience(
        experienceAt: pengalamanController.text, year: tahunController.text);
    serviceExperience.addExperience(data).whenComplete(() {
      clear();
      context.read<LoadingProvider>().setLoading(false);
    });
  }

  void deleteExperience(String id) {
    context.read<LoadingProvider>().setLoading(true);
    serviceExperience.deleteExperiece(id).whenComplete(() {
      setState(() {
        context.read<LoadingProvider>().setLoading(false);
      });
    });
  }

  Widget _buildtextfield(
      {required String title,
      required TextEditingController textEditingController}) {
    return TextField(
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

  Future<void> showDialogue(BuildContext context) async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
            TextButton(
                onPressed: () {
                  addExperience();
                },
                child: Text("Tambah")),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text("Masukkan Pengalaman Kerja"),
          elevation: 2,
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildtextfield(
                    title: "Pengalaman",
                    textEditingController: pengalamanController),
                Divider(height: 20),
                _buildtextfield(
                    title: "Tahun", textEditingController: tahunController),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Pengalaman Kerja"),
            actions: [
              IconButton(
                  onPressed: () {
                    showDialogue(context).then((value) {
                      setState(() {});
                    });
                  },
                  icon: Icon(Icons.add_circle_outline))
            ],
          ),
          body: SafeArea(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder(
                stream: fetchStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.data == null || snapshot.data == "") {
                    return const Center(child: Text("Belum ada data"));
                  } else {
                    return ListView(
                        children: snapshot.data!
                            .map((doc) => Card(child: card(doc)))
                            .toList());
                  }
                },
              ),
            ),
          )),
    );
  }

  Widget card(Experience data) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 10,
        shadowColor: Colors.black54,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              ListTile(
                title: Text("Pengalaman : ${data.experienceAt}"),
                subtitle: Text("Tahun : ${data.year}"),
                trailing: IconButton(
                    onPressed: () {
                      deleteExperience(data.id!);
                    },
                    icon: Icon(Icons.delete)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
