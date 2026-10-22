// lib/screens/transaction_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../models/my_transaction.dart';

class AlbumListScreen extends StatelessWidget {
  const AlbumListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('รายรับ-รายจ่าย')),
      body: Consumer<AlbumProvider>(
        builder: (context, albumProvider, child) =>
            albumProvider.albums.isEmpty
                ? const Center(child: Text('ไม่มีรายการ'))
                : ListView.builder(
                    itemCount: albumProvider.albums.length,
                    itemBuilder: (ctx, i) {
                      final album = albumProvider.albums[i];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(album.isOwned ? 'มี' : 'ไม่มี'),
                        ),
                        title: Text(album.title),
                        subtitle: Text(DateFormat.yMMMd().format(album.releaseDate)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${album.trackCount.toString()} แทร็ก',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.grey),
                              onPressed: () {
                                // เรียกเมธอด delete
                                context.read<AlbumProvider>().deleteAlbum(album.id!);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
      // ปุ่มเพิ่มรายการตัวอย่างชั่วคราว จนกว่าจะสร้างหน้าฟอร์มในการบ้าน
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<AlbumProvider>().addAlbum(
              'อัลบั้มใหม่',
              'ศิลปินใหม่',
              10,
              DateTime.now(),
              false,
            ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
