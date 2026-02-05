// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:event_app/models/manuntencao.dart';
import 'package:event_app/screens/abastecimento.dart';
import 'package:event_app/screens/manuntencao_form.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../helpers/database_helper.dart';
import '../models/truck.dart';
import '../models/abastecimento.dart';

class TruckDetailScreen extends StatefulWidget {
  final Truck truck;

  const TruckDetailScreen({super.key, required this.truck});

  @override
  State<TruckDetailScreen> createState() => _TruckDetailScreenState();
}

class _TruckDetailScreenState extends State<TruckDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Manutencao> _manutencoes = [];
  List<Abastecimento> _abastecimentos = [];
  bool _isLoading = true;
  late Truck _currentTruck;

  @override
  void initState() {
    super.initState();
    _currentTruck = widget.truck;
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final manutencoes = await DatabaseHelper.instance
          .queryManutencoesByTruck(_currentTruck.id!);
      final abastecimentos = await DatabaseHelper.instance
          .queryAbastecimentosByTruck(_currentTruck.id!);
      final truck =
          await DatabaseHelper.instance.queryTruckById(_currentTruck.id!);

      setState(() {
        _manutencoes = manutencoes;
        _abastecimentos = abastecimentos;
        if (truck != null) _currentTruck = truck;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final updatedTruck = Truck(
        id: _currentTruck.id,
        matricula: _currentTruck.matricula,
        marca: _currentTruck.marca,
        modelo: _currentTruck.modelo,
        ano: _currentTruck.ano,
        motorista: _currentTruck.motorista,
        status: _currentTruck.status,
        quilometragem: _currentTruck.quilometragem,
        observacoes: _currentTruck.observacoes,
        fotoPath: image.path,
      );

      await DatabaseHelper.instance.updateTruck(updatedTruck);
      setState(() => _currentTruck = updatedTruck);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Foto adicionada com sucesso!')),
      );
    }
  }

  double _calcularCustoTotalManutencoes() {
    return _manutencoes.fold(0.0, (sum, m) => sum + m.custo);
  }

  double _calcularCustoTotalAbastecimentos() {
    return _abastecimentos.fold(0.0, (sum, a) => sum + a.custoTotal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentTruck.matricula),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.info), text: 'Informações'),
            Tab(icon: Icon(Icons.build), text: 'Manutenções'),
            Tab(icon: Icon(Icons.local_gas_station), text: 'Abastecimentos'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildInfoTab(),
                _buildManutencoesTab(),
                _buildAbastecimentosTab(),
              ],
            ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto do camião
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[800]!, width: 2),
                ),
                child: _currentTruck.fotoPath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(_currentTruck.fotoPath!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt,
                              size: 60, color: Colors.grey[600]),
                          SizedBox(height: 10),
                          Text('Toque para adicionar foto',
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
              ),
            ),
          ),
          SizedBox(height: 24),

          // Informações do camião
          _buildSectionTitle('Dados do Camião'),
          _buildInfoCard([
            _buildInfoRow('Matrícula', _currentTruck.matricula),
            _buildInfoRow('Marca', _currentTruck.marca),
            _buildInfoRow('Modelo', _currentTruck.modelo),
            _buildInfoRow('Ano', _currentTruck.ano.toString()),
            _buildInfoRow('Motorista', _currentTruck.motorista),
            _buildInfoRow('Status', _currentTruck.status),
            _buildInfoRow('Quilometragem',
                '${_currentTruck.quilometragem.toStringAsFixed(0)} km'),
          ]),

          if (_currentTruck.observacoes != null &&
              _currentTruck.observacoes!.isNotEmpty) ...[
            SizedBox(height: 16),
            _buildSectionTitle('Observações'),
            _buildInfoCard([
              Text(_currentTruck.observacoes!, style: TextStyle(fontSize: 14)),
            ]),
          ],

          SizedBox(height: 24),
          _buildSectionTitle('Estatísticas'),
          _buildInfoCard([
            _buildInfoRow('Total Manutenções', '${_manutencoes.length}'),
            _buildInfoRow('Custo Manutenções',
                '${_calcularCustoTotalManutencoes().toStringAsFixed(2)} MT'),
            Divider(),
            _buildInfoRow('Total Abastecimentos', '${_abastecimentos.length}'),
            _buildInfoRow('Custo Abastecimentos',
                '${_calcularCustoTotalAbastecimentos().toStringAsFixed(2)} MT'),
            Divider(thickness: 2),
            _buildInfoRow(
              'CUSTO TOTAL',
              '${(_calcularCustoTotalManutencoes() + _calcularCustoTotalAbastecimentos()).toStringAsFixed(2)} MT',
              bold: true,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildManutencoesTab() {
    return Column(
      children: [
        Expanded(
          child: _manutencoes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.build_circle_outlined,
                          size: 80, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text('Nenhuma manutenção registada',
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _manutencoes.length,
                  itemBuilder: (context, index) {
                    final m = _manutencoes[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getTipoColor(m.tipo),
                          child: Icon(Icons.build, color: Colors.white),
                        ),
                        title: Text(m.tipo,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m.descricao),
                            Text('Data: ${m.data}'),
                            if (m.oficina != null)
                              Text('Oficina: ${m.oficina}'),
                          ],
                        ),
                        trailing: Text(
                          '${m.custo.toStringAsFixed(2)} MT',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red[700]),
                        ),
                      ),
                    );
                  },
                ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ManutencaoFormScreen(truckId: _currentTruck.id!),
                ),
              ).then((_) => _loadData());
            },
            icon: Icon(Icons.add),
            label: Text('Adicionar Manutenção'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              backgroundColor: Colors.blue[800],
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAbastecimentosTab() {
    return Column(
      children: [
        Expanded(
          child: _abastecimentos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_gas_station_outlined,
                          size: 80, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text('Nenhum abastecimento registado',
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _abastecimentos.length,
                  itemBuilder: (context, index) {
                    final a = _abastecimentos[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green[700],
                          child: Icon(Icons.local_gas_station,
                              color: Colors.white),
                        ),
                        title: Text('${a.litros.toStringAsFixed(2)} L',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Data: ${a.data}'),
                            Text(
                                'Preço/L: ${a.precoLitro.toStringAsFixed(2)} MT'),
                            if (a.posto != null) Text('Posto: ${a.posto}'),
                          ],
                        ),
                        trailing: Text(
                          '${a.custoTotal.toStringAsFixed(2)} MT',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700]),
                        ),
                      ),
                    );
                  },
                ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AbastecimentoFormScreen(truckId: _currentTruck.id!),
                ),
              ).then((_) => _loadData());
            },
            icon: Icon(Icons.add),
            label: Text('Adicionar Abastecimento'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[800]),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700])),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTipoColor(String tipo) {
    switch (tipo) {
      case 'Preventiva':
        return Colors.blue;
      case 'Corretiva':
        return Colors.orange;
      case 'Revisão':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
