import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/helpers/text.dart';
import 'package:ctrl_r/models/alert.dart';
import 'package:ctrl_r/models/user.dart';
import 'package:ctrl_r/providers/alert_provider.dart';
import 'package:ctrl_r/screens/widgets/alert_container_widget.dart';
import 'package:ctrl_r/services/local_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  List<Alert> alerts = [];
  @override
  Widget build(BuildContext context) {
    final alertProvider = Provider.of<AlertProvider>(context);
    List<Alert> alerts = alertProvider.alerts;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPercent(2)),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: context.heightPercent(2),
            ),
            Text(
              "Alerts",
              style: TextStyle(color: Colors.black, fontSize: context.t2),
            ),
            SizedBox(
              height: context.heightPercent(2),
            ),
            Expanded(
              child: alerts.isEmpty
                  ? const Center(child: Text("Pas d'alert"))
                  : ListView.builder(
                      itemCount: alerts.length,
                      itemBuilder: (BuildContext context, int index) {
                        Alert alert = alerts[index];

                        return AlertContainerWidget(alert: alert);
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
