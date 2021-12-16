import 'package:petmet_app/app/home/delete--vets/templatedDoctors.dart';



class OverlayData {
  const OverlayData({this.options, this.heading,this.type});
  final List<String> options;
  final String heading;
  final String type;
}


class PetCareWidgetAssigner{
  static vet({String title,OverlayData overlayData})=> TemplateVetType(type: "vet",title: title,overlayData: overlayData );
  static petGroomer({String title,OverlayData overlayData})=> TemplateVetType(type: "petGroomer",title: title,overlayData: overlayData,);

  static assign({String type,String title,OverlayData overlayData}){
    if(type=="vet")
        return vet(title: title,overlayData: overlayData);
    else if(type=="petGroomer")
        return petGroomer(overlayData: overlayData,title: title);
  }

}
