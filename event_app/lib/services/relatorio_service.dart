import 'dart:io';
import 'package:event_app/models/abastecimento.dart';
import 'package:event_app/models/Manuntencao.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart' as excel_lib;
import '../helpers/database_helper.dart';
import '../models/truck.dart';

class RelatorioService {
  // ==================== EXPORTAÇÃO PDF ====================

  static Future<String> gerarRelatorioPDF() async {
    final relatorio = await DatabaseHelper.instance.getRelatorioCompleto();
    final trucks = relatorio['trucks'] as List<Truck>;
    final manutencoes = relatorio['manutencoes'] as List<Manutencao>;
    final abastecimentos = relatorio['abastecimentos'] as List<Abastecimento>;

    final pdf = pw.Document();

    // Página 1: Resumo Geral
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          // Cabeçalho
          pw.Header(
            level: 0,
            child: pw.Text(
              'TRUCK - Relatório de Gestão de Frotas',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),

          // Informações Gerais
          pw.Text(
            'Resumo Geral',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(),
          pw.SizedBox(height: 10),

          _buildInfoRow('Total de Camiões:', '${relatorio['totalTrucks']}'),
          _buildInfoRow(
              'Total de Manutenções:', '${relatorio['totalManutencoes']}'),
          _buildInfoRow('Total de Abastecimentos:',
              '${relatorio['totalAbastecimentos']}'),
          pw.SizedBox(height: 10),
          _buildInfoRow('Custo Total Manutenções:',
              '${relatorio['custoManutencao'].toStringAsFixed(2)} MT'),
          _buildInfoRow('Custo Total Abastecimentos:',
              '${relatorio['custoAbastecimento'].toStringAsFixed(2)} MT'),
          _buildInfoRow('CUSTO TOTAL GERAL:',
              '${relatorio['custoTotal'].toStringAsFixed(2)} MT',
              bold: true),

          pw.SizedBox(height: 30),

          // Lista de Camiões
          pw.Text(
            'Frota Actual',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(),
          pw.SizedBox(height: 10),

          ...trucks
              .map((truck) => pw.Container(
                    margin: pw.EdgeInsets.only(bottom: 15),
                    padding: pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(5),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              truck.matricula,
                              style: pw.TextStyle(
                                  fontSize: 14, fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Container(
                              padding: pw.EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: pw.BoxDecoration(
                                color: _getStatusColorPDF(truck.status),
                                borderRadius: pw.BorderRadius.circular(4),
                              ),
                              child: pw.Text(
                                truck.status,
                                style: pw.TextStyle(
                                    fontSize: 10, color: PdfColors.white),
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                            '${truck.marca} ${truck.modelo} (${truck.ano})'),
                        pw.Text('Motorista: ${truck.motorista}'),
                        pw.Text(
                            'Quilometragem: ${truck.quilometragem.toStringAsFixed(0)} km'),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );

    // Página 2: Histórico de Manutenções
    if (manutencoes.isNotEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(32),
          build: (pw.Context context) => [
            pw.Header(
              level: 1,
              child: pw.Text(
                'Histórico de Manutenções',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellStyle: pw.TextStyle(fontSize: 10),
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 30,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.centerLeft,
              },
              data: [
                ['Data', 'Tipo', 'Descrição', 'Custo (MT)', 'Oficina'],
                ...manutencoes
                    .map((m) => [
                          m.data,
                          m.tipo,
                          m.descricao,
                          m.custo.toStringAsFixed(2),
                          m.oficina ?? '-',
                        ])
                    .toList(),
              ],
            ),
          ],
        ),
      );
    }

    // Página 3: Histórico de Abastecimentos
    if (abastecimentos.isNotEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(32),
          build: (pw.Context context) => [
            pw.Header(
              level: 1,
              child: pw.Text(
                'Histórico de Abastecimentos',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellStyle: pw.TextStyle(fontSize: 10),
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 30,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.centerLeft,
              },
              data: [
                ['Data', 'Litros', 'Preço/L (MT)', 'Total (MT)', 'Posto'],
                ...abastecimentos
                    .map((a) => [
                          a.data,
                          a.litros.toStringAsFixed(2),
                          a.precoLitro.toStringAsFixed(2),
                          a.custoTotal.toStringAsFixed(2),
                          a.posto ?? '-',
                        ])
                    .toList(),
              ],
            ),
          ],
        ),
      );
    }

    // Salvar PDF
    final output = await getApplicationDocumentsDirectory();
    final file = File(
        '${output.path}/relatorio_frotas_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());

    return file.path;
  }

  // ==================== EXPORTAÇÃO EXCEL ====================

  static Future<String> gerarRelatorioExcel() async {
    final relatorio = await DatabaseHelper.instance.getRelatorioCompleto();
    final trucks = relatorio['trucks'] as List<Truck>;
    final manutencoes = relatorio['manutencoes'] as List<Manutencao>;
    final abastecimentos = relatorio['abastecimentos'] as List<Abastecimento>;

    var excel = excel_lib.Excel.createExcel();

    // Sheet 1: Resumo
    var sheetResumo = excel['Resumo'];
    sheetResumo.appendRow(
        [excel_lib.TextCellValue('TRUCK - Relatório de Gestão de Frotas')]);
    sheetResumo.appendRow([]);
    sheetResumo.appendRow([
      excel_lib.TextCellValue('Indicador'),
      excel_lib.TextCellValue('Valor')
    ]);
    sheetResumo.appendRow([
      excel_lib.TextCellValue('Total de Camiões'),
      relatorio['totalTrucks']
    ]);
    sheetResumo.appendRow([
      excel_lib.TextCellValue('Total de Manutenções'),
      relatorio['totalManutencoes']
    ]);
    sheetResumo.appendRow([
      excel_lib.TextCellValue('Total de Abastecimentos'),
      relatorio['totalAbastecimentos']
    ]);
    sheetResumo.appendRow([]);
    sheetResumo.appendRow([
      excel_lib.TextCellValue('Custo Total Manutenções (MT)'),
      relatorio['custoManutencao']
    ]);
    sheetResumo.appendRow([
      excel_lib.TextCellValue('Custo Total Abastecimentos (MT)'),
      relatorio['custoAbastecimento']
    ]);
    sheetResumo.appendRow([
      excel_lib.TextCellValue('CUSTO TOTAL GERAL (MT)'),
      relatorio['custoTotal']
    ]);

    // Sheet 2: Camiões
    var sheetTrucks = excel['Camiões'];
    sheetTrucks.appendRow([
      excel_lib.TextCellValue('ID'),
      excel_lib.TextCellValue('Matrícula'),
      excel_lib.TextCellValue('Marca'),
      excel_lib.TextCellValue('Modelo'),
      excel_lib.TextCellValue('Ano'),
      excel_lib.TextCellValue('Motorista'),
      excel_lib.TextCellValue('Status'),
      excel_lib.TextCellValue('Quilometragem'),
      excel_lib.TextCellValue('Observações')
    ]);
    for (var truck in trucks) {
      sheetTrucks.appendRow([
        excel_lib.TextCellValue(truck.id?.toString() ?? ''),
        excel_lib.TextCellValue(truck.matricula),
        excel_lib.TextCellValue(truck.marca),
        excel_lib.TextCellValue(truck.modelo),
        excel_lib.TextCellValue(truck.motorista),
        excel_lib.TextCellValue(truck.status),
        excel_lib.TextCellValue(truck.observacoes ?? ''),
      ]);
    }

    // Sheet 3: Manutenções
    var sheetManutencoes = excel['Manutenções'];
    sheetManutencoes.appendRow([
      excel_lib.TextCellValue('ID'),
      excel_lib.TextCellValue('Camião ID'),
      excel_lib.TextCellValue('Data'),
      excel_lib.TextCellValue('Tipo'),
      excel_lib.TextCellValue('Descrição'),
      excel_lib.TextCellValue('Custo (MT)'),
      excel_lib.TextCellValue('Oficina'),
      excel_lib.TextCellValue('Quilometragem'),
      excel_lib.TextCellValue('Próxima Manutenção')
    ]);
    for (var m in manutencoes) {
      sheetManutencoes.appendRow([
        excel_lib.TextCellValue(m.id?.toString() ?? ''),
        excel_lib.TextCellValue(m.truckId?.toString() ?? ''),
        excel_lib.TextCellValue(m.data),
        excel_lib.TextCellValue(m.tipo),
        excel_lib.TextCellValue(m.descricao),
        excel_lib.TextCellValue(m.oficina ?? ''),
        excel_lib.TextCellValue(m.proximaManutencao ?? ''),
      ]);
    }

    // Sheet 4: Abastecimentos
    var sheetAbastecimentos = excel['Abastecimentos'];
    sheetAbastecimentos.appendRow([
      excel_lib.TextCellValue('ID'),
      excel_lib.TextCellValue('Camião ID'),
      excel_lib.TextCellValue('Data'),
      excel_lib.TextCellValue('Litros'),
      excel_lib.TextCellValue('Preço/Litro (MT)'),
      excel_lib.TextCellValue('Custo Total (MT)'),
      excel_lib.TextCellValue('Quilometragem'),
      excel_lib.TextCellValue('Posto'),
      excel_lib.TextCellValue('Tipo Combustível')
    ]);
    for (var a in abastecimentos) {
      sheetAbastecimentos.appendRow([
        excel_lib.TextCellValue(a.id?.toString() ?? ''),
        excel_lib.TextCellValue(a.truckId?.toString() ?? ''),
        excel_lib.TextCellValue(a.data),
        excel_lib.TextCellValue(a.litros.toString()),
        excel_lib.TextCellValue(a.precoLitro.toString()),
        excel_lib.TextCellValue(a.custoTotal.toString()),
        excel_lib.TextCellValue(a.posto ?? ''),
        excel_lib.TextCellValue(a.tipoCombustivel ?? ''),
      ]);
    }

    // Remover sheet padrão
    excel.delete('Sheet1');

    // Salvar Excel
    final output = await getApplicationDocumentsDirectory();
    final file = File(
        '${output.path}/relatorio_frotas_${DateTime.now().millisecondsSinceEpoch}.xlsx');
    await file.writeAsBytes(excel.encode()!);

    return file.path;
  }

  // ==================== HELPERS ====================

  static pw.Widget _buildInfoRow(String label, String value,
      {bool bold = false}) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  static PdfColor _getStatusColorPDF(String status) {
    switch (status) {
      case 'Ativo':
        return PdfColors.green;
      case 'Manutenção':
        return PdfColors.orange;
      case 'Inativo':
        return PdfColors.red;
      default:
        return PdfColors.grey;
    }
  }
}
