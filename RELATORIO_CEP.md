# Relatório – Aplicativo de Consulta de CEP (ViaCEP) em Flutter

**Aluno / Usuário:** lucascruz5-hue  
**Disciplina:** Programação / Desenvolvimento Mobile (Prof. Tony)  
**Projeto:** `consulta_cep`

---

## 1. Objetivo do Trabalho

Desenvolver um aplicativo Flutter capaz de consultar o Código de Endereçamento Postal (CEP) consumindo a API pública do **ViaCEP** (`https://viacep.com.br/`), utilizando a biblioteca oficial **`http`** do Dart/Flutter.

### Requisitos Atendidos:
1. **Instalação da biblioteca HTTP**: pacote `http` instalado e configurado via `pubspec.yaml`.
2. **Integração com a API ViaCEP**: requisições assíncronas para `https://viacep.com.br/ws/{cep}/json/`.
3. **Exibição dos dados em TextFields separados**:
   - `logradouro`: campo `TextField` próprio com controlador dedicado.
   - `bairro`: campo `TextField` próprio com controlador dedicado.
   - `localidade`: campo `TextField` próprio com controlador dedicado.
   - `uf`: campo `TextField` próprio com controlador dedicado.
4. **Controle de versão com Git**:
   - Repositório Git inicializado com branch `main`.
   - **5 commits** registrados demonstrando a evolução passo a passo do app (exigência mínima de 3 commits).

---

## 2. Estrutura do Código

```
consulta_cep/
├── lib/
│   ├── main.dart                  # Interface completa com TextFields separados, validações e botões
│   ├── models/
│   │   └── endereco_model.dart    # Modelagem do objeto Endereco com parsing de JSON
│   └── services/
│       └── cep_service.dart       # Serviço HTTP assíncrono para comunicação com ViaCEP
├── test/
│   ├── widget_test.dart           # Teste de widgets verificando a existência dos TextFields
│   └── cep_service_test.dart      # Testes unitários para o modelo e tratamento de erros do ViaCEP
├── pubspec.yaml                   # Dependência do pacote 'http: ^1.6.0'
└── README.md                      # Documentação de execução do projeto
```

---

## 3. Log de Commits no Git

O histórico do repositório contém 5 commits ordenados:

| Hash | Mensagem do Commit | Descrição |
|---|---|---|
| `0d49ae3` | `chore: inicializar estrutura base do projeto Flutter Consulta CEP` | Criação do projeto base Flutter e configuração do `.gitignore` |
| `3f4e934` | `feat: adicionar dependencia http e criar modelo EnderecoModel` | Instalação do pacote `http` e criação da classe de modelo para o ViaCEP |
| `4a4eb42` | `feat: implementar servico ViaCepService e tela com TextFields para logradouro, bairro, localidade e uf` | Implementação do serviço de requisição HTTP e criação dos TextFields separados |
| `6d6d1db` | `feat: adicionar validacoes, tratamento de erros, botao de limpar e widget tests` | Tratamento de CEP inválido, feedback via SnackBar, atalhos de teste e testes |
| `738b5c0` | `test: adicionar testes unitarios para deserializacao do modelo EnderecoModel` | Testes de unidade cobrindo parsing normal e respostas de erro da API |

---

## 4. Instruções para Submeter ao GitHub

Para enviar o repositório para o seu GitHub público e obter o link para o professor:

1. Acesse o [GitHub](https://github.com/new) e crie um novo repositório chamado `consulta_cep` (marque como **Público** e **NÃO** inicialize com README ou .gitignore, pois já criamos).
2. No terminal, execute os comandos:
   ```bash
   cd c:\Users\Estudante\Documents\trabalhotony1145\consulta_cep
   git remote add origin https://github.com/lucascruz5-hue/consulta_cep.git
   git branch -M main
   git push -u origin main
   ```
3. O link público a ser enviado ao professor será:
   `https://github.com/lucascruz5-hue/consulta_cep`
