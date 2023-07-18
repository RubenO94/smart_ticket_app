import '../models/atividade.dart';
import '../models/atividade_letiva.dart';
import '../models/aula.dart';
import '../models/pagamento.dart';

final List<Atividade> atividades = [
  const Atividade(
    id: 5,
    codigo: '2001',
    descricao: 'A - Aprendizagem 8-14 Anos',
  ),
  const Atividade(
    id: 6,
    codigo: '2002',
    descricao: 'INI - Iniciação 4-7 Anos',
  ),
  const Atividade(
    id: 8,
    codigo: '2004',
    descricao: 'X - Aprendizagem >= 15 Anos',
  ),
  const Atividade(
    id: 9,
    codigo: '2005',
    descricao: 'W - Aprend 10-15 Anos',
  ),
  const Atividade(
    id: 10,
    codigo: '3001',
    descricao: 'Z - Aperfeiçoamento >= 15 Anos',
  ),
  const Atividade(
    id: 11,
    codigo: '3002',
    descricao: 'Y - Aperfeiçoamento < 15 Anos',
  ),
  const Atividade(
    id: 16,
    codigo: '3004',
    descricao: 'COMP - AMAMB',
  ),
  const Atividade(
    id: 14,
    codigo: '5001',
    descricao: 'B - Natação para Bebés',
  ),
  const Atividade(
    id: 15,
    codigo: '6001',
    descricao: 'T - Exercício Físico Assistido',
  ),
  const Atividade(
    id: 17,
    codigo: '7001',
    descricao: 'BC - Bebés >= 18 meses e <= 36 meses',
  ),
  const Atividade(
    id: 18,
    codigo: '8001',
    descricao: 'Q - Atividade Aquática',
  ),
  const Atividade(
    id: 23,
    codigo: '8002',
    descricao: 'H - Hidroginástica',
  ),
  const Atividade(
    id: 25,
    codigo: '8003',
    descricao: 'TC - Natação Adaptada',
  ),
  const Atividade(
    id: 19,
    codigo: '9001',
    descricao: 'AC - Aprendizagem <15 anos',
  ),
  const Atividade(
    id: 20,
    codigo: '9002',
    descricao: 'XC - Aprendizagem Adultos >= 15 anos',
  ),
  const Atividade(
    id: 21,
    codigo: '9003',
    descricao: 'YC - Aperfeiçoamento < 15 anos',
  ),
  const Atividade(
    id: 22,
    codigo: '9004',
    descricao: 'ZC - Aperfeiçoamento >= 15 anos',
  ),
  const Atividade(
    id: 24,
    codigo: '9005',
    descricao: 'IN - Iniciação 4-6 Anos',
  ),
];

final List<AtividadeLetiva> atividadesLetivas = [
  const AtividadeLetiva(
    id: 1,
    dataInicio: '2022-10-01',
    dataFim: '2023-07-31',
  ),
];

final List<Aula> aulas = [
  Aula(
    idAulaInscricao: 0,
    idAula: 111,
    idAtivadadeLetiva: 1,
    periodoLetivo: '',
    vagas: 5,
    inscritos: 7,
    lotacao: 12,
    pendente: false,
    nPendentes: 0,
    dataInscricao: DateTime.fromMillisecondsSinceEpoch(-62135596800000),
    atividade: '',
    aula: '111 | Z14 - APERF (4.ªSÁB.ª) 18h40/10h25',
  ),
  Aula(
    idAulaInscricao: 0,
    idAula: 96,
    idAtivadadeLetiva: 1,
    periodoLetivo: '',
    vagas: 1,
    inscritos: 11,
    lotacao: 12,
    pendente: false,
    nPendentes: 0,
    dataInscricao: DateTime.fromMillisecondsSinceEpoch(-62135596800000),
    atividade: '',
    aula: '115 | Z04 - APERFEIÇOAMENTO (2.ª5.ª) 18h40',
  ),
  Aula(
    idAulaInscricao: 0,
    idAula: 94,
    idAtivadadeLetiva: 1,
    periodoLetivo: '',
    vagas: 1,
    inscritos: 11,
    lotacao: 12,
    pendente: false,
    nPendentes: 0,
    dataInscricao: DateTime.fromMillisecondsSinceEpoch(-62135596800000),
    atividade: '',
    aula: '116 | Z06 - APERFEIÇOAMENTO (2.ª5.ª) 20h00',
  ),
  // Restante das aulas...
];

final List<Pagamento> pagamentos = [
  Pagamento(
    dataInicio: DateTime.fromMillisecondsSinceEpoch(1677628800000),
    dataFim: DateTime.fromMillisecondsSinceEpoch(1680217200000),
    desconto: 0.0,
    desconto1: 0.0,
    idClienteTarifaLinha: 51726,
    idTarifaLinha: 269,
    plano: '1.Tarifas | A08 - APRENDIZAGEM (3.ª6.ª) 20h00',
    valor: 20.00,
  ),
  Pagamento(
    dataInicio: DateTime.fromMillisecondsSinceEpoch(1680303600000),
    dataFim: DateTime.fromMillisecondsSinceEpoch(1682809200000),
    desconto: 0.0,
    desconto1: 0.0,
    idClienteTarifaLinha: 51727,
    idTarifaLinha: 269,
    plano: '1.Tarifas | A08 - APRENDIZAGEM (3.ª6.ª) 20h00',
    valor: 20.00,
  ),
  Pagamento(
    dataInicio: DateTime.fromMillisecondsSinceEpoch(1682895600000),
    dataFim: DateTime.fromMillisecondsSinceEpoch(1685487600000),
    desconto: 0.0,
    desconto1: 0.0,
    idClienteTarifaLinha: 51728,
    idTarifaLinha: 269,
    plano: '1.Tarifas | A08 - APRENDIZAGEM (3.ª6.ª) 20h00',
    valor: 20.00,
  ),
  Pagamento(
    dataInicio: DateTime.fromMillisecondsSinceEpoch(1685574000000),
    dataFim: DateTime.fromMillisecondsSinceEpoch(1688079600000),
    desconto: 0.0,
    desconto1: 0.0,
    idClienteTarifaLinha: 51729,
    idTarifaLinha: 269,
    plano: '1.Tarifas | A08 - APRENDIZAGEM (3.ª6.ª) 20h00',
    valor: 20.00,
  ),
  Pagamento(
    dataInicio: DateTime.fromMillisecondsSinceEpoch(1688166000000),
    dataFim: DateTime.fromMillisecondsSinceEpoch(1690758000000),
    desconto: 0.0,
    desconto1: 0.0,
    idClienteTarifaLinha: 51730,
    idTarifaLinha: 269,
    plano: '1.Tarifas | A08 - APRENDIZAGEM (3.ª6.ª) 20h00',
    valor: 20.00,
  ),
];

final List<Aula> inscricoes = [
  Aula(
    atividade: '2001 | A - Aprendizagem 8-14 Anos',
    aula: '045 | A08 - APRENDIZAGEM (3.ª6.ª) 20h00',
    dataInscricao: DateTime.fromMillisecondsSinceEpoch(1674590373240),
    idAtivadadeLetiva: 0,
    idAula: 0,
    idAulaInscricao: 1908,
    inscritos: 0,
    lotacao: 0,
    pendente: false,
    nPendentes: 0,
    periodoLetivo: '01/out/2022 | 31/jul/2023',
    vagas: 0,
  ),
];
