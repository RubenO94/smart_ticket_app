import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ticket/models/calendario.dart';

class CalendarioGeralNotifier extends StateNotifier<List<Calendario>> {
  CalendarioGeralNotifier() : super([]);
  List<Calendario> _originalEvents = [];
  List<Calendario> _filteredEvents = [];

  void setCalendarioGeral(List<Calendario> calendarioGeral) {
    _originalEvents = calendarioGeral;
    _filteredEvents = calendarioGeral;
    state = calendarioGeral;
  }

  void filterEvents(String query) {
    if (query.isEmpty) {
      state = [..._originalEvents]; // Mostrar todos os eventos
      _filteredEvents = [];
    } else {
      _filteredEvents = _originalEvents
          .where((event) =>
              event.horaInicio.contains(query) ||
              event.horaFim.contains(query) ||
              event.descricao.toLowerCase().contains(query.toLowerCase()))
          .toList();

      state = [..._filteredEvents]; // Atualizar os eventos filtrados
    }
  }

  void clearSearch() {
    state = [..._originalEvents]; // Restaurar a lista original de eventos
    _filteredEvents = [];
  }
}

final calendarioGeralProvider =
    StateNotifierProvider<CalendarioGeralNotifier, List<Calendario>>(
        (ref) => CalendarioGeralNotifier());

final calendarioPessoalProvider = Provider<List<Calendario>>(
  (ref) {
    final calendarioGeral = ref.watch(calendarioGeralProvider);
    final calendarioPessoal =
        calendarioGeral.where((element) => element.inscrito).toList();
    return calendarioPessoal;
  },
);
