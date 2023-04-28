import 'package:flutter/material.dart';
import 'package:flutterproje/DetaySayfa.dart';
import 'package:flutterproje/KelimelerDao.dart';

import 'Kelimeler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});





  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
   bool aramaYapiliyorMu=false;
   String aramaKelimesi="";
   Future<List<Kelimeler>> tumKelimelerGoster() async{
     var kdao=KelimelerDao();
     var kelimelerListesi=await kdao.tumKelimeler();
     return kelimelerListesi;
   }
   Future<List<Kelimeler>> aramaYap(String aramaKelimesi) async{
     var kdao=KelimelerDao();
     var kelimelerListesi=await kdao.kelimeAra(aramaKelimesi);
     return kelimelerListesi;
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: aramaYapiliyorMu ? TextField(decoration:InputDecoration(hintText:"Arama için birşey yazın"),
            onChanged:(aramaSonucu){
          print("Arama Sonucu:$aramaSonucu");
          setState(() {
            aramaKelimesi=aramaSonucu;
          });
        }): Text("Sözlük Uygulaması"),
        actions:[
          aramaYapiliyorMu?
          IconButton(
            icon:Icon(Icons.cancel),
            onPressed:(){
              setState(() {
                aramaYapiliyorMu=false;
                aramaKelimesi="";
              });
            },
          )
              : IconButton(
                icon:Icon(Icons.search),
                onPressed:(){
                setState(() {
                 aramaYapiliyorMu=true;
                });
              },
              ),
              ],
      ),
      body: FutureBuilder<List<Kelimeler>>(
        future:aramaYapiliyorMu ? aramaYap(aramaKelimesi) : tumKelimelerGoster(),
        builder:(context,snapshot){
          if(snapshot.hasData){
              var kelimelerListesi=snapshot.data;
              return ListView.builder(
                itemCount:kelimelerListesi!.length,
                itemBuilder:(context,indeks){
                    var kelime=kelimelerListesi[indeks];
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>DetaySayfa(kelime: kelime,)));
                      },
                      child: SizedBox(height:50,
                        child: Card(
                          child:Row(
                            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(kelime.ingilizce,style:TextStyle(fontWeight:FontWeight.bold)),
                              Text(kelime.turkce)
                            ],
                          ),
                        ),
                      ),
                    );
                },
              );
          }else{
            return Center();
          }
        }
      ),

    );
  }
}
