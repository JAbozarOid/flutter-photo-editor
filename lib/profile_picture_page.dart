import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class ProfilePicturePage extends StatefulWidget {
  const ProfilePicturePage({Key? key}) : super(key: key);

  @override
  _ProfilePicturePageState createState() => _ProfilePicturePageState();
}

class _ProfilePicturePageState extends State<ProfilePicturePage> {
  double _scale = 1.0;
  //double x = 1.0;
  //double y = 1.0;
  double _previousScale = 1.0;
  double _continuousValue = 1.0;
  bool isCropped = true;

  late MemoryImage mImage;

  late CustomImageCropController controller;

  @override
  void initState() {
    super.initState();
    controller = CustomImageCropController();
  }

  @override
  Widget build(BuildContext context) {
    //print("x is: $x");
    //print("y is: $y");
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile Picture"),
        ),
        body: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: InteractiveViewer(
                    child: GestureDetector(
                      onScaleStart: (ScaleStartDetails details) {
                        print(details);
                        _previousScale = _scale;
                        _continuousValue = getContinuousValue(_previousScale);
                        setState(() {});
                      },
                      onScaleUpdate: (ScaleUpdateDetails details) {
                        //x = details.localFocalPoint.dx;
                        //y = details.localFocalPoint.dy;
                        _scale =
                            getContinuousValue(_previousScale * details.scale);
                        _continuousValue = getContinuousValue(_scale);
                        setState(() {});
                      },
                      onScaleEnd: (ScaleEndDetails details) {
                        print(details);
                        _previousScale = 1.0;
                        //_continuousValue = _previousScale;
                        setState(() {});
                      },
                      child: isCropped
                          ? Transform(
                              alignment: FractionalOffset.center,
                              transform: Matrix4.diagonal3(
                                  Vector3(_scale, _scale, _scale)),
                              child: CustomImageCrop(
                                cropPercentage: 0.5,
                                cropController: controller,
                                // image: const AssetImage('assets/test.png'), // Any Imageprovider will work, try with a NetworkImage for example...
                                image: AssetImage('assets/abozar1.png'
                                      
                                    //'https://images.unsplash.com/photo-1578253809350-d493c964357f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1400&q=80',
                                    //scale: 0.5
                                    ),
                                shape: CustomCropShape.Square,
                              ),
                              /* CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl:
                              "https://images.unsplash.com/photo-1578253809350-d493c964357f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1400&q=80",
                        ), */
                            )
                          : Center(
                              child: Column(
                                children: [
                                  const Spacer(),
                                  Image(
                                    image: mImage,
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
                /* isCropped
                    ? IgnorePointer(
                        ignoring: true,
                        child: 
                        Container(
                          width: double.infinity,
                          height: 250,
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Container(
                              width: 200.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                          ),
                        ),
                      )
                    : Container(), */
              ],
            ),
            Slider(
              value: _continuousValue,
              min: 1.0,
              max: 5.0,
              onChanged: (value) {
                setState(() {
                  _continuousValue = value;
                  _scale = getContinuousValue(_continuousValue);
                });
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: Colors.white,
                backgroundColor: Colors.grey,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () async {
                if (isCropped) {
                  final image = await controller.onCropImage();
                  if (image != null) {
                    print("<<<<<<<<<<<<<<<$image>>>>>>>>>>>>>>>>>>");
                    mImage = image;
                  }
                }
                isCropped = (!(isCropped));
                setState(() {});
              },
              child: const Text('Crop Photo'),
            ),
          ],
        ));
  }

  double getContinuousValue(double value) {
    return (value < 1)
        ? 1
        : (value > 5)
            ? 5
            : value;
  }

  /* cropImage() {
    isCropped = (!(isCropped));
    setState(() {});
  } */
}
