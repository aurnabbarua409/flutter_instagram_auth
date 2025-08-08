import 'package:flutter/material.dart';
import 'package:insta_login/insta_login.dart';
import 'package:insta_login/insta_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String token = '', userid = '', username = '', accountType = '';
  int mediaCount = -1;
  List<dynamic> mediaList = [];
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Widget InfoWidget({required String title, required String subtitle}) {
    return Text("$title: $subtitle");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (token != '' || userid != '' || username != '')
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          '------Instagram Connected------',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),

                      InfoWidget(title: 'Access Token', subtitle: token),
                      InfoWidget(title: 'Userid', subtitle: userid),
                      InfoWidget(title: 'Username', subtitle: username),
                      const SizedBox(height: 10),
                      if (accountType != '' || mediaCount != -1)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                '------Basic Profile Details------',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),

                            InfoWidget(
                              title: 'Media Count',
                              subtitle: mediaCount.toString(),
                            ),
                            InfoWidget(
                              title: 'Account Type',
                              subtitle: accountType,
                            ),
                          ],
                        )
                      else
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              await Instaservices()
                                  .getContent(
                                    accesstoken: token,
                                    userid: userid,
                                  )
                                  .then((value) {
                                    if (value != null) {
                                      accountType = value['account_type'];
                                      mediaCount = value['media_count'];
                                    }
                                    setState(() {});
                                  });
                            },
                            child: const Text('Get Basic Profile Details'),
                          ),
                        ),
                      const SizedBox(height: 10),
                      if (mediaList.isNotEmpty)
                        Expanded(
                          child: Column(
                            children: [
                              const Center(
                                child: Text(
                                  '------Media List------',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),

                              Expanded(
                                child: GridView.count(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  children: List.generate(mediaList.length, (
                                    index,
                                  ) {
                                    var media = mediaList[index];
                                    return InkWell(
                                      onTap: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => DetailScreen(
                                        //       url: media['media_url'],
                                        //       media: media,
                                        //     ),
                                        //   ),
                                        // );
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              media['media_url'],
                                            ),
                                          ),
                                        ),
                                        child: media['media_type'] == 'VIDEO'
                                            ? const Icon(Icons.videocam)
                                            : null,
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              await Instaservices()
                                  .fetchUserMedia(
                                    userId: userid,
                                    accessToken: token,
                                  )
                                  .then((value) {
                                    mediaList = value;
                                    setState(() {});
                                  });
                            },
                            child: const Text('Get Media'),
                          ),
                        ),
                    ],
                  ),
                )
              else
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return InstaView(
                              instaAppId: '1685541038816554',
                              instaAppSecret:
                                  'd1adac39dda01b1ea5c5aa63124987c9',
                              redirectUrl: 'https://ayesha-iftikhar.web.app/',
                              onComplete: (_token, _userid, _username) {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  timeStamp,
                                ) {
                                  setState(() {
                                    token = _token;
                                    userid = _userid;
                                    username = _username;
                                  });
                                });
                              },
                            );
                          },
                        ),
                      );
                    },
                    child: const Text('Connect to Instagram'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
