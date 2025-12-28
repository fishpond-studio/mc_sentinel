import 'minecraft_server_status.dart';

void main() async {
  var server = MinecraftServerStatus(host: '', port: 25565);
  print(await server.getServerStatus());
}
