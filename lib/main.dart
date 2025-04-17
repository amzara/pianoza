import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 9,
              child: Container(color: Colors.pink,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Center(child: 
                Image.network("https://musescore.com/static/musescore/scoredata/g/6a9fe37389091b3987c55303fd7fe7d6f4c799d9/score_0.png?no-cache=1715687383",
                height: 1000, 
                width: 1000,
                fit: BoxFit.contain,
                )  
                )],
              ),
              ),
            ),
            Expanded(
              flex:1,
            child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                
                Center(
                  child: ElevatedButton(onPressed: () => print('Clicked'), child: Text("Click Me")),
                )
              ],)
          )
          ],
        ),
        
      ),
    );
  }
}
