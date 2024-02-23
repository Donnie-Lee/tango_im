import 'package:flutter/material.dart';
import 'package:tango/http/user_invoker.dart';

import '../../../components/contact_info.dart';
import '../../../models/contact.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => ContactsPageState();
}

class ContactsPageState extends State<ContactsPage> {
  List<Contact> _data = [];

  loadContacts() {
    List<Contact> data = [];
    UserInvoker.contacts().then((res) => {
          if (res.code == 200)
            {
              res.data.forEach((item) => {
                    data.add(Contact.fromJson(item)),
                    setState(() {
                      _data = data;
                    })
                  })
            }
        });
  }

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: _data.length,
          itemBuilder: (context, index) {
            return ChatInfoWidget(_data[index]);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
