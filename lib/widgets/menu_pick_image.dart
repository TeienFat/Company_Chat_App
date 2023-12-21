import 'package:flutter/material.dart';

class MenuPickImage extends StatelessWidget {
  const MenuPickImage({super.key, required this.onPickImage});
  final Function(bool type) onPickImage;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight / 5,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(
                      iconSize: 100,
                      onPressed: () {
                        Navigator.pop(context);
                        onPickImage(true);
                      },
                      icon: Icon(Icons.camera),
                    ),
                    Text(
                      "Máy ảnh",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      iconSize: 100,
                      onPressed: () {
                        Navigator.pop(context);
                        onPickImage(false);
                      },
                      icon: Icon(Icons.image),
                    ),
                    Text(
                      "Thư viện",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
