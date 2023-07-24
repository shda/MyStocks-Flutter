class ServicesCollection extends IServicesCollection{

  final Map<Type , IService> _mapServices = {};

  @override
  void addService(IService service) {
    _mapServices[service.runtimeType] = service;
  }

  @override
  T getService<T>() {
    var type = T.runtimeType;

    for(var v in _mapServices.values){
      if(v is T){
        return v as T;
      }
    }

    return _mapServices[type] as T;
  }
}

abstract class IServicesCollection{
  void addService(IService service);
  T getService<T>();
}

abstract class IService{

}
