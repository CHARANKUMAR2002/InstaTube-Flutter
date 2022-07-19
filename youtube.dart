import 'package:fluent_ui/fluent_ui.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_parser/youtube_parser.dart';
import 'package:external_path/external_path.dart';

class Youtube extends StatefulWidget {
  const Youtube({Key? key}) : super(key: key);

  @override
  _YoutubeState createState() => _YoutubeState();
}

class _YoutubeState extends State<Youtube> {

  TextEditingController link = TextEditingController();
  TextEditingController name = TextEditingController();
  var extention;
  String filetype = "File Type";
  double progress = 0.0;

  download() async{
    if(link.text == ""){
      showDialog(
          context: context,
          builder: (context) {
            return ContentDialog(
              title: Text('Error'),
              content: Text('Please enter the link !'),
              actions: [
                Button(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                )
              ],
            );
          });
    }else if(name.text == ""){
      showDialog(
          context: context,
          builder: (context) {
            return ContentDialog(
              title: Text('Error'),
              content: Text('Please enter the file name !'),
              actions: [
                Button(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);

                    }
                )
              ],
            );
          });
    }else if(filetype == "File Type"){
      showDialog(
          context: context,
          builder: (context) {
            return ContentDialog(
              title: Text('Error'),
              content: Text('Please select the file type !'),
              actions: [
                Button(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);

                    }
                )
              ],
            );
          });
    }
    else{
      var yt = YoutubeExplode();
      var videoId = getIdFromUrl(link.text);
      var url = await yt.videos.streamsClient.getManifest(videoId);
      var stream = url.muxed.withHighestBitrate();
      var s = yt.videos.streamsClient.get(stream);
      print(stream);
        if (Platform.isWindows) {
          var Path = Directory.current.path;
          final file = File("${Path}/${name.text}.$extention");
          if (file.existsSync()) {
            file.deleteSync();
          }
          var out = file.openWrite(mode: FileMode.writeOnlyAppend);
          var len = stream.size.totalBytes.toDouble();
          double count = 0.0;
          await for (final data in s){
            count +=len;
            setState(() {
              progress = ((count / len )/100).ceilToDouble();
              if(progress > 100.0){
                progress = 100.0;
              }

              print(progress);
            });
            out.add(data);
          }
          out.close();

          showDialog(
            context: context,
            builder: (context) {
              return ContentDialog(
                title: Text('File Downloaded'),
                content: Text('Your file has been downloaded Successfully !'),
                actions: [
                  Button(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          name.text = "";
                          link.text = "";
                          filetype = "File Type";
                          progress = 0.0;
                        });
                      }
                  )
                ],
              );
            },
          );
        } else {
          final Path = await ExternalPath.getExternalStoragePublicDirectory(
              ExternalPath.DIRECTORY_DOWNLOADS);
          final file = File("${Path}/${name.text}.$extention");
          print(Path);

          if (file.existsSync()) {
              file.deleteSync();
            }
            var out = file.openWrite(mode: FileMode.writeOnlyAppend);
            var len = stream.size.totalBytes.toDouble();
            double count = 0.0;
            await for (final data in s){
              count +=len;
              setState(() {
                progress = ((count / len) /100).ceilToDouble();
                if(progress > 100.0){
                  progress = 100.0;
                }
              });

              print(progress);
              out.add(data);
            }
            out.close();
          showDialog(
            context: context,
            builder: (context) {
              return ContentDialog(
                title: Text('File Downloaded'),
                content: Text('Your file has been downloaded Successfully !'),
                actions: [
                  Button(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          name.text = "";
                          link.text = "";
                          progress = 0.0;
                          filetype = "File Type";
                        });
                      }
                  )
                ],
              );
            },
          );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Acrylic(
      child: ScaffoldPage(
        content: ListView(
          controller: ScrollController(),
          children: [
            SizedBox(height: 40,),
            Center(child: Image(image: AssetImage("images/ylogo.png"), fit: BoxFit.fill, height: 130, width: 130,)),
            const SizedBox(height: 40),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFCE1515),
                ),
                height: 300,
                width: 400,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    TextBox(
                      placeholder: "Youtube Link",
                      controller: link,
                      prefix: Container(child: Icon(FluentIcons.link), padding: EdgeInsets.symmetric(horizontal: 10),),
                      suffixMode: OverlayVisibilityMode.editing,
                      suffix: IconButton(icon: Icon(FluentIcons.cancel),onPressed: (){
                        setState(() {
                          link.clear();
                        });
                      },),
                    ),
                    SizedBox(height: 40,),
                    TextBox(
                      placeholder: "File Name",
                      prefix: Container(child: Icon(FluentIcons.rename), padding: EdgeInsets.symmetric(horizontal: 10),),
                      controller: name,
                      suffixMode: OverlayVisibilityMode.editing,
                      suffix: IconButton(icon: Icon(FluentIcons.cancel),onPressed: (){
                        setState(() {
                          name.clear();
                        });
                      },),),
                    SizedBox(height: 20),
                    DropDownButton(
                      title: Text("$filetype"),
                      items: [
                        DropDownButtonItem(
                          title: const Text('MP4'),
                          onTap: () => setState(() {
                            filetype = "MP4";
                            extention = 'mp4';
                          }),
                        ),
                        DropDownButtonItem(
                          title: const Text('MP3'),
                          onTap: () => setState(() {
                            filetype = "MP3";
                            extention = 'mp3';
                          }),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    FilledButton(child: Text("Download"), onPressed: (){download();},style: ButtonStyle(
                        backgroundColor: ButtonState.all(Color(0xF7E5E1EF)), foregroundColor: ButtonState.all(Colors.black)
                    ),),
                    SizedBox(height: 40),
                    ProgressBar(value: progress),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
