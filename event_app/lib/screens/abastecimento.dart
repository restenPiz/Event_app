// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/database_helper.dart';
import '../models/abastecimento.dart';

class AbastecimentoFormScreen extends StatefulWidget {
  final int truckId;
  final Abastecimento? abastecimento;

  const AbastecimentoFormScreen(
      {super.key, required this.truckId, this.abastecimento});

  @override
  State<AbastecimentoFormScreen> createState() =>
      _AbastecimentoFormScreenState();
}

class _AbastecimentoFormScreenState extends State<AbastecimentoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _litrosController;
  late TextEditingController _precoLitroController;
  late TextEditingController _custoTotalController;
  late TextEditingController _postoController;
  late TextEditingController _quilometragemController;
  String _selectedTipoCombustivel = 'Diesel';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _litrosController = TextEditingController(
        text: widget.abastecimento?.litros.toString() ?? '');
    _precoLitroController = TextEditingController(
        text: widget.abastecimento?.precoLitro.toString() ?? '');
    _custoTotalController = TextEditingController(
        text: widget.abastecimento?.custoTotal.toString() ?? '');
    _postoController =
        TextEditingController(text: widget.abastecimento?.posto ?? '');
    _quilometragemController = TextEditingController(
        text: widget.abastecimento?.quilometragem?.toString() ?? '');
    _selectedTipoCombustivel =
        widget.abastecimento?.tipoCombustivel ?? 'Diesel';
    if (widget.abastecimento?.data != null) {
      _selectedDate = DateTime.parse(widget.abastecimento!.data);
    }

    // Auto-calcular custo total
    _litrosController.addListener(_calculateTotal);
    _precoLitroController.addListener(_calculateTotal);
  }

  @override
  void dispose() {
    _litrosController.dispose();
    _precoLitroController.dispose();
    _custoTotalController.dispose();
    _postoController.dispose();
    _quilometragemController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    final litros = double.tryParse(_litrosController.text);
    final precoLitro = double.tryParse(_precoLitroController.text);

    if (litros != null && precoLitro != null) {
      final total = litros * precoLitro;
      _custoTotalController.text = total.toStringAsFixed(2);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveAbastecimento() async {
    if (_formKey.currentState!.validate()) {
      final abastecimento = Abastecimento(
        id: widget.abastecimento?.id,
        truckId: widget.truckId,
        litros: double.parse(_litrosController.text.trim()),
        precoLitro: double.parse(_precoLitroController.text.trim()),
        custoTotal: double.parse(_custoTotalController.text.trim()),
        data: DateFormat('yyyy-MM-dd').format(_selectedDate),
        quilometragem: _quilometragemController.text.trim().isEmpty
            ? null
            : int.parse(_quilometragemController.text.trim()),
        posto: _postoController.text.trim().isEmpty
            ? null
            : _postoController.text.trim(),
        tipoCombustivel: _selectedTipoCombustivel,
      );

      if (widget.abastecimento == null) {
        await DatabaseHelper.instance.insertAbastecimento(abastecimento);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Abastecimento registado com sucesso!')),
        );
      } else {
        await DatabaseHelper.instance.updateAbastecimento(abastecimento);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Abastecimento atualizado com sucesso!')),
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.abastecimento == null
            ? 'Novo Abastecimento'
            : 'Editar Abastecimento'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _litrosController,
                      decoration: InputDecoration(
                        labelText: 'Litros *',
                        prefixIcon: Icon(Icons.local_gas_station),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Obrigatório';
                        if (double.tryParse(value!) == null) return 'Inválido';
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _precoLitroController,
                      decoration: InputDecoration(
                        labelText: 'Preço/Litro (MT) *',
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Obrigatório';
                        if (double.tryParse(value!) == null) return 'Inválido';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _custoTotalController,
                decoration: InputDecoration(
                  labelText: 'Custo Total (MT) *',
                  prefixIcon: Icon(Icons.payments),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                readOnly: true,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Data do Abastecimento *',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedTipoCombustivel,
                decoration: InputDecoration(
                  labelText: 'Tipo de Combustível',
                  prefixIcon: Icon(Icons.oil_barrel),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                items: ['Diesel', 'Gasolina', 'Gás', 'Elétrico']
                    .map((tipo) =>
                        DropdownMenuItem(value: tipo, child: Text(tipo)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedTipoCombustivel = value!),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _postoController,
                decoration: InputDecoration(
                  labelText: 'Posto de Abastecimento',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _quilometragemController,
                decoration: InputDecoration(
                  labelText: 'Quilometragem Atual',
                  prefixIcon: Icon(Icons.speed),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveAbastecimento,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    widget.abastecimento == null
                        ? 'Salvar Abastecimento'
                        : 'Atualizar Abastecimento',
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
