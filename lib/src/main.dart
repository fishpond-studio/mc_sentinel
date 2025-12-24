import 'minecraft_server_status.dart';

// for test
void main() async {
  var server = MinecraftServerStatus(host: '192.168.1.3', port: 25565);
  print(await server.getServerStatus());
}
