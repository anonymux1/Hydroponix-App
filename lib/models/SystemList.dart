import 'System.dart';

class SystemList {
  List<System>? systemList;

  SystemList(
      this.systemList
      );

   List<System>? getSystemList()
  {
    return systemList;
  }

  factory SystemList.fromFirestore(Map<String, dynamic> json) {
      List list = (json as Map<String,dynamic>?)?['Systems'];
      final objects = list.map((e) => e as Map<String,dynamic>).toList();
      SystemList sysList = SystemList([]);
      for (Map<String,dynamic> i in objects) {
       System sys = System.fromFirestore(i);
       sysList.systemList?.add(sys);
       }
       return sysList;
   }
    List<Map<String,dynamic>> toFirestore(List<System> systemList)  {
     List<Map<String,dynamic>> l=[];
     int idx=0;
     for(System s in systemList)  {
       l[idx]=s.toFirestore();
     }
     return l;
   }
}