import 'package:flutter/material.dart';
import 'package:anime_app/api/model.dart';
import 'package:anime_app/api/service.dart';
import 'package:anime_app/content/utils.dart';

import '../persistence/database.dart';

class MyList extends StatefulWidget {
  const MyList({Key? key}) : super(key: key);

  @override
  State<MyList> createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  bool loading = false;
  int offset = 0;
  int limit = 25;
  List<Anime> _list = [];

  @override
  void initState() {
    super.initState();
    getList();
  }

  Future<void> getList() async {
    setState(() {
      loading = true;
    });

    final List<Anime> list = await DatabaseProvider.getFavoriteAnimes();

    setState(() {
      _list = list;
      loading = false;
    });
  }

  Future<void> loadMore() async {
    // Not needed for displaying the local anime list
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()))
        : Scaffold(
      appBar: AppBar(
        title: const Text('AnimeApp'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
            child: Column(
              children: [
                const Text('Local Anime List'),
                UtilComponents().space(12.0, 0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _list.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_list[index].title),
                        subtitle: Text(_list[index].year.toString()),
                        leading: Image.network(_list[index].image),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            final malId = _list[index].mal_id;
                            DatabaseProvider.deleteAnime(malId).then((_) {
                              setState(() {
                                _list.removeWhere((anime) => anime.mal_id == malId);
                              });
                            });
                          },
                        ),

                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
