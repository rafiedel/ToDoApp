import 'dart:typed_data';

import 'package:flutter/material.dart';

class ViewImages extends StatefulWidget {
  final int initialIndex;
  final List<String> imagesString;
  const ViewImages({super.key, required this.initialIndex, required this.imagesString});

  @override
  State<ViewImages> createState() => _ViewImagesState();
}

class _ViewImagesState extends State<ViewImages> {
  late PageController _pageController; 
  late List<MemoryImage> images;
  bool focusOnImage = false;

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.initialIndex);
    images = widget.imagesString.map(
      (imageString) => MemoryImage(Uint8List.fromList(imageString.codeUnits))
    ).toList();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                focusOnImage = false;
              });
            },
            child: PageView.builder(
              controller: _pageController,
              physics: focusOnImage? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
              itemCount: images.length, 
              itemBuilder: (context, index) {
                MemoryImage image = images[index]; 
                return Hero(
                  tag: '$index',
                  child: InteractiveViewer(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: image
                        )
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Visibility(
            visible: !focusOnImage,
            child: Expanded(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: phoneWidth,
                    height: phoneWidth/3,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: phoneWidth/20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              '«',
                              style: TextStyle(fontSize: phoneWidth / 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          focusOnImage = true;
                        });
                      },
                    ),
                  )
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}
