// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'helpers/database_helper.dart';
import 'models/truck.dart';
import 'screens/truck_detail_screen.dart';
import 'services/relatorio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TruckApp());
}

class TruckApp extends StatelessWidget {
  const TruckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TRUCK - APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
        ),
      ),
      home: TruckListScreen(),
    );
  }
}

class TruckListScreen extends StatefulWidget {
  const TruckListScreen({super.key});

  @override
  State<TruckListScreen> createState() => _TruckListScreenState();
}

class _TruckListScreenState extends State<TruckListScreen> {
  List<Truck> _trucks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrucks();
  }

  Future<void> _loadTrucks() async {
    setState(() => _isLoading = true);
    final trucks = await DatabaseHelper.instance.queryAllTrucks();
    setState(() {
      _trucks = trucks;
      _isLoading = false;
    });
  }

  void _openAddTruckModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TruckFormModal(
        onSaved: () {
          Navigator.pop(context);
          _loadTrucks();
        },
      ),
    );
  }

  void _openEditTruckModal(Truck truck) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TruckFormModal(
        truck: truck,
        onSaved: () {
          Navigator.pop(context);
          _loadTrucks();
        },
      ),
    );
  }

  void _openTruckDetails(Truck truck) {
    if (truck.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ID do camião não encontrado')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TruckDetailScreen(truck: truck),
      ),
    ).then((_) => _loadTrucks());
  }

  Future<void> _deleteTruck(int id, String matricula) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Eliminação'),
        content: Text(
            'Deseja eliminar o camião $matricula?\n\nIsto também eliminará todo o histórico de manutenções e abastecimentos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deleteTruck(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camião eliminado com sucesso')),
      );
      _loadTrucks();
    }
  }

  // ========== EXPORTAÇÃO DE RELATÓRIOS ==========

  Future<void> _exportarPDF() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text('Gerando relatório PDF...',
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );

      final pdfPath = await RelatorioService.gerarRelatorioPDF();
      Navigator.pop(context); // Fechar loading

      await Share.shareXFiles(
        [XFile(pdfPath)],
        subject: 'Relatório TRUCK - ${DateTime.now().toString().split(' ')[0]}',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Relatório PDF gerado com sucesso!')),
      );
    } catch (e) {
      Navigator.pop(context); // Fechar loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('❌ Erro ao gerar PDF: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _exportarExcel() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text('Gerando relatório Excel...',
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );

      final excelPath = await RelatorioService.gerarRelatorioExcel();
      Navigator.pop(context); // Fechar loading

      await Share.shareXFiles(
        [XFile(excelPath)],
        subject: 'Relatório TRUCK - ${DateTime.now().toString().split(' ')[0]}',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Relatório Excel gerado com sucesso!')),
      );
    } catch (e) {
      Navigator.pop(context); // Fechar loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('❌ Erro ao gerar Excel: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Ativo':
        return Colors.green;
      case 'Manutenção':
        return Colors.orange;
      case 'Inativo':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Ativo':
        return Icons.check_circle;
      case 'Manutenção':
        return Icons.build;
      case 'Inativo':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.local_shipping, size: 28),
            SizedBox(width: 10),
            Text('TRUCK - APP'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Atualizar',
            onPressed: _loadTrucks,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _trucks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_shipping_outlined,
                          size: 100, color: Colors.grey[400]),
                      SizedBox(height: 20),
                      Text(
                        'Nenhum camião registado',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Adicione o primeiro camião usando o botão +',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadTrucks,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _trucks.length,
                    itemBuilder: (context, index) {
                      final truck = _trucks[index];
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _openTruckDetails(truck),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            truck.matricula,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue[800],
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '${truck.marca} ${truck.modelo}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(truck.status)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: _getStatusColor(truck.status),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _getStatusIcon(truck.status),
                                            size: 16,
                                            color:
                                                _getStatusColor(truck.status),
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            truck.status,
                                            style: TextStyle(
                                              color:
                                                  _getStatusColor(truck.status),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _InfoChip(
                                        icon: Icons.person,
                                        label: truck.motorista,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: _InfoChip(
                                        icon: Icons.calendar_today,
                                        label: truck.ano.toString(),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                _InfoChip(
                                  icon: Icons.speed,
                                  label:
                                      '${truck.quilometragem.toStringAsFixed(0)} km',
                                ),
                                if (truck.observacoes != null &&
                                    truck.observacoes!.isNotEmpty) ...[
                                  SizedBox(height: 12),
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.info_outline,
                                            size: 16, color: Colors.blue[700]),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            truck.observacoes!,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.blue[900],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () => _openTruckDetails(truck),
                                      icon: Icon(Icons.visibility, size: 18),
                                      label: Text('Ver Detalhes'),
                                    ),
                                    TextButton.icon(
                                      onPressed: () =>
                                          _openEditTruckModal(truck),
                                      icon: Icon(Icons.edit, size: 18),
                                      label: Text('Editar'),
                                    ),
                                    TextButton.icon(
                                      onPressed: () => _deleteTruck(
                                          truck.id!, truck.matricula),
                                      icon: Icon(Icons.delete, size: 18),
                                      label: Text('Eliminar'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTruckModal,
        icon: Icon(Icons.add),
        label: Text('Adicionar Camião'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey[800]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class TruckFormModal extends StatefulWidget {
  final Truck? truck;
  final VoidCallback onSaved;

  const TruckFormModal({super.key, this.truck, required this.onSaved});

  @override
  State<TruckFormModal> createState() => _TruckFormModalState();
}

class _TruckFormModalState extends State<TruckFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _matriculaController;
  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _anoController;
  late TextEditingController _motoristaController;
  late TextEditingController _quilometragemController;
  late TextEditingController _observacoesController;
  String _selectedStatus = 'Ativo';

  @override
  void initState() {
    super.initState();
    _matriculaController =
        TextEditingController(text: widget.truck?.matricula ?? '');
    _marcaController = TextEditingController(text: widget.truck?.marca ?? '');
    _modeloController = TextEditingController(text: widget.truck?.modelo ?? '');
    _anoController =
        TextEditingController(text: widget.truck?.ano.toString() ?? '');
    _motoristaController =
        TextEditingController(text: widget.truck?.motorista ?? '');
    _quilometragemController = TextEditingController(
        text: widget.truck?.quilometragem.toString() ?? '');
    _observacoesController =
        TextEditingController(text: widget.truck?.observacoes ?? '');
    _selectedStatus = widget.truck?.status ?? 'Ativo';
  }

  @override
  void dispose() {
    _matriculaController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _anoController.dispose();
    _motoristaController.dispose();
    _quilometragemController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _saveTruck() async {
    if (_formKey.currentState!.validate()) {
      final truck = Truck(
        id: widget.truck?.id,
        matricula: _matriculaController.text.trim(),
        marca: _marcaController.text.trim(),
        modelo: _modeloController.text.trim(),
        ano: int.parse(_anoController.text.trim()),
        motorista: _motoristaController.text.trim(),
        status: _selectedStatus,
        quilometragem: double.parse(_quilometragemController.text.trim()),
        observacoes: _observacoesController.text.trim().isEmpty
            ? null
            : _observacoesController.text.trim(),
        fotoPath: widget.truck?.fotoPath, // Preservar foto existente
      );

      if (widget.truck == null) {
        await DatabaseHelper.instance.insertTruck(truck);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camião adicionado com sucesso!')),
        );
      } else {
        await DatabaseHelper.instance.updateTruck(truck);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camião atualizado com sucesso!')),
        );
      }

      widget.onSaved();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.truck == null
                          ? 'Adicionar Camião'
                          : 'Editar Camião',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                TextFormField(
                  controller: _matriculaController,
                  decoration: InputDecoration(
                    labelText: 'Matrícula *',
                    prefixIcon: Icon(Icons.confirmation_number),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _marcaController,
                        decoration: InputDecoration(
                          labelText: 'Marca *',
                          prefixIcon: Icon(Icons.business),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _modeloController,
                        decoration: InputDecoration(
                          labelText: 'Modelo *',
                          prefixIcon: Icon(Icons.local_shipping),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _anoController,
                        decoration: InputDecoration(
                          labelText: 'Ano *',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true)
                            return 'Campo obrigatório';
                          final ano = int.tryParse(value!);
                          if (ano == null || ano < 1900 || ano > 2100) {
                            return 'Ano inválido';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: InputDecoration(
                          labelText: 'Status *',
                          prefixIcon: Icon(Icons.circle),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: ['Ativo', 'Manutenção', 'Inativo']
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => _selectedStatus = value!);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _motoristaController,
                  decoration: InputDecoration(
                    labelText: 'Motorista *',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _quilometragemController,
                  decoration: InputDecoration(
                    labelText: 'Quilometragem (km) *',
                    prefixIcon: Icon(Icons.speed),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Campo obrigatório';
                    if (double.tryParse(value!) == null) {
                      return 'Valor inválido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _observacoesController,
                  decoration: InputDecoration(
                    labelText: 'Observações',
                    prefixIcon: Icon(Icons.notes),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveTruck,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      widget.truck == null ? 'Adicionar' : 'Salvar Alterações',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
