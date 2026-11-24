# Aplicativo de Consulta de CEP - ViaCEP (Flutter)

Aplicativo desenvolvido em Flutter para consulta de endereços a partir do Código de Endereçamento Postal (CEP), consumindo a API pública do [ViaCEP](https://viacep.com.br/) utilizando o pacote [`http`](https://pub.dev/packages/http).

## Requisitos Atendidos

1. **Biblioteca HTTP**: Integração com a biblioteca oficial `http` (pub.dev) para requisições assíncronas à API REST.
2. **Consulta na API ViaCEP**: Endpoint `https://viacep.com.br/ws/{cep}/json/`.
3. **Campos Separados em TextFields Individuais**:
   - `logradouro` -> `TextField` dedicado
   - `bairro` -> `TextField` dedicado
   - `localidade` -> `TextField` dedicado
   - `uf` -> `TextField` dedicado
   - *(Bônus)*: Campos para Complemento e DDD, além de chips de teste rápido para CEPs de várias cidades.
4. **Controle de Versão Git**:
   - Histórico com múltiplos commits estruturados demonstrando a evolução do desenvolvimento.
   - Pelo menos 3 commits no repositório.

## Arquitetura do Projeto

```
lib/
├── main.dart                   # Interface do usuário com os TextFields e tratamento de estados
├── models/
│   └── endereco_model.dart     # Modelo de dados com parsing do JSON da API ViaCEP
└── services/
    └── cep_service.dart        # Serviço de requisição HTTP assíncrona ao ViaCEP
test/
└── widget_test.dart            # Testes de widgets verificando a presença dos TextFields
```

## Como Executar

### Pré-requisitos
- Flutter SDK instalado (versão 3.x ou superior)
- Conexão com a internet

### Passos

```bash
# Entrar na pasta do projeto
cd consulta_cep

# Obter dependências
flutter pub get

# Executar testes
flutter test

# Executar o aplicativo
flutter run
```

## Histórico de Commits

1. `chore: inicializar estrutura base do projeto Flutter Consulta CEP`
2. `feat: adicionar dependencia http e criar modelo EnderecoModel`
3. `feat: implementar servico ViaCepService e tela com TextFields para logradouro, bairro, localidade e uf`
4. `feat: adicionar tratamento de erros, estados de carregamento, atalhos de teste e widget tests`
