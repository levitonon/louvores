import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/louvor.dart';
import '../services/louvor_service.dart';

class LouvorEditScreen extends StatefulWidget {
  final Louvor louvor;

  LouvorEditScreen({required this.louvor});

  @override
  _LouvorEditScreenState createState() => _LouvorEditScreenState();
}

class _LouvorEditScreenState extends State<LouvorEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _lyrics;

  @override
  void initState() {
    super.initState();
    _lyrics = widget.louvor.lyrics;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Louvor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _lyrics,
                maxLines: 10,
                decoration: InputDecoration(labelText: 'Letra'),
                onSaved: (value) {
                  _lyrics = value ?? '';
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Salvar'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.louvor.lyrics = _lyrics;
                    Provider.of<LouvorService>(context, listen: false).updateLouvor(widget.louvor);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
