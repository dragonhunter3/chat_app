import 'package:chat_app/src/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? name, phone;

  @override
  void initState() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    provider.initializeFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Form(
      key: _formKey,
      child: Scaffold(
        body: SizedBox(
          height: height,
          width: width,
          child: ListView(
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () => provider.updateProfilePicture(),
                    child: CircleAvatar(
                      minRadius: height * 0.05,
                      maxRadius: height * 0.07,
                      backgroundImage: provider.imageUrl != null
                          ? NetworkImage(provider.imageUrl!)
                          : null,
                      child: provider.imageUrl == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: provider.nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      onSaved: (value) => name = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: provider.phoneController,
                      decoration: const InputDecoration(labelText: 'Phone'),
                      onSaved: (value) => phone = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        provider.updateProfileDetails(name!, phone!);
                      }
                    },
                    child: const Text('Update Profile'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
