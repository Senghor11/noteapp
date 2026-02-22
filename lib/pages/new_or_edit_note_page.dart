

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:noteapp/change_notifiers/new_note_controller.dart';
import 'package:noteapp/core/constants.dart';

import 'package:noteapp/widgets/note_icon_button.dart';
import 'package:noteapp/widgets/note_metadata.dart';
import 'package:provider/provider.dart';
import '../core/dialogs.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/dialog_card.dart';
import '../widgets/new_tag_dialog.dart';
import '../widgets/note_icon_button_outlined.dart';
import '../widgets/note_tag.dart';
import '../widgets/note_toolbar.dart';


class NewOrEditNotePage extends StatefulWidget {
  const NewOrEditNotePage({
    required this.isNewNote,
    super.key});

  final bool isNewNote;

  @override
  State<NewOrEditNotePage> createState() => _NewOrEditNotePageState();
}

class _NewOrEditNotePageState extends State<NewOrEditNotePage> {
  late final NewNoteController newNoteController;
  late final TextEditingController titleController;
  late final QuillController quillController;
  late final FocusNode focusNode;

  // In lib/pages/new_or_edit_note_page.dart
// Update the initState method

  @override
void initState() {
  super.initState();

  // Change this line to use Provider.of with listen: false
  newNoteController = Provider.of<NewNoteController>(context, listen: false);

  titleController = TextEditingController(text: newNoteController.title);

  quillController = QuillController.basic()
    ..addListener(() {
      newNoteController.content = quillController.document;
    });

  focusNode = FocusNode();

  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    if (widget.isNewNote) {
      focusNode.requestFocus();
      newNoteController.readOnly = false;
    } else {
      newNoteController.readOnly = true;
      quillController.document = newNoteController.content;
    }
  });
}

  @override
  void dispose() {
    titleController.dispose();
    quillController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) async {
        if(didPop) return;

        if(!newNoteController.canSaveNote){ //return to home is is empty
          Navigator.pop(context);
          return;
        }

        final bool? shouldSave = await showConfirmationDialog(
          context: context,
          title: 'Do you want to save the note?',
        );

         if(shouldSave == null) return;

         if(!context.mounted) return;
         
         if(shouldSave){
          newNoteController.saveNote(context);
         }

        Navigator.pop(context);
     
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: NoteIconButtonOutlined(
              onPressed: () {
                Navigator.maybePop(context);
              },
              icon: FontAwesomeIcons.chevronLeft,
            ),
          ),
          title: Text(widget.isNewNote ? 'New Note' : 'Edit Note'),
          actions: [
            Selector<NewNoteController, bool>(
              selector: (context ,newNoteController) => newNoteController.readOnly,
              builder:(context, readOnly,child) => NoteIconButtonOutlined(
                onPressed: () {
                  
                    newNoteController.readOnly = !readOnly;
                    readOnly = !readOnly;
                    
                    if(newNoteController.readOnly){
                      FocusScope.of(context).unfocus();
                      focusNode.unfocus();
                    }else{
                      focusNode.requestFocus();
                    }
                 
                },
                icon:readOnly ? FontAwesomeIcons.pen : FontAwesomeIcons.bookOpen,
              ),
            ),
             
            const SizedBox(width: 12), // space between 2 icons
            
            Selector<NewNoteController,bool>(
              selector: (_,newNoteController) => newNoteController.canSaveNote,
              builder:(_, canSaveNot,__) => NoteIconButtonOutlined(
                onPressed:  canSaveNot 
                ?
                 () {
                  newNoteController.saveNote(context);
                  Navigator.pop(context);
                } 
                : null,
                icon: FontAwesomeIcons.check,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Title TextField
              Selector<NewNoteController,bool>(
                selector: (context, controller) => controller.readOnly,
                builder: (context,readOnly,child) => TextField(
                  controller: titleController,
                  
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration:const InputDecoration(
                    hintText: 'Title here',
                    hintStyle: TextStyle(color: gray300),
                    border: InputBorder.none,
                  ),
                  canRequestFocus: !readOnly,
                 // focusNode: focusNode, // focus
                  onChanged: (newValue){
                    newNoteController.title = newValue;
                  },
                ),
              ),
              
              NoteMetadata(note: newNoteController.note,),
            
              const Padding(padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(color: gray500,thickness: 2),
              ),
              Expanded(
                child: Selector<NewNoteController,bool>(
                  selector: (_, controller) => controller.readOnly,
                  builder:(_,readOnly,__) => Column(
                    children: [
                      Expanded(
                        child: QuillEditor.basic(
                          controller: quillController,  
                          //readOnly: readOnly,
                          focusNode: focusNode,
                        ),
                      ),
                      if(!readOnly) NoteToolbar(controller: quillController),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 