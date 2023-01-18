import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: const InputPage(),
    );
  }
}

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anonymous Chat Wa'),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height / 2,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _numberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor tidak boleh kosong';
                  } else if (value.length < 6) {
                    return 'Nomor terlalu pendek';
                  } else if (value.length > 15) {
                    return 'Nomor terlalu panjang';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: '081234567890',
                  labelText: 'Masukkan nomor',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue[50]!),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Pesan tidak boleh kosong';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Halo saya adalah anonymous chat wa',
                  labelText: 'Tulis pesan',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue[50]!),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        preview();
                      }
                    },
                    icon: const Icon(Icons.send),
                    label: const Text('Kirim'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      clearMesasge();
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Hapus'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  preview() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          titleTextStyle: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          title: const Text('Pratinjau Pesan'),
          content: GestureDetector(
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: _messageController.text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Color.fromARGB(255, 136, 255, 140),
                  content: Text('Pesan berhasil disalin'),
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      'Nomor Tujuan : ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(217, 255, 255, 255),
                      ),
                    ),
                    Text(
                      _numberController.text,
                      style: const TextStyle(
                        color: Color.fromARGB(249, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 0.5, color: Colors.white),
                  ),
                  child: Text(
                    'Pesan : ${_messageController.text}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(217, 255, 255, 255),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Tekan lama kotak pesan untuk salin',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                )
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: sendMessage,
              child: const Text('Kirim'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Batal',
                style: TextStyle(color: Color.fromARGB(255, 187, 182, 182)),
              ),
            ),
          ],
        );
      },
    );
  }

  sendMessage() async {
    final Uri url = Uri.parse(
        'https://wa.me/62${_numberController.text}?text=${_messageController.text}');

    if (_formKey.currentState!.validate()) {
      launch(url.toString());
    }
  }

  clearMesasge() {
    _numberController.clear();
    _messageController.clear();
  }
}
