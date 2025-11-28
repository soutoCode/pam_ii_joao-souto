import 'package:flutter/material.dart';

class UserSection extends StatelessWidget{
  final String title;
  final Widget child;

  const UserSection({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      spacing:8,
      children:[
        Text(
          title,
          style:Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight:FontWeight.w600,
          ),
        ),
        child,
      ],
    );
  }
}
