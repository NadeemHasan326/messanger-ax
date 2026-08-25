import 'package:messanger_ax/exports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MessangerApp());
}
