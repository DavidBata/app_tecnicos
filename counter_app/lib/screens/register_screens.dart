import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

void main() => runApp( MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RegisterScreen(),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

  
  
  class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
    var Cimask = MaskTextInputFormatter(mask: '########', filter: { "#": RegExp(r'[4-9]') });
   // var Usermask = MaskTextInputFormatter(mask: '########', filter: { "#": RegExp(r'[1-9]') });



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            const SizedBox(height: 8),
            const Divider(color: Colors.black),
            _cajaRoja(size),
            _logo(),
            _registerForm(context),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 253, 97, 97),
        title: const Text('Registro'),
        elevation: 8,
      ),
    );
  }

  SingleChildScrollView _registerForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 130),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 30,
                  offset: Offset(5, 7),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 5),
                Text(
                  'Registro',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildTextField1(
                        labelText: 'Usuario',
                        prefixIcon: Icons.person,
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField2(
                        
                        labelText: 'Cedula',
                        prefixIcon: Icons.credit_card_outlined,
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      _buildPasswordField(),
                      const SizedBox(height: 20),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        disabledColor: Colors.grey,
                        color: Colors.red,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 80,
                            vertical: 15,
                          ),
                          child: const Text(
                            'Registrarse',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                    // Validar el formulario antes de realizar la acción
                    if (_formKey.currentState?.validate() ?? false) {
                      // Puedes añadir lógica para manejar el botón aquí
                    } else {
                      // Muestra una alerta si hay campos vacíos
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Alerta'),
                            content: const Text('Por favor, llene todos los campos del Formulario correctamente'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        }
                      );
                    }
                   }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildTextField1({
    required String labelText,
    IconData? prefixIcon,
    bool? obscureText,
  }) {
    return TextFormField(
      //inputFormatters: [Usermask],
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      validator: (value) {
      if (value == null || value.isEmpty) {
          return 'Campo vacío';
        }
        if (value.length < 4) {
          return 'Caracteres insuficientes';
        }
        return null;
     },
    );
  }
  Widget _buildTextField2({
    required String labelText,
    IconData? prefixIcon,
    bool? obscureText,
  }) {
    return TextFormField(
      inputFormatters: [Cimask],
      keyboardType : TextInputType.number,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo vacío';
        }
        if (value.length < 4) {
          return 'Caracteres insuficientes';
        }
        return null;
      },
    );
  }
  

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: _obscureText,
      controller: _passwordController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        labelText: 'Contraseña',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Campo vacío';
      }
     if (value.length  < 6) {
          return 'Caracteres insuficientes';
        }
        return null;
    },
    
    );
  }

  Container _cajaRoja(Size size) {
    return Container(
      color: Colors.red,
      width: double.infinity,
      height: size.height * 0.4,
    );
  }

  SafeArea _logo() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        width: double.infinity,
        child: const Icon(
          Icons.person_pin,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}
//builder: (context) => const HtScreens(),
