import 'package:bug_report/bug_report.dart';
import 'package:flutter/material.dart';

class ReportIssuePage extends StatelessWidget {
  const ReportIssuePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Сообщить о проблеме",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: IssueForm(
          owner: "Azamatig", // e.g. Puepis
          repositoryName: "Konkurs", // e.g. bug_report
          authToken:
              "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", // keep it safe!
        ),
      ),
    );
  }
}
