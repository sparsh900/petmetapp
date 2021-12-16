enum Professions { vet, petGroomer, trainer, hostel }

extension ProfessionsExtension on Professions {
  String get string {
    switch (this) {
      case Professions.petGroomer:
        return 'groomers';
      case Professions.trainer:
        return 'trainers';
      case Professions.vet:
        return 'vet';
      case Professions.hostel:
        return 'hostel';
      default:
        return null;
    }
  }
}

enum Categories {
  deworming,
  vaccine,
  consultation,
}

extension CategoriesExtension on Categories {
  String get string {
    switch (this) {
      case Categories.consultation:
        return 'consultation';
      case Categories.deworming:
        return 'deworming';
      case Categories.vaccine:
        return 'vaccine';
      default:
        return null;
    }
  }
}

enum Filters { home, clinic, video, chat, onlyClinic, onlyHome, online, atMyHome, atTrainingCentre }

extension FiltersExtension on Filters {
  String get string {
    switch (this) {
      case Filters.chat:
        return 'chat';
      case Filters.clinic:
        return 'at clinic';
      case Filters.home:
        return 'at my home';
      case Filters.video:
        return 'video';
      case Filters.onlyHome:
        return 'home';
      case Filters.onlyClinic:
        return 'clinic';
      case Filters.online:
        return 'online';
      case Filters.atMyHome:
        return 'at my home';
      case Filters.atTrainingCentre:
        return 'at training centre';
      default:
        return null;
    }
  }
}
