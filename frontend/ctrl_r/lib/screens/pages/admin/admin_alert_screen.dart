import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/helpers/text.dart';
import 'package:ctrl_r/models/alert.dart';
import 'package:ctrl_r/models/user.dart';
import 'package:ctrl_r/screens/pages/search_controle_screen.dart';
import 'package:ctrl_r/screens/widgets/alert_container_widget.dart';
import 'package:ctrl_r/services/alert_service.dart';
import 'package:ctrl_r/services/local_service.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class AdminAlertScreen extends StatefulWidget {
  const AdminAlertScreen({super.key});

  @override
  State<AdminAlertScreen> createState() => _AdminAlertScreenState();
}

class _AdminAlertScreenState extends State<AdminAlertScreen> {
  List<Alert> alerts = [];
  User? user = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAlerts();
  }

  loadAlerts() async {
    User? userData = await LocalService.getUserData();
    List<Alert> data = await AlertService.getAlerts();
    setState(() {
      alerts = data;
      user = userData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPercent(2)),
      child: Column(
        children: [
          SizedBox(
            height: context.heightPercent(2),
          ),
          Text("Alerts",
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.black,
                  fontSize: context.t2,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: context.heightPercent(2),
          ),
          Expanded(
            child: alerts.isEmpty
                ? const Center(child: Text("no data"))
                : ListView.builder(
                    itemCount: alerts.length,
                    itemBuilder: (BuildContext context, int index) {
                      Alert alert = alerts[index];
                      return AlertContainerWidget(alert: alert,isDelected: alert.userId == user!.id,);
                    },
                  ),
          )
        ],
      ),
    );
  }
}
