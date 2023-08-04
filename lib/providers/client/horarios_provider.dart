import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/client/horario.dart';

class HorariosGeralNotifier extends StateNotifier<List<Horario>> {
  HorariosGeralNotifier() : super([]);
  List<Horario> _originalEvents = [];
  List<Horario> _filteredEvents = [];

  void setHorariosGeral(List<Horario> calendarioGeral) {
    _originalEvents = calendarioGeral;
    _filteredEvents = calendarioGeral;
    state = calendarioGeral;
  }

  void filterEvents(String query) {
    if (query.isEmpty) {
      state = [..._originalEvents]; // Mostrar todas as aulas
      _filteredEvents = [];
    } else {
      _filteredEvents = _originalEvents
          .where((event) =>
              event.horaInicio.contains(query) ||
              event.horaFim.contains(query) ||
              event.descricao.toLowerCase().contains(query.toLowerCase()))
          .toList();

      state = [..._filteredEvents]; // Atualizar as aulas filtradas
    }
  }

  void clearSearch() {
    state = [..._originalEvents]; // Restaurar a lista original de aulas
    _filteredEvents = [];
  }
}

final calendarioGeralProvider =
    StateNotifierProvider<HorariosGeralNotifier, List<Horario>>(
        (ref) => HorariosGeralNotifier());

final calendarioPessoalProvider = Provider<List<Horario>>(
  (ref) {
    final calendarioGeral = ref.watch(calendarioGeralProvider);
    final calendarioPessoal =
        calendarioGeral.where((element) => element.inscrito).toList();
    return calendarioPessoal;
  },
);
