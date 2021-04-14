import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Wallpaper extends StatefulWidget {
  @override
  _WallpaperState createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  List images = [];
  int page = 1;
  @override
  void initState() {
    super.initState();
    fetchapi();
  }

  fetchapi() async {
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization':
              '563492ad6f91700001000001fead046b5c28412cb20719b61dd8fbbf'
        }).then((value) {
      Map result = jsonDecode(value.body);
      print(result['photos'][0]['src']['original']);
      setState(() {
        images = result['photos'];
      });
    });
  }

  loadmore() async {
    setState(() {
      page += 1;
    });
    String url = 'https://api.pexels.com/v1/curated?page=' +
        page.toString() +
        '&per_page=80';
    await http.get(Uri.parse(url), headers: {
      'Authorization':
          '563492ad6f91700001000001fead046b5c28412cb20719b61dd8fbbf'
    }).then((value) {
      Map result = jsonDecode(value.body);

      setState(() {
        images.addAll(result['photos']);
      });
      print((images.length));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
                itemCount: images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    childAspectRatio: 2 / 3,
                    mainAxisSpacing: 2),
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.white,
                    child: Image.network(
                      images[index]['src']['tiny'],
                      fit: BoxFit.cover,
                    ),
                  );
                }),
          ),
          Container(
              height: 50,
              child: TextButton(
                child: Text('Load More'),
                onPressed: () {
                  loadmore();
                },
              ))
        ],
      ),
    );
  }
}
