import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/my_transaction.dart';
import '../../providers/transaction_provider.dart';
import '../../screens/transaction_list_screen.dart';

class albumFormScreen extends StatefulWidget {
  const albumFormScreen({super.key});

  @override
  State<albumFormScreen> createState() => _albumFormScreen();
}

class _albumFormScreen extends State<albumFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _trackCountController = TextEditingController();
  final TextEditingController _releaseDateController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    _trackCountController.dispose();
    _releaseDateController.dispose();
    super.dispose();
  }

  void _insert() async {
    Map<String, dynamic> row = {
      'title': _titleController.text,
      'artist': _artistController.text,
      'trackCount': int.tryParse(_trackCountController.text) ?? 0,
    };
  }

  DateTime _selectedDate = DateTime.now();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate, // วันที่ที่เลือกไว้ตอนเปิดปฏิทิน
      firstDate: DateTime(2000), // วันแรกที่เลือกได้ DateTime(ปี, เดือน, วัน)
      lastDate: DateTime(2100), // วันสุดท้ายที่เลือกได้
    );
    if (picked != null) {
      // ผู้ใช้กด Cancel จะได้ null
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Album')),
      body: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(label: Text('ชื่ออัลบั้ม')),
            validator: (value) => value == null || value.isEmpty ? 'กรุณากรอกชื่ออัลบั้ม' : null,
          ),
          TextFormField(
            controller: _artistController,
            decoration: const InputDecoration(label: Text('ศิลปิน')),
            validator: (value) => value == null || value.isEmpty ? 'กรุณากรอกชื่อศิลปิน' : null,
          ),
          TextFormField(
            controller: _trackCountController,
            decoration: const InputDecoration(label: Text('จำนวนแทร็ก')),
            keyboardType: TextInputType.number,
            validator: (value) => value == null || value.isEmpty ? 'กรุณากรอกจำนวนแทร็ก' : null,
          ),
        ],
      ),
    );
  }
}
