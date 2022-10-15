import 'package:drag_agd_drop_game/Global/globals.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Text text = const Text("");

  @override
  void initState() {
    super.initState();
    box();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        leading: const Icon(
          Icons.menu,
          color: Colors.black,
        ),
        title: Text("Drag & Drop"),
        actions: [
          Center(
            child: Text(
              "${Global.score} / 100    ",
              style: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: (Global.first.isEmpty)
          ? Center(
              child: box(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      ...Global.first
                          .map(
                            (e) => ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                margin: EdgeInsets.all(15),
                                height: 150,
                                width: 150,
                                child: Draggable(
                                  data: e['data'],
                                  child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image.asset(
                                      e['image'],
                                      scale: 5,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  childWhenDragging: Container(),
                                  feedback: SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: Image.asset(
                                      e['image'],
                                      scale: 5,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList()
                        ..shuffle(),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      ...Global.first
                          .map(
                            (e) => SizedBox(
                              height: 100,
                              width: 150,
                              child: DragTarget(
                                builder: (context, accepted, rejected) {
                                  Global.isDrag = e['isDrag'];
                                  return Container(
                                      margin: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white)),
                                      alignment: Alignment.center,
                                      height: 100,
                                      width: 100,
                                      child: Text(
                                        "${e["text"]}",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ));
                                },
                                onWillAccept: (data) {
                                  return data == e['data'];
                                },
                                onAccept: (data) {
                                  setState(
                                    () {
                                      if (e['isDrag'] == false) {
                                        Global.first.remove(e);
                                      }

                                      if (data == e['data']) {
                                        Global.score = Global.score + 10;
                                      }
                                    },
                                  );
                                },
                                onLeave: (data) {
                                  setState(() {
                                    if (Global.score > 0) {
                                      Global.score = Global.score - 5;
                                    }
                                  });
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  box() {
    return Container(
      // color: Colors.pinkAccent,
      alignment: Alignment.center,
      height: 330,
      width: 500,
      child: Dialog(
        child: Column(
          children: [
            Spacer(),
            const Text(
              "Game Over",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  (Global.score > 10) ? "⭐" : "",
                  style: TextStyle(fontSize: 40),
                ),
                Text(
                  (Global.score > 50) ? "⭐" : "",
                  style: TextStyle(fontSize: 40),
                ),
                Text(
                  (Global.score >= 85) ? "⭐" : "",
                  style: TextStyle(fontSize: 40),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Total Score = ${Global.score}",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Spacer(),
            FloatingActionButton.extended(
              label: Text("Play again!"),
              icon: Icon(
                Icons.restart_alt,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () {
                setState(() {
                  Global.first = Global.copy;
                  Global.first.shuffle();
                  Global.score = 0;
                });
              },
              elevation: 0,
              backgroundColor: Colors.pinkAccent,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
