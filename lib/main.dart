import 'package:flutter/material.dart';
import 'package:random_words/random_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Word Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RandomSentences()
    );
  }
}


class RandomSentences extends StatefulWidget {
  @override
  _RandomSentencesState createState() => _RandomSentencesState();
}

class _RandomSentencesState extends State<RandomSentences> {
  final _sentences = <String>[];
  final _funnies = Set<String>();
  final _biggerFont = TextStyle(
    fontSize: 15
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Game'),
        actions: <Widget>[
          IconButton(
            onPressed: (){
               _pushFunnies();
            },
            icon: Icon(
              Icons.list
            ),
          )
        ],
      ),
      body: Center(
          child: _buildSentences()
      ),
    );
  }

  String _getSentence(){
    final noun = WordNoun.random();
    final adjective = WordAdjective.random();
    return "The ${noun.asLowerCase} did ${adjective.asLowerCase} work";
  }

  Widget _buildSentences(){
    return ListView.builder(
      padding: const EdgeInsets.all(15),
        itemBuilder: (context, i){
          if(i.isOdd) return Divider();
          final index = i~/2;
          if(index >= _sentences.length){
            for(int x = 0; x< 10; x++){
              _sentences.add(_getSentence());
            }
          }
          return _buildRow(_sentences[index]);
        }
    );
  }

  Widget _buildRow(String sentence) {
    final alreadyThere = _funnies.contains(sentence);
     return ListTile(
       title: Text(
           sentence,
       style: _biggerFont,
       ),
       trailing: Icon(
         alreadyThere ? Icons.thumb_up : Icons.thumb_down,
         color: alreadyThere ? Colors.green : null,
       ),
       onTap: (){
         setState(() {
           alreadyThere ? _funnies.remove(sentence) : _funnies.add(sentence);
         });
       },
     );
  }

  void _pushFunnies() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        final tiles = _funnies.map((sentence){
          return ListTile(
            title: Text(
              sentence,
              style: _biggerFont,
            ),
          );
         }
        );
        final divided = ListTile.divideTiles(
            tiles: tiles,
            context: context
        ).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Saved funny sentences'),
          ),
          body: ListView(
            children: divided,
          ),
        );
      }
    ));
  }
}
