import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../data/note_model.dart';
import '../service/cloudinary_service.dart';

class EditorView extends StatefulWidget {
  final Note? existingNote;
  const EditorView({super.key, this.existingNote});

  @override
  State<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late List<Attachment> _attachments;

  bool get _isEditing => widget.existingNote != null;

  @override
  void initState() {
    super.initState();

    _titleController =
        TextEditingController(text: widget.existingNote?.title ?? '');
    _contentController =
        TextEditingController(text: widget.existingNote?.content ?? '');
    _attachments = List.from(widget.existingNote?.attachments ?? []);
  }

  // ---------------- ADD IMAGE ----------------
  Future<void> _addImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final url = await CloudinaryService.uploadFile(File(image.path));
    if (url == null) return;

    setState(() {
      _attachments.add(Attachment(url: url, type: 'image'));
    });
  }

  // ---------------- ADD PDF ----------------
  Future<void> _addPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) return;

    final file = File(result.files.single.path!);
    final url = await CloudinaryService.uploadFile(file);
    if (url == null) return;

    setState(() {
      _attachments.add(Attachment(url: url, type: 'pdf'));
    });
  }

  // ---------------- SAVE NOTE ----------------
  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (_isEditing) {
      context.read<NotesBloc>().add(
            UpdateNoteEvent(
              widget.existingNote!.id,
              title.isEmpty ? 'Untitled Note' : title,
              content,
              _attachments,
            ),
          );
    } else {
      context.read<NotesBloc>().add(
            AddNoteEvent(
              title.isEmpty ? 'Untitled Note' : title,
              content,
              _attachments,
            ),
          );
    }

    Navigator.pop(context);
  }

  // ---------------- OPEN ATTACHMENT ----------------
  void _openAttachment(Attachment attachment) async {
    final uri = Uri.parse(attachment.url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // ---------------- REMOVE ATTACHMENT ----------------
  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.white,
        title: Text(
          _isEditing ? 'Edit Note' : 'New Note',
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.black),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // -------- TITLE --------
            TextField(
              controller: _titleController,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
            ),

            // -------- CONTENT --------
            Expanded(
              child: TextField(
                controller: _contentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                expands: true,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Write your note here...',
                  border: InputBorder.none,
                ),
              ),
            ),

            // -------- ATTACHMENTS PREVIEW --------
            if (_attachments.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _attachments.length,
                  itemBuilder: (_, index) {
                    final attachment = _attachments[index];

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => _openAttachment(attachment),
                        child: Stack(
                          children: [
                            attachment.type == 'image'
                                ? Image.network(
                                    attachment.url,
                                    width: 90,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 90,
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.picture_as_pdf,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: GestureDetector(
                                onTap: () => _removeAttachment(index),
                                child: const CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.black54,
                                  child: Icon(
                                    Icons.close,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            // -------- ATTACHMENT BUTTONS --------
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _addImage,
                ),
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  onPressed: _addPdf,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
