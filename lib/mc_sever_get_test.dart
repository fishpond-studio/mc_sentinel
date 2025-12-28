import 'minecraft_server_status.dart';

void main() async {
  var server = MinecraftServerStatus(host: 'play7.furcraft.top', port: 25565);
  print(await server.getServerStatus());
}
