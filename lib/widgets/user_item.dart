import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  UserItem(this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white24,

      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
