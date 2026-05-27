import 'package:flutter/material.dart';
import './app_colors.dart'; 

class TextFields extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextEditingController? controller; 

  final String? Function(String?)? validator;

  const TextFields({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false, 
    this.keyboardType = TextInputType.text,
    this.controller,
    this.validator,
  });

  @override
  State<TextFields> createState() => _TextFieldsState();
}

class _TextFieldsState extends State<TextFields> {
  late bool _hideText;

  @override
  void initState() {
    super.initState();
    _hideText = widget.isPassword; 
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _hideText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: AppColors.hintText),
        filled: true,
        fillColor: AppColors.inputBackground,
        prefixIcon: Icon(widget.prefixIcon, color: Colors.blueGrey),
        
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _hideText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.blueGrey,
                ),
                onPressed: () {
                  setState(() {
                    _hideText = !_hideText;
                  });
                },
              )
            : null,
            
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}