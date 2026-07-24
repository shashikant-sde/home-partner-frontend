class ApiService {
  Future<String> fetchData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return 'API result';
  }
}
