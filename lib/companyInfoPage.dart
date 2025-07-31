import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CompanyMapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('매장 정보',style: TextStyle(color: Colors.brown,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.orange.shade200,
      ),
      body: Column(
        children: [
          // 지도 영역
          SizedBox(
            height: 300,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(37.5714, 126.9769), // 광화문 좌표
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.yourapp',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(37.5714, 126.9769), // 광화문 마커
                      width: 40,
                      height: 40,
                      child: Icon(Icons.location_pin, size: 40, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 매장 정보
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                ListTile(
                  leading: Icon(Icons.access_time),
                  title: Text('영업시간'),
                  subtitle: Text('매일 오전 9시 ~ 오후 9시'),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text('매장 위치'),
                  subtitle: Text('서울특별시 종로구 세종대로 175 (광화문)'),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text('전화번호'),
                  subtitle: Text('02-1234-5678'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
