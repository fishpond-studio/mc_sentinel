import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:is_mc_fk_running/services/minecraft_server_status.dart';

class ServerInfo extends StatefulWidget {
  final String host;
  final String port;

  const ServerInfo({super.key, required this.host, required this.port});

  @override
  State<ServerInfo> createState() => _ServerInfoState();
}

class _ServerInfoState extends State<ServerInfo> {
  late MinecraftServerStatus server;
  Map? info;

  @override
  void initState() {
    super.initState();
    server = MinecraftServerStatus(
      host: widget.host,
      port: int.parse(widget.port),
    );
    _loadServerInfo();
  }

  Future<void> _loadServerInfo() async {
    try {
      final data = await server.getServerStatus();
      setState(() {
        info = data;
      });
    } catch (e) {
      setState(() {
        info = {'online': false, 'error': e.toString()};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1️⃣ 背景图（不透明，供模糊）
            if (info?["favicon"] != null)
              Image.memory(
                base64Decode(info!["favicon"].split(',').last),
                fit: BoxFit.cover,
              ),

            // 2️⃣ 模糊层（只模糊背景）
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.white.withValues(alpha: 0.3), // 磨砂遮罩
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  //服务器版本
                  Container(child: Text('${info?['version']?['name']}')),

                  //服务器介绍
                  Container(child: Text('${info?['description']}')),

                  //服务器人数(进度条)
                  Container(child: Text('players')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
