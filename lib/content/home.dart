import 'dart:developer';
import 'package:anime_app/api/service.dart';
import 'package:anime_app/content/my_list.dart';
import 'package:anime_app/content/utils.dart';
import 'package:flutter/material.dart';

import '../api/model.dart';
import '../persistence/database.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

    final list = await Service().getAnimeList(limit,offset);

    setState(() {
      _list = list ?? [];
      loading = false;
    });
  }

  Future<void> loadMore() async {
    setState(() {
      loading = true;
    });

    final list = await Service().getAnimeList(limit,offset);

    setState(() {
      _list.addAll(list ?? []);
      offset += limit;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()))
        : Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyList())
                );
              },
              icon: const Icon(Icons.list_alt))
        ],
        title: const Text('AnimeApp'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
            child: Column(
              children: [
                const Text('Api Anime List'),
                UtilComponents().space(12.0, 0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _list.length + 1,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index < _list.length) {
                        return ListTile(
                          title: Text(_list[index].title),
                          subtitle: Text(_list[index].year.toString()),
                          leading: Image.network(_list[index].image),
                          trailing: IconButton(
                            icon: const Icon(Icons.favorite),
                            onPressed: () {
                              final anime = _list[index];
                              DatabaseProvider.insertAnime(anime);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added to favorites')),
                              );
                            },
                          ),
                        );
                      } else if (loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadMore,
        child: const Icon(Icons.arrow_downward),
      ),
    );
  }
}
