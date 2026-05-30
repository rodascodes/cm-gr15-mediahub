import 'package:flutter/material.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: widget.controller,
      obscureText: _hideText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      style: TextStyle(
        fontSize: 16,
        color: isDark ? Colors.white : Colors.black, 
      ),

      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
        filled: true,
        fillColor: isDark ? const Color.fromARGB(255, 40, 40, 40) : Colors.grey[100],
        prefixIcon: Icon(widget.prefixIcon, color: isDark ? Colors.grey[400] : Colors.blueGrey),
        
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _hideText ? Icons.visibility_off : Icons.visibility,
                  color: isDark ? Colors.grey[400] : Colors.blueGrey,
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
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}