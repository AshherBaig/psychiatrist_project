import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Patientreportscreen extends StatelessWidget {
  String patientId;
  String patientName;
  Patientreportscreen({super.key, required this.patientId, required this.patientName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$patientName's Report"),),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection("patientSurveyReport").doc(patientId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("No data found"));
            } else {
              final data = snapshot.data!;
              final answers = data['answers'] as List<dynamic>;
        
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DataTable(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300)
                    ),
                    columns: const [
                      DataColumn(label: Text('Question')),
                      DataColumn(label: Text('Selected Option')),
                    ],
                    rows: answers.map<DataRow>((answer) {
                      final question = answer['question'] as String;
                      final selectedOption = answer['selected_option'] as String;
        
                      return DataRow(
                        cells: [
                          DataCell(Text(question)),
                          DataCell(Text(selectedOption), placeholder: true),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
