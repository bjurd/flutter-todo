import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget
{
  final double? width;
  final String text;

  final Function? onPressed;

  const PrimaryButton({
    super.key,
    this.width,
    required this.text,
    this.onPressed
  });

  @override
  PrimaryButtonState createState() => PrimaryButtonState();
}

class PrimaryButtonState extends State<PrimaryButton>
{
  bool _isTapped = false;

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTapDown: (event)
      {
        setState( ()
        {
          _isTapped = true;
        });
      },

      onTapUp: (event)
      {
        setState( ()
        {
          _isTapped = false;
        });
      },

      onTapCancel: ()
      {
        setState( ()
        {
          _isTapped = false;
        });
      },

      child: Container(
        width: widget.width ?? double.infinity,
        child: ElevatedButton(
          onPressed: ()
          {
            if (widget.onPressed != null)
            {
              widget.onPressed!();
            }
          },

          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(10),

            foregroundColor: Colors.white,
            backgroundColor: _isTapped ? Colors.orange[600] : Colors.orange[700],

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),

          child: Text(
            widget.text,

            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
