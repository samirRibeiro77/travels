import 'package:flutter/material.dart';
import 'package:travels/ui/map.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _travelList = ["Nome 1", "Nome 2"];

  _openMapLocation() {}

  _removeTravel() {}

  _newTravel() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => TravelMap()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Minhas Viagens"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _travelList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: _openMapLocation,
                  child: Card(
                    child: ListTile(
                      title: Text(_travelList[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: _removeTravel,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newTravel,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
