// ignore_for_file: prefer_const_constructors

import 'package:event_app/models/manuntencao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/database_helper.dart';

class ManutencaoFormScreen extends StatefulWidget {
  final int truckId;
  final Manutencao? manutencao;

  const ManutencaoFormScreen(
      {super.key, required this.truckId, this.manutencao});

  @override
  State<ManutencaoFormScreen> createState() => _ManutencaoFormScreenState();
}

class _ManutencaoFormScreenState extends State<ManutencaoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descricaoController;
  late TextEditingController _custoController;
  late TextEditingController _oficinaController;
  late TextEditingController _quilometragemController;
  String _selectedTipo = 'Preventiva';
  DateTime _selectedDate = DateTime.now();
  DateTime? _proximaManutencao;

  @override
  void initState() {
    super.initState();
    _descricaoController =
        TextEditingController(text: widget.manutencao?.descricao ?? '');
    _custoController =
        TextEditingController(text: widget.manutencao?.custo.toString() ?? '');
    _oficinaController =
        TextEditingController(text: widget.manutencao?.oficina ?? '');
    _quilometragemController = TextEditingController(
        text: widget.manutencao?.quilometragem?.toString() ?? '');
    _selectedTipo = widget.manutencao?.tipo ?? 'Preventiva';
    if (widget.manutencao?.data != null) {
      _selectedDate = DateTime.parse(widget.manutencao!.data);
    }
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _custoController.dispose();
    _oficinaController.dispose();
    _quilometragemController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context,
      {bool isProxima = false}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isProxima
          ? (_proximaManutencao ?? DateTime.now().add(Duration(days: 90)))
          : _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isProxima) {
          _proximaManutencao = picked;
        } else {
          _selectedDate = picked;
        }
      });
    }
  }

  Future<void> _saveManutencao() async {
    if (_formKey.currentState!.validate()) {
      final manutencao = Manutencao(
        id: widget.manutencao?.id,
        truckId: widget.truckId,
        tipo: _selectedTipo,
        descricao: _descricaoController.text.trim(),
        custo: double.parse(_custoController.text.trim()),
        data: DateFormat('yyyy-MM-dd').format(_selectedDate),
        oficina: _oficinaController.text.trim().isEmpty
            ? null
            : _oficinaController.text.trim(),
        quilometragem: _quilometragemController.text.trim().isEmpty
            ? null
            : int.parse(_quilometragemController.text.trim()),
        proximaManutencao: _proximaManutencao != null
            ? DateFormat('yyyy-MM-dd').format(_proximaManutencao!)
            : null,
      );

      if (widget.manutencao == null) {
        await DatabaseHelper.instance.insertManutencao(manutencao);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Manutenção registada com sucesso!')),
        );
      } else {
        await DatabaseHelper.instance.updateManutencao(manutencao);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Manutenção atualizada com sucesso!')),
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.manutencao == null
            ? 'Nova Manutenção'
            : 'Editar Manutenção'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedTipo,
                decoration: InputDecoration(
                  labelText: 'Tipo de Manutenção *',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                items: ['Preventiva', 'Corretiva', 'Revisão']
                    .map((tipo) =>
                        DropdownMenuItem(value: tipo, child: Text(tipo)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedTipo = value!),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição *',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo obrigatório' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _custoController,
                decoration: InputDecoration(
                  labelText: 'Custo (MT) *',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Campo obrigatório';
                  if (double.tryParse(value!) == null) return 'Valor inválido';
                  return null;
                },
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Data da Manutenção *',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _oficinaController,
                decoration: InputDecoration(
                  labelText: 'Oficina',
                  prefixIcon: Icon(Icons.garage),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _quilometragemController,
                decoration: InputDecoration(
                  labelText: 'Quilometragem',
                  prefixIcon: Icon(Icons.speed),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context, isProxima: true),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Próxima Manutenção',
                    prefixIcon: Icon(Icons.event),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(_proximaManutencao != null
                      ? DateFormat('dd/MM/yyyy').format(_proximaManutencao!)
                      : 'Selecionar data'),
                ),
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveManutencao,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    widget.manutencao == null
                        ? 'Salvar Manutenção'
                        : 'Atualizar Manutenção',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
