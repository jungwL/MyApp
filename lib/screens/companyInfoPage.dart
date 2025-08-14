import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/customAppBar.dart';
import '../widgets/customDrawer.dart';

class CompanyMapPage extends StatefulWidget {
  const CompanyMapPage({super.key});
  @override
  State<CompanyMapPage> createState() => CompanyMapPageState();
}
class CompanyMapPageState extends State<CompanyMapPage> with SingleTickerProviderStateMixin {

  late TabController _tabStoreController;

  @override
  void initState() {
    super.initState();
    _tabStoreController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabStoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: Customdrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    BackButton(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '매장정보',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            fontFamily: 'PlaywriteAUNSW',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 2),
                Divider(
                  height: 1,
                ),
                TabBar(
                  controller: _tabStoreController,
                  labelColor: Colors.brown,
                  indicatorColor: Colors.brown,
                  tabs: const [
                    Tab(text: '광화문점'),
                    Tab(text: '홍대점'),
                    Tab(text: '강남점'),
                    Tab(text: '성수점'),
                  ],
                ),
                const Divider(height: 1),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabStoreController,
              children: const [
                GwmStore(),
                HDStore(),
                GNStore(),
                SungSStore(),
              ],
            ),
          ),

        ],
      ),
    );
  }
}


//광화문점
class GwmStore extends StatefulWidget {
  const GwmStore({super.key});

  @override
  State<GwmStore> createState() => _GwmStoreState();
}

class _GwmStoreState extends State<GwmStore> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                    point: LatLng(37.5714, 126.9769),
                    width: 40,
                    height: 40,
                    child: Icon(Icons.location_pin, size: 40, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
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
    );
  }
}
//홍대점
class HDStore extends StatefulWidget {
  const HDStore({super.key});

  @override
  State<HDStore> createState() => _HDStoreState();
}

class _HDStoreState extends State<HDStore> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(37.5575, 126.9245),
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
                    point: LatLng(37.5575, 126.9245),
                    width: 40,
                    height: 40,
                    child: Icon(Icons.location_pin, size: 40, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
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
                subtitle: Text('서울특별시 마포구 홍익로 123'),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('전화번호'),
                subtitle: Text('02-2222-2222'),
              ),
            ],
          ),
        ),
      ],
    );;
  }
}



//강남점
class GNStore extends StatefulWidget {
  const GNStore({super.key});

  @override
  State<GNStore> createState() => _GNStoreState();
}

class _GNStoreState extends State<GNStore> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(37.4979, 127.0276),
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
                    point: LatLng(37.4979, 127.0276),
                    width: 40,
                    height: 40,
                    child: Icon(Icons.location_pin, size: 40, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
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
                subtitle: Text('서울특별시 강남구 강남대로 456'),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('전화번호'),
                subtitle: Text('02-3333-3333'),
              ),
            ],
          ),
        ),
      ],
    );;
  }
}
//성수점
class SungSStore extends StatefulWidget {
  const SungSStore({super.key});

  @override
  State<SungSStore> createState() => _SungSStoreState();
}

class _SungSStoreState extends State<SungSStore> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(37.5445, 127.0560),
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
                    point: LatLng(37.5445, 127.0560),
                    width: 40,
                    height: 40,
                    child: Icon(Icons.location_pin, size: 40, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
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
                subtitle: Text('서울특별시 성동구 성수동 123'),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('전화번호'),
                subtitle: Text('02-5555-5555'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


