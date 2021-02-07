import 'package:Hackathon/pages/ayrinti.dart';
import 'package:Hackathon/pages/kart.dart';
import 'package:Hackathon/yuklemeEkraniBekleme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'ortak/ortak.dart';

class Home extends StatefulWidget {
  Home(this.controller);

  final ScrollController controller;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _listView,
          ),
        ],
      ),
    );
  }

  Widget get _listView => StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("ilanlar")
            .limit(10)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return yuklemeBasarisizIse();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return YuklemeBeklemeEkrani(
              gelenYazi: "Lütfen Bekleyin.",
            );
          }
          return Container(
            child: ListView.separated(
              itemCount: snapshot.data.docs.length,
              controller: widget.controller,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Ayrinti(
                                      paylasanID: snapshot.data.docs[index]
                                          ["paylasanID"],
                                      idd: snapshot.data.docs[index].id,
                                    )));
                      },
                      child: Kartt(
                        snapshot: snapshot,
                        index: index,
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 10,
                );
              },
            ),
          );
        },
      );
}
