import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travels/helpers/firebase_helper.dart';
import 'package:travels/model/travel.dart';
import 'package:travels/ui/map.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _db = FirebaseFirestore.instance;
  final _controller = StreamController<QuerySnapshot>.broadcast();

  _openMapLocation(String id) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => TravelMap(travelId: id)));
  }

  _removeTravel(String id) {
    _db.collection(FirebaseHelpers.collections.travels).doc(id).delete();
  }

  _newTravel() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => TravelMap()));
  }

  _createTravelListener() async {
    final stream = _db
        .collection(FirebaseHelpers.collections.travels)
        .snapshots();
    stream.listen((data) {
      _controller.add(data);
    });
  }

  @override
  void initState() {
    super.initState();

    _createTravelListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
        title: Text("Minhas Viagens"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _controller.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.active:
              case ConnectionState.done:
                var travelList = snapshot.data!.docs;

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: travelList.length,
                        itemBuilder: (context, index) {
                          var travel = Travel.fromDocumentSnapshot(travelList[index]);

                          return GestureDetector(
                            onTap: () => _openMapLocation(travel.id),
                            child: Card(
                              child: ListTile(
                                title: Text(travel.title),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () => _removeTravel(travel.id),
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
            }
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newTravel,
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
