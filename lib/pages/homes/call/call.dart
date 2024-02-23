import 'package:flutter/material.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fitHeight,
            image: NetworkImage(
            "https://pic1.zhimg.com/80/v2-b4b6a9272a830551d7ba23b46867c1b0_720w.webp"
          )
        ),
        gradient: LinearGradient(
          colors: [
            Color(0xff6485e6),
            Color(0xff8679e7),
            Color(0xffb26ae8),
          ],
          stops: [
            0.1,
            0.4,
            0.9,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 116,
                  height: 116,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(58)),
                      border: Border.all(color: Colors.white, width: 2),
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsafe-img.xhscdn.com%2Fbw1%2F9e8bd863-bf16-4647-abf0-88490ce78ced%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fsafe-img.xhscdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1709874737&t=9054b212fb7ccc86047befceaa7a5a64")))),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "daerwen",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              )
            ],
          )),
          Positioned(
            left: 0,
              right: 0,
              bottom: 80,
              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            'images/reject.png',
                            height: 50,
                            width: 50,
                          )),
                      Text(
                        "挂断",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            'images/answer.png',
                            height: 50,
                            width: 50,
                          )),
                      Text(
                        "接听",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  )
                ],
              ))
        ],
      ),
    ));
  }
}
