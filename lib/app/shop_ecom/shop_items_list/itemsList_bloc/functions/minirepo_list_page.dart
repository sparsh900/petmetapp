import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:petmet_app/app/home/models/item.dart';
import 'package:petmet_app/services/database.dart';

class MiniRepo{
  final Database database;
  MiniRepo({this.database});
  List<Item> _itemsOriginal=[];
  List<Item> _itemsSorted=[];
  Map<String,dynamic> _dbFilterInfo;

  List<Item> get original => _itemsOriginal;
  List<Item> get sorted => _itemsSorted;
  Map<String,dynamic> get dbFilterInfo => _dbFilterInfo;

  Future<void> getFromDatabase({@required String category}) async{
    _itemsOriginal = await database.itemsList(category);
  }

  void filterAndSort(Map<String,dynamic> filterInfo,int numDecider){
    //Price values are always present hence no worries
    _itemsSorted = _itemsOriginal;
    _itemsSorted = _itemsSorted.where((e) => int.parse(e.details["cost"]) <= filterInfo["maxCost"]  &&  int.parse(e.details["cost"]) >= filterInfo["minCost"] ).toList();

    //check placed on tag based filters
    // bool check(dynamic value) => filterInfo["filterArray"].contains(value);
    //
    // if(filterInfo["filterArray"].length!=0)
    //   _itemsSorted = _itemsSorted.where((e) => e.filterInfo.any(check)).toList();
    bool check(dynamic value) => filterInfo["filterArray"].contains(value);

    if(filterInfo["filterArray"].length!=0){
      List<Item> _tempItemsSorted=[];
      _itemsSorted.forEach((e){
        _tempItemsSorted.add(e);

        List keys=e.filterInfo.keys.toList();
        print(e.details["name"]);
        for(int i=0;i<keys.length;i++){
          print(_dbFilterInfo[keys[i]].any((f)=> check(f)));
          if( _dbFilterInfo[keys[i]].any((f)=> check(f)) && !check(e.filterInfo[keys[i]])){
            _tempItemsSorted.removeLast();
            break;
          }
        }
      });
      _itemsSorted=_tempItemsSorted;
    }

    if(numDecider==0)
      return;
    _itemsSorted.sort((a,b) {
      double aCost = double.parse(a.details["cost"]);
      double bCost = double.parse(b.details["cost"]);
      if(numDecider==1){
        return aCost.compareTo(bCost);
      }
      return bCost.compareTo(aCost);
    });


  }

  Future<void> getFilters() async{
      DocumentSnapshot snapshot = await database.getFilterSnapshot();
      _dbFilterInfo = snapshot.data;
  }

  void refresh(){
    _itemsOriginal=[];
    _itemsSorted=[];
    _dbFilterInfo=null;
  }

}