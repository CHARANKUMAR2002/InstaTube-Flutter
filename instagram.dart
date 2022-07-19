import 'package:fluent_ui/fluent_ui.dart';
import 'package:direct_link/direct_link.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'dart:io';
import 'dart:io' show Platform;

class Instagram extends StatefulWidget {
  const Instagram({Key? key}) : super(key: key);

  @override
  _InstagramState createState() => _InstagramState();
}

class _InstagramState extends State<Instagram> {

  TextEditingController link = TextEditingController();
  TextEditingController name = TextEditingController();
  var extention;
  String filetype = "File Type";
  double progress = 0.0;

  permission() async{
    var status = await Permission.storage.status;
    if(status.isDenied){
      Permission.storage.request();
    }else{
      print("Granted");
    }
  }

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
    } else if(filetype == "File Type"){
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
    var url = await DirectLink.check(link.text);
    print(url);
    for (var element in url!) {
      print(element.link);
      final dio = Dio();
      if (Platform.isWindows) {
        var Path = Directory.current.path;
        final file = File("${Path}/${name.text}.$extention");
        print(Path);
        var result = await dio.get(element.link, options: (Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        )
        ),
            onReceiveProgress: (downloaded, total) {
              setState(() {
                var percent = downloaded / total * 100;

                progress = percent;
                print(progress);
              });
            }
        );
        final f = file.openSync(mode: FileMode.WRITE);
        f.writeFromSync(result.data);
        await f.close();
        print("Done");
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
        final file = File("$Path/${name.text}.$extention");
        print(Path);
        var result = await dio.get(element.link, options: (Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        )
        ),
            onReceiveProgress: (downloaded, total) {
              setState(() {
                var percent = downloaded / total * 100;
                progress = percent;
                print(progress);
              });
            }
        );
        final f = file.openSync(mode: FileMode.WRITE);
        f.writeFromSync(result.data);
        await f.close();
        print("Done");
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
  }

  @override
  void initState() {
    permission();
  }

  @override

  Widget build(BuildContext context) {
    return Acrylic(
      child: ScaffoldPage(
        content: ListView(
          controller: ScrollController(),
          children: [
            Center(child: Image(image: AssetImage("images/logo.png"))),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              color: Colors.transparent,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: [
                      Color(0xFF673AB7),
                      Color(0xFFE91E63),
                      Color(0xFFFF5722),
                      Color(0xFFFFEB3B),
                    ],
                      begin: FractionalOffset.topRight,
                      end: FractionalOffset.bottomLeft,
                    ),

                  ),
                  height: 300,
                  width: 400,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      TextBox(
                        placeholder: "Instagram Link",
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
      title: const Text('PNG'),
      onTap: () => setState(() {
        filetype = "PNG";
        extention = 'png';
      }),
      ),
      DropDownButtonItem(
      title: const Text('MP4'),
      onTap: () => setState(() {
        filetype = "MP4";
        extention = 'mp4';
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
