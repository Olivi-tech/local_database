import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database_helper.dart';
import 'student.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider<database_helper>(
          create: (context) => database_helper(),
          child: const MyHomePage(title: 'Flutter Demo Home Page')),
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
  @override
  Widget build(BuildContext context) {
    var dbHelper = context.read<database_helper>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Consumer<database_helper>(
          builder: (context, value, child) => FutureBuilder<List<Student>>(
            future: value.fetchStudent(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      child: Text(snapshot.data![index].rollNo.toString()),
                    ),
                    title: Text(snapshot.data![index].name.toString()),
                    trailing: Text(snapshot.data![index].fee.toString()),
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showGeneralDialog(
            context: context,
            pageBuilder: (context, animation, secondaryAnimation) {
              TextEditingController _controllerRollNo = TextEditingController();
              TextEditingController _controllerName = TextEditingController();
              TextEditingController _controllerFee = TextEditingController();
              FocusNode focusNode = FocusNode();
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextField(
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Roll No',
                            hintText: 'RollNo'),
                        controller: _controllerRollNo,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter Name',
                            hintText: 'Name'),
                        controller: _controllerName,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter Fee',
                            hintText: 'Fee'),
                        controller: _controllerFee,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                var isOk = await dbHelper.insertStudent(Student(
                                    rollNo: int.parse(_controllerRollNo.text),
                                    name: _controllerName.text,
                                    fee: double.parse(_controllerFee.text)));
                                _controllerRollNo.clear();
                                _controllerName.clear();
                                _controllerFee.clear();

                                focusNode.requestFocus();
                                if (isOk) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Success'),
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Failed'),
                                  ));
                                }
                              },
                              child: const Text('insert')),
                          ElevatedButton(
                              onPressed: () async {
                                var isOk = await dbHelper.updateStudent(
                                  Student(
                                      rollNo: int.parse(_controllerRollNo.text),
                                      name: _controllerName.text,
                                      fee: double.parse(_controllerFee.text)),
                                );
                                if (isOk) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('upDated'),
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Failed'),
                                  ));
                                }
                              },
                              child: const Text('Update')),
                          ElevatedButton(
                              onPressed: () async {
                                var isOk = await dbHelper.deleteStudent(Student(
                                    rollNo: int.parse(_controllerRollNo.text),
                                    name: _controllerName.text,
                                    fee: double.parse(_controllerFee.text)));
                                _controllerRollNo.clear();
                                _controllerName.clear();
                                _controllerFee.clear();
                                if (isOk) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Deleted'),
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Failed'),
                                  ));
                                }
                              },
                              child: const Text('Delete')),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('clear')),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
