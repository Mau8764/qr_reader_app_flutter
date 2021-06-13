import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/bloc/scans_bloc.dart';
import 'package:qr_reader_app/src/models/scan_model.dart';
import 'package:qr_reader_app/src/pages/direcciones_page.dart';
import 'package:qr_reader_app/src/pages/mapas_pages.dart';
import 'package:qr_reader_app/src/utils/utils.dart' as utils;

import 'package:qrcode_reader/qrcode_reader.dart';
//import 'package:qrcode_reader/QRCodeReader.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc= new ScansBloc();
  int currentIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed:scansBloc.borrarScansTODOS,
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: _scanQR,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

    _scanQR() async {


      //https://google.com.ni
      //geo:40.73672099790078,-73.76149549921878
      String futureString;
      try{  
       futureString= await new QRCodeReader().scan();

      }catch(e){
        futureString=e.toString();
      }
      if (futureString != null){
        final scan= ScanModel( valor : futureString);
        scansBloc.agregarScan(scan);
        
        utils.abrirScan(context,scan);
      }
    }

  Widget _callPage(int paginaActual){
    switch(paginaActual){
      case 0: return MapasPage(); 
      case 1: return DireccionesPage();

      default: return MapasPage();
    }
  }

  Widget _crearBottomNavigationBar(){
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index){
        setState(() {
          currentIndex=index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title:Text('Mapas')
        ),
         BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title:Text('Direcciones')
        ),
      ],
    );
  }
}