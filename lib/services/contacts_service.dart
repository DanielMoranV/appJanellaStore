import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsService {
  /// Solicita permiso para acceder a los contactos
  Future<bool> requestPermission() async {
    final status = await Permission.contacts.request();
    return status.isGranted;
  }

  /// Abre el selector nativo de contactos y retorna el contacto seleccionado
  Future<Contact?> pickContact() async {
    // Verificar permisos
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      return null;
    }

    // Abrir selector nativo
    final contact = await FlutterContacts.openExternalPick();
    
    if (contact != null) {
      // Obtener detalles completos (aunque openExternalPick a veces ya los trae, 
      // es mejor asegurarse si necesitamos más campos, pero para nombre y teléfono suele bastar)
      // En este caso, openExternalPick retorna un contacto "ligero". 
      // Si necesitamos más detalles, podríamos buscarlo por ID, pero probemos con lo que devuelve.
      return contact;
    }
    
    return null;
  }

  /// Formatea el número de teléfono eliminando caracteres no numéricos
  String formatPhone(String phone) {
    return phone.replaceAll(RegExp(r'[^\d+]'), '');
  }
}
