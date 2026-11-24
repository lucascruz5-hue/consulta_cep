class EnderecoModel {
  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;
  final String ddd;
  final bool erro;

  EnderecoModel({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.ddd,
    this.erro = false,
  });

  factory EnderecoModel.fromJson(Map<String, dynamic> json) {
    if (json['erro'] == true || json['erro'] == 'true') {
      return EnderecoModel(
        cep: '',
        logradouro: '',
        complemento: '',
        bairro: '',
        localidade: '',
        uf: '',
        ddd: '',
        erro: true,
      );
    }
    return EnderecoModel(
      cep: json['cep']?.toString() ?? '',
      logradouro: json['logradouro']?.toString() ?? '',
      complemento: json['complemento']?.toString() ?? '',
      bairro: json['bairro']?.toString() ?? '',
      localidade: json['localidade']?.toString() ?? '',
      uf: json['uf']?.toString() ?? '',
      ddd: json['ddd']?.toString() ?? '',
      erro: false,
    );
  }

  Map<String, dynamic> toJson() => {
        'cep': cep,
        'logradouro': logradouro,
        'complemento': complemento,
        'bairro': bairro,
        'localidade': localidade,
        'uf': uf,
        'ddd': ddd,
        'erro': erro,
      };
}
