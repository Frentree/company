import 'package:flutter/material.dart';
import 'package:kopo/kopo.dart';

class Test extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    double test4 = MediaQuery.of(context).size.width * MediaQuery.of(context).devicePixelRatio;
    double test2 = (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top)*MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: (MediaQuery.of(context).padding.top),
            color: Colors.yellow,
            child: Center(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  test4.toString(),
                ),
              ),
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.1,
            color: Colors.red,
            child: Center(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  test4.toString(),
                ),
              ),
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.1,
            color: Colors.red,
            child: Center(
              child: RaisedButton(
                onPressed: () async {
                  KopoModel model = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Kopo()),
                  );
                },
              )
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.1,
            color: Colors.red,
            child: Center(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  test4.toString(),
                ),
              ),
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.1,
            color: Colors.red,
            child: Center(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  test4.toString(),
                ),
              ),
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.1,
            color: Colors.red,
            child: Center(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  test4.toString(),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
                color: Colors.red,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      test4.toString(),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
                color: Colors.red,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      test4.toString(),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
                color: Colors.red,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      test4.toString(),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
                color: Colors.red,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      test4.toString(),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
                color: Colors.red,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      test4.toString(),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

}