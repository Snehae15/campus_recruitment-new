import 'package:campus_recruitment/screens/company/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompanySettingsPage extends StatefulWidget {
  const CompanySettingsPage({super.key});

  @override
  State<CompanySettingsPage> createState() => _CompanySettingsPageState();
}

class _CompanySettingsPageState extends State<CompanySettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String companyname = ''; // Variable to hold the company name

  bool isNotificationEnabled =
      false; // Variable to hold notification toggle state

  @override
  void initState() {
    super.initState();
    _loadCompanyInfo(); // Fetch company name when the page is initialized
  }

  Future<void> _loadCompanyInfo() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot companySnapshot =
            await _firestore.collection('companies').doc(user.uid).get();

        if (companySnapshot.exists) {
          setState(() {
            companyname = companySnapshot['companyname'];
          });
        }
      }
    } catch (e) {
      print("Error loading company information: $e");
    }
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      // Navigate to the company login screen
      Navigator.pushReplacementNamed(context, '/companylogin');
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  void _toggleNotification(bool value) {
    // Implement your logic to handle notification toggle
    setState(() {
      isNotificationEnabled = value;
    });
  }

  void _navigateToFeedbackPage() {
    // Navigate to the FeedbackPage
    // You need to define the route for FeedbackPage in your app
    Navigator.pushNamed(context, '/feedbackpage');
  }

  void _navigateToReportBugPage() {
    // Navigate to the CompanyBugReportPage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CompanyBugReport()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 30, right: 290),
            child: Text(
              'Settings',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 300, top: 50),
            child: Text(
              'Account',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundImage: AssetImage('assets/person.png'),
                ),
                title: Text(companyname),
                trailing: const Icon(Icons.arrow_forward),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 300, top: 40),
            child: Text(
              'GENERAL',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.notifications_none_outlined,
              color: Colors.purpleAccent,
            ),
            title: const Text('Notification'),
            trailing: Switch(
              value: isNotificationEnabled,
              onChanged: _toggleNotification,
              activeColor: Colors.purpleAccent,
            ),
          ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.poll_rounded,
          //     color: Colors.purpleAccent,
          //   ),
          //   title: const Text('Feedback'),
          //   trailing: const Icon(
          //     Icons.arrow_forward,
          //     color: Colors.grey,
          //     size: 30,
          //   ),
          //   onTap: _navigateToFeedbackPage,
          // ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.note_add_outlined,
          //     color: Colors.purpleAccent,
          //   ),
          //   title: const Text('Report Bugs'),
          //   trailing: const Icon(
          //     Icons.arrow_forward,
          //     color: Colors.grey,
          //     size: 30,
          //   ),
          //   onTap: _navigateToReportBugPage,
          // ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.purpleAccent,
            ),
            title: const Text('Logout'),
            trailing: const Icon(
              Icons.arrow_forward,
              color: Colors.grey,
              size: 30,
            ),
            onTap: _logout, // Call the logout function when tapped
          ),
        ],
      ),
    );
  }
}
