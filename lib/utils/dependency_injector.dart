abstract class DependencyInjector {
  static late DependencyInjector injector;

  static init(DependencyInjector injector) {
    injector = injector;
  }

  T getInstance<T extends Object>({
    List<Type>? typesInRequestList,
    T? defaultValue,
  });

  bool disposeInstance<T extends Object>();

  static T get<T extends Object>({
    List<Type>? typesInRequestList,
    T? defaultValue,
  }) {
    return injector.getInstance(
      typesInRequestList: typesInRequestList,
      defaultValue: defaultValue,
    );
  }

  static bool dispose<T extends Object>() {
    return injector.disposeInstance();
  }
}
