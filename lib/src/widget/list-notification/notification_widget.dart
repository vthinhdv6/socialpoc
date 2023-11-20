import 'package:flutter/material.dart';
import 'package:socialpoc/data/model/notification_model.dart';

class NotificationWidget extends StatelessWidget {
   const NotificationWidget({super.key, required this.notification});
  final NotificationModel notification;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            child: SizedBox(
              child: CircleAvatar(
                backgroundImage: NetworkImage(notification.imageUrl),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    overflow: TextOverflow.ellipsis,
                    notification.subtitle,
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 15),
                  ),
                ],
              )),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              alignment: Alignment.centerRight,
              width: MediaQuery.of(context).size.width * 0.2,
              child: Icon(
                notification!.icon,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
