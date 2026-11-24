import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/endereco_model.dart';
import 'services/cep_service.dart';

void main() {
  runApp(const ConsultaCepApp());
}

class ConsultaCepApp extends StatelessWidget {
  const ConsultaCepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta CEP - ViaCEP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.indigo, width: 2),
          ),
        ),
      ),
      home: const ConsultaCepPage(),
    );
  }
}

class ConsultaCepPage extends StatefulWidget {
  const ConsultaCepPage({super.key});

  @override
  State<ConsultaCepPage> createState() => _ConsultaCepPageState();
}

class _ConsultaCepPageState extends State<ConsultaCepPage> {
  final CepService _cepService = CepService();

  // Controladores individuais para cada campo
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _localidadeController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _dddController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _carregando = false;
  String? _mensagemErro;

  // Lista de CEPs para teste rápido
  final List<Map<String, String>> _cepsExemplo = [
    {'label': 'São Paulo (Sé)', 'cep': '01001-000'},
    {'label': 'Brasília (Plano Piloto)', 'cep': '70040-010'},
    {'label': 'Rio de Janeiro (Copacabana)', 'cep': '22041-001'},
    {'label': 'Salvador (Pelourinho)', 'cep': '40026-280'},
  ];

  Future<void> _consultarCep([String? cepParam]) async {
    final cepParaConsultar = (cepParam ?? _cepController.text).trim();
    final apenasNumeros = cepParaConsultar.replaceAll(RegExp(r'[^0-9]'), '');

    if (apenasNumeros.isEmpty) {
      _mostrarAviso('Por favor, digite um CEP para consultar.', Colors.orange);
      return;
    }

    if (apenasNumeros.length != 8) {
      _mostrarAviso('O CEP deve conter exatamente 8 dígitos numéricos.', Colors.orange);
      return;
    }

    // Fecha o teclado
    FocusScope.of(context).unfocus();

    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });

    try {
      final EnderecoModel endereco = await _cepService.buscarCep(apenasNumeros);

      setState(() {
        _logradouroController.text = endereco.logradouro.isNotEmpty ? endereco.logradouro : 'Não informado';
        _bairroController.text = endereco.bairro.isNotEmpty ? endereco.bairro : 'Não informado';
        _localidadeController.text = endereco.localidade;
        _ufController.text = endereco.uf;
        _complementoController.text = endereco.complemento;
        _dddController.text = endereco.ddd;
      });

      _mostrarAviso('Endereço carregado com sucesso!', Colors.green);
    } catch (e) {
      final erroFormatado = e.toString().replaceAll('Exception: ', '');
      setState(() {
        _mensagemErro = erroFormatado;
      });
      _mostrarAviso(erroFormatado, Colors.redAccent);
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  void _limparCampos() {
    _cepController.clear();
    _logradouroController.clear();
    _bairroController.clear();
    _localidadeController.clear();
    _ufController.clear();
    _complementoController.clear();
    _dddController.clear();
    setState(() {
      _mensagemErro = null;
    });
  }

  void _mostrarAviso(String mensagem, Color cor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: cor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _cepController.dispose();
    _logradouroController.dispose();
    _bairroController.dispose();
    _localidadeController.dispose();
    _ufController.dispose();
    _complementoController.dispose();
    _dddController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Consulta de CEP',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Limpar todos os campos',
            onPressed: _carregando ? null : _limparCampos,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Cartão com instruções e busca de CEP
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.indigo.shade50,
                              child: const Icon(Icons.search, color: Colors.indigo),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Informe o CEP',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Digite 8 dígitos para consultar na API ViaCEP',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _cepController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(8),
                          ],
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) => _consultarCep(),
                          decoration: InputDecoration(
                            labelText: 'CEP',
                            hintText: 'Ex: 01001000',
                            prefixIcon: const Icon(Icons.pin_drop_outlined),
                            suffixIcon: _cepController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _cepController.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 12),
                        // Botões de Ação
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: ElevatedButton.icon(
                                onPressed: _carregando ? null : () => _consultarCep(),
                                icon: _carregando
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.search),
                                label: Text(_carregando ? 'Consultando...' : 'Consultar CEP'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: OutlinedButton.icon(
                                onPressed: _carregando ? null : _limparCampos,
                                icon: const Icon(Icons.clear_all),
                                label: const Text('Limpar'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Chips de teste rápido
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            const Text(
                              'Testar com:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            ..._cepsExemplo.map(
                              (ex) => ActionChip(
                                label: Text(
                                  ex['label']!,
                                  style: const TextStyle(fontSize: 11),
                                ),
                                avatar: const Icon(Icons.location_on, size: 14),
                                visualDensity: VisualDensity.compact,
                                onPressed: _carregando
                                    ? null
                                    : () {
                                        _cepController.text = ex['cep']!.replaceAll('-', '');
                                        setState(() {});
                                        _consultarCep(ex['cep']);
                                      },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                if (_mensagemErro != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _mensagemErro!,
                            style: TextStyle(color: Colors.red.shade800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Seção com os TextFields obrigatórios pelo enunciado:
                // "Atenção: Os dados vindos da api logradouro, bairro, localidade, uf devem estar cada um textfield diferente"
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.location_city, color: Colors.indigo, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Dados do Endereço (ViaCEP)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                ),

                // 1. TextField Logradouro
                TextField(
                  controller: _logradouroController,
                  decoration: const InputDecoration(
                    labelText: 'Logradouro (Rua, Avenida, etc.)',
                    hintText: 'Aguardando consulta...',
                    prefixIcon: Icon(Icons.signpost_outlined),
                  ),
                ),
                const SizedBox(height: 12),

                // 2. TextField Bairro
                TextField(
                  controller: _bairroController,
                  decoration: const InputDecoration(
                    labelText: 'Bairro',
                    hintText: 'Aguardando consulta...',
                    prefixIcon: Icon(Icons.holiday_village_outlined),
                  ),
                ),
                const SizedBox(height: 12),

                // 3. TextField Localidade (Cidade)
                TextField(
                  controller: _localidadeController,
                  decoration: const InputDecoration(
                    labelText: 'Localidade (Cidade)',
                    hintText: 'Aguardando consulta...',
                    prefixIcon: Icon(Icons.location_city_outlined),
                  ),
                ),
                const SizedBox(height: 12),

                // 4. TextField UF (Estado)
                TextField(
                  controller: _ufController,
                  decoration: const InputDecoration(
                    labelText: 'UF (Estado)',
                    hintText: 'Aguardando consulta...',
                    prefixIcon: Icon(Icons.flag_outlined),
                  ),
                ),
                const SizedBox(height: 12),

                // Campos complementares úteis
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _complementoController,
                        decoration: const InputDecoration(
                          labelText: 'Complemento',
                          hintText: 'Opcional',
                          prefixIcon: Icon(Icons.info_outline),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _dddController,
                        decoration: const InputDecoration(
                          labelText: 'DDD',
                          hintText: 'Ex: 11',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
