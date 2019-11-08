import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

///实现一个stateful widget至少需要两个类
///  1、一个StateWidget类
/// 2、一个State类，StatefulWidget类本身是不变的，但是State类在widget生命周期中始终存在

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final wordPair = new WordPair.random();

    return new MaterialApp(
      title: 'Welcome to',
      home: new Scaffold(
        // appBar: new AppBar(
        // title: new Text('Welcome to Flutter'),
        // ),
        body: new Center(
          // child: new Text('Hello World'),
          // child: new Text(wordPair.asPascalCase)，
          child: new RandomWords(),
        ),
      ),
      theme: new ThemeData(primaryColor: Colors.white), //更换主题颜色
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RandomWordsState();
  }
}

///该方法通过将生成单词对的代码从MyApp移动到RandomWordsState来生成单词对
class RandomWordsState extends State<RandomWords> {
  ///在Dart语言中使用下划线前缀标识符，会强制其变成私有的
  final _suggestions = <WordPair>[];

  ///添加一个set集合，存储用户喜欢的单词对，这里set比list适合（set不允许有重复的值）
  final _saved = new Set<WordPair>();

  //用来增大字体大小的
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    // final wordPair = new WordPair.random();
    // return new Text(wordPair.asPascalCase);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          //路由图标
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(), //使用单词对 listView
    );
  }

  ///用来显示 单词对的listView
  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          //在每一列之前，添加一个1像素高的分割线widget
          if (i.isOdd) return new Divider();

          final index = i ~/ 2;

          //如果建议列表中是最后一个单词对
          if (index >= _suggestions.length) {
            //接着再生成10个单词对，然后添加到建议列表
            _suggestions.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_suggestions[index]);
        });
  }

  //每一行单词对
  Widget _buildRow(WordPair pair) {
    //检查单词对是否添加到收藏夹中
    final alreadySaved = _saved.contains(pair);

    return new ListTile(
      title: new Text(
        pair.asPascalCase, //随机的词
        style: _biggerFont, //字体大小
      ),
      trailing: new Icon(
          //添加爱心图标
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null),
      onTap: () {
        //让爱心图标变得可以点击
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }
}
