import 'package:permission_handler/permission_handler.dart';
import 'package:petmet_app/app/home/models/appointment.dart';
import 'package:petmet_app/app/professionals_workers/variantsAndConfig/variants.dart';
import 'package:petmet_app/services/database.dart';

import 'locationFunctions.dart';

class MiniRepo{

  MiniRepo({this.database});

  final LocationFunctions locationRepo=LocationFunctions();
  List listOfWorkers=[];
  List<Appointment> appointments=[];
  List listWithDifference=[];
  final Database database;


  List sort(double distanceInKM, bool isHomeVisit,bool isVisitClinic,bool isChat,bool isVideo){

    // f(a, b, c, d, e, f, g, h) = a'b'c'd' + a'b'c'h + a'b'd'g + a'b'gh + a'c'd'f + a'c'fh + a'd'fg + a'fgh + b'c'd'e + b'c'eh + b'd'eg + ab'cef'gh' + efgh + c'd'ef + c'efh + d'efg

    //min-terms
    // https://www.charlie-coleman.com/experiments/kmap/
    // head over to the above site and paste the below min terms
    //0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,17,19,21,23,25,27,29,31,34,35,38,39,42,43,46,47,51,55,59,63,68,69,70,71,76,77,78,79,85,87,93,95,102,103,110,111,119,127,136,137,138,139,140,141,142,143,153,155,157,159,170,171,174,175,186,191,204,205,206,207,221,223,238,239,255

    bool a=isChat;
    bool b=isVideo;
    bool c=isHomeVisit;
    bool d=isVisitClinic;


    List sortedList=[];
    for(var worker in listWithDifference)
    {
      print(worker.toString());
      if(worker["calculatedLocationData"]["value"] < distanceInKM*1000){

      bool e = worker["workerData"].isChat;
      bool f = worker["workerData"].isVideo;
      bool g = worker["workerData"].isHomeVisit;
      bool h = worker["workerData"].isVisitClinic;

      print(a);
      print(b);
      print(c);
      print(d);
      print(e);
      print(f);
      print(g);
      print(h);

      if((!a && !b && !c && !d) || (!a && !b && !c && h) || (!a && !b && !d && g) || (!a && !b && g && h) || (!a && !c && !d && f) || (!a && !c && f && h) || (!a && !d && f && g) || (!a && f && g && h) || (!b && !c && !d && e) || (!b && !c && e && h) || (!b && !d && e && g) || (a && !b && c && e && !f && g && !h) || (e && f && g && h) || (!c && !d && e && f) || (!c && e && f && h) || (!d && e && f && g)){
        print("Adding");
        sortedList.add(worker);
        }
      }
    }
    return sortedList;
  }

  Future<void> getListFromDatabase(String profession,String category) async{
    print("Getting Info from FireStore");


    String fieldName;
    if(category==Categories.deworming.string){
        fieldName='isDeworming';
    }else if(category==Categories.vaccine.string){
        fieldName='isVaccine';
    }else if(category==Categories.consultation.string){
        fieldName='isDeworming';
    }else if(category==Filters.home.string){
       fieldName='isHomeVisit';
    }else if(category==Filters.clinic.string){
       fieldName='isVisitClinic';
    }



    //The decision for taking Lists instead of Streams(with live data facility) is because of Change of Location feature.
    // Streams are difficult to be sorted and filtered again again....
    //Therefore, developer implemented pull to refresh and decided to go with Lists
    //In the app, wherever sorting/filtering is present ,Lists are used.

    print("HERE");
    if(profession == Professions.vet.string){
      listOfWorkers = await database.listOfVets(profession,fieldName);
      listOfWorkers.removeWhere((element) => element.isOnline==false);
    }else if(profession == Professions.petGroomer.string ){
      listOfWorkers = await  database.listOfGroomers();
    }else if(profession == Professions.hostel.string){
      print("HERE ---- PROFESSION hOSTEL");

      listOfWorkers = await database.listOfHostels();
    }


    return null;
  }




  Future<List> sortAccordingToDistance(Map<String, dynamic> locationData) async{
      print("Generating and sorting distance accordingly");
      List dataToReturn = [];
      for (var worker in listOfWorkers) {
        //Getting other Vets to display with distance calculated
        Map<String, dynamic> dataMap = Map<String, dynamic>();
        Map<String, dynamic> extraData = await locationRepo.getRouteDistance(locationData, worker.locationData);
        dataMap["calculatedLocationData"] = extraData;
        dataMap["workerData"] = worker;
        if (dataMap["calculatedLocationData"] == null) continue;
        //to add according to distance
        int i = 0;
        for (; i < dataToReturn.length; i++) {
          if (dataToReturn[i]["calculatedLocationData"]["value"] > dataMap["calculatedLocationData"]["value"]) {
            break;
          }
        }
        dataToReturn.insert(i, dataMap);
      }
      listWithDifference=dataToReturn;
      return await null;
  }

  Future<int> changePermissionBit() async {
    var status = await Permission.location.status;
    int bit = 100;
    switch (status) {
      case PermissionStatus.granted:
        break;
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
      case PermissionStatus.undetermined:
      case PermissionStatus.denied:
        bit += 10;
        break;
      default:
    }
    if (!(await Permission.location.serviceStatus.isEnabled)) {
      bit += 1;
    }
    return bit;
  }
}