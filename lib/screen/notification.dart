import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controller/allcontroler.dart';

class Notifications extends StatefulWidget {
  Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final allcontroller = Get.put(Allcontroller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifictaion"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(() {
          return Column(
            children: [
              if (allcontroller.notifications.isEmpty)
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/notif1.jpeg",
                        height: 400,
                      ),
                      Text(
                        "Aucune notification",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                )
              else
                ListView.builder(
                  itemCount: allcontroller.notifications.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var notif = allcontroller.notifications[index];
                    return Container(
                      child: ListTile(
                        
                        leading: CircleAvatar(
                          child: Icon(Icons.check),
                          backgroundColor: Colors.greenAccent,
                        ),
                        title: Text(notif['titre']),
                        subtitle: Text(notif['description']),
                      ),
                    );
                  },
                ),
            ],
          );
        }),
      ),
    );
  }
}
