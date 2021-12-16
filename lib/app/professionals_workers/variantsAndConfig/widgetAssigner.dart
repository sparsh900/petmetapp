import 'package:flutter/cupertino.dart';
import 'package:petmet_app/app/trainers/trainers_main_page.dart';
import 'package:petmet_app/services/database.dart';
import '../templateProfessionalWorkers.dart';
import '../overlays/overlayData.dart';
import 'variants.dart';

class WidgetAssigner {
  static vetWithPhysicalVisitOnly({@required String category, @required OverlayData overlayData}) => TemplateProfessionalWorkers(
        category: category,
        overlayData: overlayData,
        isHomeVisitFilter: true,
        isVisitClinicFilter: true,
        isVideoFilter: false,
        isChatFilter: false,
        title: category,
        isOverlayAgainButton: true,
        isHomeVisitSelected: false,
        isVisitClinicSelected: false,
        isVideoSelected: false,
        isChatSelected: false,
      );
  static vetWithRemoteVisitAlso({@required String category, @required OverlayData overlayData}) => TemplateProfessionalWorkers(
        category: category,
        overlayData: overlayData,
        isHomeVisitFilter: true,
        isVisitClinicFilter: true,
        isVideoFilter: true,
        isChatFilter: true,
        title: category,
        isOverlayAgainButton: true,
        isHomeVisitSelected: false,
        isVisitClinicSelected: false,
        isVideoSelected: false,
        isChatSelected: false,
      );
  static petGroomer({@required String category, @required OverlayData overlayData, @required bool isHomeVisitSelected, @required bool isVisitClinicSelected}) =>
      TemplateProfessionalWorkers(
        category: category,
        overlayData: overlayData,
        isHomeVisitFilter: true,
        isVisitClinicFilter: true,
        isVideoFilter: false,
        isChatFilter: false,
        title: "Pet Grooming",
        isOverlayAgainButton: false,
        isHomeVisitSelected: isHomeVisitSelected,
        isVisitClinicSelected: isVisitClinicSelected,
        isVideoSelected: false,
        isChatSelected: false,
      );

  static hostels({Database database}) => TemplateProfessionalWorkers(
        category: Professions.hostel.string,
        overlayData: OverlayData(profession: Professions.hostel.string),
        isHomeVisitFilter: false,
        isVisitClinicFilter: false,
        isVideoFilter: false,
        isChatFilter: false,
        title: Professions.hostel.string,
        isOverlayAgainButton: false,
        isHomeVisitSelected: false,
        isVisitClinicSelected: false,
        isVideoSelected: false,
        isChatSelected: false,
        database: database,
      );

  static assign({@required String category, @required OverlayData overlayData, Database database}) {
    if (overlayData.profession == Professions.vet.string)
      return vetWithPhysicalVisitOnly(
        overlayData: overlayData,
        category: category,
      );
    // && (category == Categories.vaccine.string || category == Categories.deworming.string)
    // else if( overlayData.profession==Professions.vet.string  && category==Categories.consultation.string)
    //   return vetWithRemoteVisitAlso(overlayData: overlayData,category: category,);

    else if (overlayData.profession == Professions.petGroomer.string && category == Filters.home.string)
      return petGroomer(overlayData: overlayData, category: category, isHomeVisitSelected: true, isVisitClinicSelected: false);
    else if (overlayData.profession == Professions.petGroomer.string && category == Filters.clinic.string)
      return petGroomer(overlayData: overlayData, category: category, isHomeVisitSelected: false, isVisitClinicSelected: true);
    else if (overlayData.profession == Professions.trainer.string) {
      return trainer(database: database, category: category, profession: overlayData.profession, overlayData: overlayData);
    }
  }

  //different from Vets and Groomer uses different fields and pages
  static trainer({@required Database database, @required String category, @required String profession, @required OverlayData overlayData}) =>
      TemplateTrainer(category: category, profession: profession, overlayData: overlayData, database: database);
}
