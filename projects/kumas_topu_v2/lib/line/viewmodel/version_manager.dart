import 'package:kumas_topu/line/repository/repository/repository_base.dart';
import 'package:kumas_topu/models/version.dart';
import 'package:state_notifier/state_notifier.dart';

class VersionManagerNotifier extends StateNotifier<Version?> {
  VersionManagerNotifier(Version? state) : super(null);
  final repository = Repository.instance;
  
  Future<void> getVersionAndSet() async {
    state = await repository?.getVersion();
  }
  
  
  
}
