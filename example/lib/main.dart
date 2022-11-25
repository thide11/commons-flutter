import 'package:commons_flutter/utils/disk_utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Commons flutter test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Commons flutter - Testes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<dynamic> getDiskDatas() async {
    return {
      "appUsed": await DiskUtils.getDiskSpaceUsed(),
      "internalFree": await DiskUtils.getFormatedInternalFreeDiskSpace(),
      "hasSdCard": await DiskUtils.hasExternalDisk(),
      "internalTotal": await DiskUtils.getTotalDiskSpace(),
      'externalFree': await DiskUtils.getFormatedExternalFreeDiskSpace(),
      'externalTotal': await DiskUtils.getFormatedTotalExternalDiskSpace()
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
          future: getDiskDatas(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              final data = snapshot.data! as dynamic;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Uso do disco pelo app:',
                  ),
                   Text(
                    data["appUsed"],
                  ),
                  const Text(
                    'Quantidade de espaço livre e capacidade do disco interno:',
                  ),
                  Text(
                    '${data["internalFree"]}/${data["internalTotal"]}',
                  ),
                  const Text(
                    'Possui cartão de memória?',
                  ),
                  Text(
                    data["hasSdCard"] ? "Sim" : "Não :/",
                  ),
                  if(data["hasSdCard"]) ...[
                    const Text(
                      'Quantidade de espaço livre e capacidade do cartão SD:',
                    ),
                    Text(
                      '${data["externalFree"]}/${data["externalTotal"]}',
                    ),
                  ]
                ],
              );
            }
            if(snapshot.hasError) {
              print(snapshot.error);
              return Text(snapshot.error.toString());
            }
            return const Center(child: CircularProgressIndicator());
          }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
