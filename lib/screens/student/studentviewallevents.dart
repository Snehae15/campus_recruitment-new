import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentViewallEvents extends StatefulWidget {
  const StudentViewallEvents({super.key});

  @override
  State<StudentViewallEvents> createState() => _StudentViewallEventsState();
}

class _StudentViewallEventsState extends State<StudentViewallEvents> {
  final StreamController<List<Map<String, dynamic>>> _eventsStreamController =
      StreamController<List<Map<String, dynamic>>>();

  @override
  void initState() {
    super.initState();
    _initializeEventsStream();
  }

  void _initializeEventsStream() {
    FirebaseFirestore.instance.collection('events').snapshots().listen(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        List<Map<String, dynamic>> events = snapshot.docs
            .map(
                (QueryDocumentSnapshot<Map<String, dynamic>> doc) => doc.data())
            .toList();

        _eventsStreamController.add(events);
      },
      onError: (error) {
        print('Error retrieving events: $error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: Row(
          children: [
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _eventsStreamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<Map<String, dynamic>> events = snapshot.data!;

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      Map<String, dynamic> event = events[index];

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ListTile(
                            leading: Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/events.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Event Name: ${event['eventName']}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Event Date: ${event['eventDate']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Event Location: ${event['eventLocation']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: events.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
