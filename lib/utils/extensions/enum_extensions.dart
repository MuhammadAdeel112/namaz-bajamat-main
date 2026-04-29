import '../enums.dart';

extension FiqaExtension on Fiqa {
  String get label {
    switch (this) {
      case Fiqa.Deobandi:
        return 'Deobandi';
      case Fiqa.Barelvi:
        return 'Barelvi';
      case Fiqa.AhleHadees:
        return 'AhleHadees';
    }
  }
}
extension StringToFiqa on String {
  Fiqa toFiqa() {
    return Fiqa.values.firstWhere(
          (f) => f.label == this,
      orElse: () => Fiqa.Deobandi,
    );
  }
}


extension RoleExtension on Role {
  String get label {
    switch (this) {
      case Role.visitor:
        return 'Visitor';
      case Role.imam:
        return 'Imam';
    }
  }
}
extension StringToRole on String {
  Role toRole() {
    return Role.values.firstWhere(
          (r) => r.label == this,
      orElse: () => Role.visitor,
    );
  }
}

