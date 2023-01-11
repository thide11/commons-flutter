# Commons flutter

Biblioteca de funções genéricas flutter de baixo nível da equipe Creator4all

## Funcionalidades

- Métodos para acessar se o usuário está conectado na internet com `NetworkUtils`
- Suporte a facil carregamento de classes e suas dependências com `DependencyInjector` e integre nos widgets flutter stateful com `DependencyInjectorState`
- Suporte a gerenciamento de datas com `AppDateUtils`
- Utilitários para string com o `AppStringUtils`
- Injete sistema de rotas facilmente com o `AppNavigator`
- Facil leitura de dados do disco como espaço livre com `DiskUtils`
- Interface HTTP client `AppHttpClient`, e a implementação de um feito com `Dio` ( classe `DioHttpClient` )
- Classe `AppError` para você tratar erros/exceções e informar o usuário
- Carregar cores em HEX com `HexColor.fromHex`

## Como usar?

Todas as classes ja vem funcionando, com exceção do `DependencyInjector` e `AppNavigator`
Apenas configure as classes que for utilizar

### Configurar o DependencyInjector

Primeiro, você precisa, acoplar o `DependencyInjector` com uma biblioteca de Dependency Injection (DI)

Para fazer isto, extends a classe `DependencyInjector` e implemente o método `getInstance<T extends Object>` e `disposeInstance<T extends Object>`

como exemplo, irei enviar uma integração com o `flutter_modular`:
```dart
import 'package:commons_flutter/utils/dependency_injector.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppInjector extends DependencyInjector {
  @override
  T getInstance<T extends Object>({
    List<Type>? typesInRequestList,
    T? defaultValue,
  }) {
    return Modular.get<T>(
      defaultValue: defaultValue,
    );
  }

  @override
  bool disposeInstance<T extends Object>() {
    return Modular.dispose<T>();
  }
}
```
Usando está implementação você esta acoplando com o `flutter_modular`, então não esqueça de adiciona-lo como dependencia no `pubspec.yaml`
```yaml
dependencies:
  # Use uma versão mais atualizada se possível
  flutter_modular: 5.0.3
```
Após você ter acoplado, na inicialização do app, informe a classe `AppInjector` para o creator_activity utilizar ela

Exemplo em `main.dart`:
```dart
import 'package:commons_flutter/utils/dependency_injector.dart';
//TODO importe seu AppInjector aqui...

void main() async {
  DependencyInjector.init(AppInjector());

  //runApp() costuma ficar aqui...
}
```

Pronto, veja nas docs como configurar o seu DI para instanciar as classes, após isto, pode pegar as classes com `DependencyInjector.get<T>()`


### Configurar o AppNavigator

A configuração do Navigator é idêntica ao do DependencyInjector, só que você precisa extender a classe `AppNavigator` e implementar os métodos de rota


