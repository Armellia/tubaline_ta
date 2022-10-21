import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubaline_ta/providers/search_provider.dart';
import 'package:tubaline_ta/screens/jobs/list_job.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late bool search;
  late bool sort;
  String initalize = "";
  late TextEditingController textSearch = TextEditingController(
    text: initalize,
  );

  void setSort(bool sort) {
    setState(() {
      Provider.of<SearchProvider>(context, listen: false).setSort(sort);
      this.sort = sort;
    });
  }

  @override
  void initState() {
    super.initState();
    search = Provider.of<SearchProvider>(context, listen: false).isSearch;
    sort = Provider.of<SearchProvider>(context, listen: false).search.sort;
    initalize = Provider.of<SearchProvider>(context, listen: false).search.key;
  }

  Future alerValue() async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  content: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Column(
                      children: [
                        RadioListTile(
                          title: const Text("Terbaru"),
                          value: true,
                          groupValue: sort,
                          onChanged: (value) {
                            setState(() {
                              setSort(value!);
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text("Terlama"),
                          value: false,
                          groupValue: sort,
                          onChanged: (value) {
                            setState(() {
                              setSort(value!);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  title: ListTile(
                    title: const Text("Sort by"),
                    trailing: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close)),
                  ),
                );
              },
            ));
  }

  Widget showDialogue() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.07,
        child: Container(
            margin: const EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Container(
                    color: Colors.black12,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          Provider.of<SearchProvider>(context, listen: false)
                              .setKey(value);
                        });
                      },
                      controller: textSearch,
                      style: const TextStyle(color: Colors.black54),
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 5),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          hintText: 'Nama Pekerjaan..',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black54,
                          ),
                          hintStyle: TextStyle(color: Colors.black54)),
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    splashRadius: 0.1,
                    onPressed: () {
                      alerValue();
                    },
                    icon: const Icon(
                      Icons.sort_outlined,
                      color: Colors.black54,
                      size: 24,
                    ),
                  ),
                ),
              ],
            )));
  }

  Widget buttonSearch() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.05,
      margin: const EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            initalize =
                Provider.of<SearchProvider>(context, listen: false).search.key;
            Provider.of<SearchProvider>(context, listen: false)
                .setisSearch(true);
            search =
                Provider.of<SearchProvider>(context, listen: false).isSearch;
          });
        },
        child: const Center(
          child: Text("Search"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        showDialogue(),
        buttonSearch(),
        ListJob(keyword: initalize, sort: sort),
      ],
    );
  }
}
