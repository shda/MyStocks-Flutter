import 'package:flutter/material.dart';
import 'package:mystocks/core/interfaces/interface_user_securities.dart';
import 'package:mystocks/core/services.dart';
import 'package:mystocks/data/interface_intermediary.dart';
import 'package:mystocks/data/securities_info.dart';

class _AddUserSecurities extends State<AddUserSecuritiesScene> {

  late Map<String, SecuritiesInfo> _mapSecuritiesInfo = {};

  @override
  void initState() {
    super.initState();
    _requestData();
  }

  Future _requestData() async{
    var intermediary = widget.services.getService<IIntermediary>();
    _mapSecuritiesInfo = await intermediary.requestAllSecuritiesInfo();
    setState(() {

    });
  }
//
  Widget _makeItem(BuildContext context, int index , List<SecuritiesInfo> list){
    SecuritiesInfo info = list[index];
    return GestureDetector(
        onTap: () {
          var userSecurities = widget.services.getService<IUserSecurities>();
          userSecurities.addItem(info.tickerSymbol!);
          Navigator.of(context).pop();
        },
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              const SizedBox(width: 10),
              Text(info.tickerSymbol!),
              const SizedBox(width: 10),
              Text(info.fullName!)
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    List<SecuritiesInfo> list = _mapSecuritiesInfo.values.toList() ;
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Stock"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              // padding: const EdgeInsets.all(8),
              itemCount: _mapSecuritiesInfo.length,
              itemBuilder: (context, index) {
                return _makeItem(context , index , list);
              },
              separatorBuilder: (BuildContext context, int index) =>
              const Divider(height: 4),
            ),
          ),
        ],
      ),
    );
  }
}

class AddUserSecuritiesScene extends StatefulWidget {
  final IServicesCollection services;

  const AddUserSecuritiesScene(
      {super.key, required this.title, required this.services});

  final String title;

  @override
  State<AddUserSecuritiesScene> createState() => _AddUserSecurities();
}