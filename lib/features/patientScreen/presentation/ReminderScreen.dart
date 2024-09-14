import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'ReminderController.dart'; // Make sure the path is correct

class ReminderScreen extends StatefulWidget {
  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final ReminderController reminderController = Get.put(ReminderController());

  final TextEditingController timeController = TextEditingController();

  String selectedType = 'Medication';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Set Reminder',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reminder Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: DropdownButton<String>(
                value: selectedType,
                isExpanded: true,
                onChanged: (String? newValue) {
                  selectedType = newValue!;
                  setState(() {

                  });

                },
                items: <String>['Medication', 'Meditation']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                underline: SizedBox.shrink(),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Time',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (pickedTime != null) {
                  DateTime now = DateTime.now();
                  DateTime fullDate = DateTime(now.year, now.month, now.day,
                      pickedTime.hour, pickedTime.minute);
                  String formattedTime =
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(fullDate);
                  timeController.text = formattedTime;
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeController.text.isEmpty
                          ? 'Choose a time for reminder'
                          : timeController.text,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.access_time, color: Colors.blueAccent),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (timeController.text.isNotEmpty) {
                    reminderController.addReminder(selectedType, timeController.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Set Reminder',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Your Reminders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: reminderController.reminders.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.alarm, color: Colors.teal),
                      title: Text(
                        reminderController.reminders[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          reminderController.reminders.removeAt(index);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (timeController.text.isNotEmpty) {
            reminderController.addReminder(selectedType, timeController.text);
          }
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
