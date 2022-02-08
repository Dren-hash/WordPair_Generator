import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _randomWordPairs = <
      WordPair>[]; // this is a list. representation of the combination of two words
  final savedWordPairs =
      Set<WordPair>(); // this is to save the liked words as a set

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, item) {
        if (item.isOdd) return Divider();

        final index = item ~/
            2; // calculates the number of words that are in the listview minus the divider widget

        if (index >= _randomWordPairs.length) {
          _randomWordPairs.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_randomWordPairs[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = savedWordPairs.contains(pair);
    return ListTile(
        title: Text(
          pair.asPascalCase,
          style: TextStyle(fontSize: 18.0),
        ),
        trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              savedWordPairs.remove(pair);
            } else {
              savedWordPairs.add(pair);
            }
          });
        });
  }

  void pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = savedWordPairs.map((WordPair pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: TextStyle(fontSize: 16.0),
          ),
        );
      });
      final List<Widget> divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text('Saved WordPairs'),
        ),
        body: ListView(children: divided),
      );
    }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('WordPair Generator'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.list),
                onPressed:
                    pushSaved) // this is to create the 3lines icon on the top right corner of the app
          ],
        ),
        body: _buildList());
  }
}
