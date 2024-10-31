import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDWMknuQz18SDkHyTzOl4J6CARmvljV0JA",
      authDomain: "churchdev-c4747.firebaseapp.com",
      databaseURL: "https://churchdev-c4747.firebaseio.com",
      projectId: "churchdev-c4747",
      storageBucket: "churchdev-c4747.appspot.com",
      messagingSenderId: "3885603972",
      appId: "1:3885603972:web:b31c68ab6fbb6dcbe0f6d1",
      measurementId: "G-GR95XFMP2E",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _indexController =
      TextEditingController(); // chapterList 인덱스 입력 컨트롤러
  final TextEditingController _quotaIndexController =
      TextEditingController(); // quotaList 인덱스 입력 컨트롤러

  // chapterList를 불러오는 함수
  Future<void> fetchChapterListByPid(String pid) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('FixedPlans')
          .where('pid', isEqualTo: pid) // pid 필드를 기준으로 검색
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final document = querySnapshot.docs.first;
        final data = document.data();

        if (data.containsKey('chapterList')) {
          final List<dynamic> chapterList = data['chapterList'];

          for (int i = 0; i < chapterList.length; i++) {
            print('${i}. ${chapterList[i]}');
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Chapter List 불러오기가 완료되었습니다.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('chapterList 필드가 없습니다.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('pid에 해당하는 문서를 찾을 수 없습니다.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('chapterList를 가져오는 중 오류 발생: $e')),
      );
    }
  }

  // quotaList를 불러오는 함수
  Future<void> fetchQuotaListByPid(String pid) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('FixedPlans')
          .where('pid', isEqualTo: pid) // pid 필드를 기준으로 검색
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final document = querySnapshot.docs.first;
        final data = document.data();

        if (data.containsKey('quotaList')) {
          final List<dynamic> quotaList = data['quotaList'];

          for (int i = 0; i < quotaList.length; i++) {
            print('${i}. ${quotaList[i]}');
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Quota List 불러오기가 완료되었습니다.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('quotaList 필드가 없습니다.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('pid에 해당하는 문서를 찾을 수 없습니다.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('quotaList를 가져오는 중 오류 발생: $e')),
      );
    }
  }

  // quotaList에서 특정 인덱스 이후 값을 +1 하는 함수
  Future<void> incrementQuotaListAfterIndex(String pid, int index) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('FixedPlans')
          .where('pid', isEqualTo: pid) // pid 필드를 기준으로 검색
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final document = querySnapshot.docs.first;
        final docRef = document.reference; // 문서 참조
        final data = document.data();

        if (data.containsKey('quotaList')) {
          final List<dynamic> quotaList =
              List.from(data['quotaList']); // 기존 리스트 가져오기

          if (index >= 0 && index < quotaList.length) {
            for (int i = index; i < quotaList.length; i++) {
              if (quotaList[i] is int) {
                quotaList[i] = quotaList[i] + 1; // 값 증가
              }
            }

            await docRef.update({'quotaList': quotaList});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Quota List의 $index 이후 값이 +1 되었습니다.')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('지정된 인덱스가 리스트 범위를 벗어났습니다.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('quotaList 필드가 없습니다.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('pid에 해당하는 문서를 찾을 수 없습니다.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('quotaList를 업데이트하는 중 오류 발생: $e')),
      );
    }
  }

  // chapterList에 값을 특정 위치에 추가하는 함수
  Future<void> addChapterAtPosition(
      String pid, String newChapter, int index) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('FixedPlans')
          .where('pid', isEqualTo: pid) // pid 필드를 기준으로 검색
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final document = querySnapshot.docs.first;
        final docRef = document.reference; // 문서 참조
        final data = document.data();

        if (data.containsKey('chapterList')) {
          final List<dynamic> chapterList =
              List.from(data['chapterList']); // 기존 리스트 가져오기

          if (index >= 0 && index <= chapterList.length) {
            chapterList.insert(index, newChapter);
            await docRef.update({'chapterList': chapterList});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('새로운 chapter가 $index 위치에 추가되었습니다.')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('지정된 인덱스가 리스트 범위를 벗어났습니다.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('chapterList 필드가 없습니다.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('pid에 해당하는 문서를 찾을 수 없습니다.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('chapterList를 업데이트하는 중 오류 발생: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => fetchChapterListByPid('kcFfOUg9R2VverIwOCmm'),
              child: Text('Chapter List 불러오기'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => fetchQuotaListByPid('kcFfOUg9R2VverIwOCmm'),
              child: Text('Quota List 불러오기'),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _indexController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Chapter List 삽입할 인덱스 입력',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                int index = int.parse(_indexController.text);
                addChapterAtPosition(
                    'kcFfOUg9R2VverIwOCmm', 'New Chapter Title', index);
              },
              child: Text('입력된 위치에 Chapter 추가하기'),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _quotaIndexController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quota List에서 인덱스 입력',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                int index = int.parse(_quotaIndexController.text);
                incrementQuotaListAfterIndex('kcFfOUg9R2VverIwOCmm', index);
              },
              child: Text('Quota List에서 해당 인덱스 이후 값 +1 하기'),
            ),
          ],
        ),
      ),
    );
  }
}
