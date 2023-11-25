import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NotificationModel extends Equatable{
  final String title;
  final String imageUrl;
  final String subtitle;
  final IconData icon;

  const NotificationModel(this.title, this.imageUrl, this.subtitle, this.icon);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  List<NotificationModel> generateNotifications() {
    return List.generate(5, (index) {
      return NotificationModel(
        'Notification Title ${index + 1}',
        'https://www.bing.com/images/search?view=detailV2&ccid=LF9b78qG&id=FC2FDF81DEBC39F37E9664D1D517F7FCF2C54FCD&thid=OIP.LF9b78qG9SNs4aGL3Wa7AwAAAA&mediaurl=https%3A%2F%2Flogodix.com%2Flogo%2F2015057.jpg&cdnurl=https%3A%2F%2Fth.bing.com%2Fth%2Fid%2FR.2c5f5befca86f5236ce1a18bdd66bb03%3Frik%3DzU%252fF8vz3F9XRZA%26pid%3DImgRaw%26r%3D0&exph=384&expw=384&q=shoppe&form=IRPRST&ck=93FB7076C305C442B7D24D353FBA36EA&selectedindex=3&ajaxhist=0&ajaxserp=0&vt=2&sim=11&iss=VSI',
        'Notification subtitle ${index + 1}',
        Icons.notifications,
      );
    });
  }

}