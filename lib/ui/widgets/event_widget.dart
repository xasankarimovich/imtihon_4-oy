import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imtihon_4oyuchun/cubit/user/user_cubit.dart';
import 'package:imtihon_4oyuchun/utils/extension/extension.dart';
import 'package:imtihon_4oyuchun/utils/style/app_text_style.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../data/models/event_model/event.dart';
import '../../data/models/user/user_model.dart';
import '../screens/home_screen.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  late YandexMapController controller;
  final TextEditingController _nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _name = '';
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  String _location = '';
  String _description = '';
  String _bannerUrl = '';
  File? _selectedImage;
  String imagePath = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final fileName = 'events/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _addEvent() async {
    if (_nameController.text.isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select an image')),
      );
      return;
    }

     final imageUrl = await _uploadImage(_selectedImage!);
    setState(() {
    imagePath = imageUrl ?? '';
    });

    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image')),
      );
      return;
    }

    final event = {
      'name': _nameController.text,
      'date': _date.toLocal() ,
      'time': _time.format(context),
      'location': _location,
      'description': _description,
      // 'banner_url': _bannerUrl,
      'image_url': imageUrl,
      'created_at': FieldValue.serverTimestamp(),
    };
    try {
      await FirebaseFirestore.instance.collection('events').add(event);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event added successfully')),
      );
      _nameController.clear();
      setState(() {
        _selectedImage = null;
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add event: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yangi tadbir yaratish')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Tadbir nomi'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tadbir nomini kiriting';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Kuni',
                        suffixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kunini kiriting';
                        }
                        return null;
                      },
                      controller: TextEditingController(
                        text: "${_date.toLocal()}".split(' ')[0],
                      ),
                    ),
                  ),
                ),
                20.boxH(),
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Vaqti',
                        suffixIcon: Icon(Icons.access_time_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vaqtini kiriting';
                        }
                        return null;
                      },
                      controller: TextEditingController(
                        text: _time.format(context),
                      ),
                    ),
                  ),
                ),
                20.boxH(),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Joylashuv'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Joylashuvni kiriting';
                    }
                    return null;
                  },
                  onSaved: (value) => _location = value!,
                ),
                20.boxH(),

                // TextFormField(
                //   decoration: const InputDecoration(labelText: 'Banner URL'),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Banner URL ni kiriting';
                //     }
                //     return null;
                //   },
                //   onSaved: (value) => _bannerUrl = value!,
                // ),
                // 20.boxH(),

                TextFormField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Tadbir haqida ma\'lumot',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tadbir haqida ma\'lumot kiriting';
                    }
                    return null;
                  },
                  onSaved: (value) => _description = value!,
                ),
                20.boxH(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickImage(ImageSource.camera),
                        child: Container(
                          height: 150.h,
                          width: 190.w,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,

                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.camera_alt_outlined, size: 70),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickImage(ImageSource.gallery),
                        child: Container(
                          height: 150.h,
                          width: 190.w,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.image, size: 70),
                        ),
                      ),
                    ),
                  ],
                ),
                20.boxH(),

                Text('Manzilni belgilash', style: AppTextStyle.semiBold),
                20.boxH(),

                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: YandexMap(),
                ),
                20.boxH(),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _addEvent();
                      _selectDate;
                      _selectTime;
                      _pickImage;
                      _uploadImage;
                    //   'name': _nameController.text,
                    // 'date': _date.toLocal() ,
                    // 'time': _time.format(context),
                    // 'location': _location,
                    // 'description': _description,
                    // // 'banner_url': _bannerUrl,
                    // 'image_url': imageUrl,
                    // 'created_at': FieldValue.serverTimestamp(),
                      EventModel newEvent = EventModel.initialValue();
                      newEvent = newEvent.copyWith(
                        name: _nameController.text,
                        date: _date.toLocal(),
                        location: _location,
                        description: _description,
                        imageUrl: imagePath,
                      );
                      UserModel userModel = context.read<UserCubit>().state.userData;
                      List<EventModel>  events = userModel.myEvent;
                      events.add(newEvent);
                      userModel = userModel.copyWith(
                        myEvent: events
                      );
                      context.read<UserCubit>().updateUserEvent(userModel: userModel);
                    }
                  },
                  child: Text('Yaratish'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
