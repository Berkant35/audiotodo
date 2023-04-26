import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ContentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double padding;
  final double radius;

  const ContentAppBar({
    Key? key,
    required this.title,
    this.padding = 16.0,
    this.radius = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(50),
            bottomLeft: Radius.circular(50)),
        child: AppBar(
          backgroundColor: Colors.green,
          // Arka plan rengi yeşil
          centerTitle: true,
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.only(left: padding),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  // Buraya menü iconunun tıklama işlemini ekleyebilirsiniz.
                },
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: padding),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Buraya arama iconunun tıklama işlemini ekleyebilirsiniz.
                  },
                ),
              ),
            ),
          ],
          title: Container(
            width: MediaQuery.of(context).size.width *
                0.65, // Genişlik yüzde 65'i kadar
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center, // Başlığın ortalanması
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
