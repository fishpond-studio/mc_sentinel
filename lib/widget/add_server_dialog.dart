import 'package:flutter/material.dart';

Future<Map<String, String>?> showAddServerDialog(BuildContext context) {
  String inputName = "";
  String inputAddress = "";
  String inputPort = "";
  return showDialog<Map<String, String>>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("添加新服务器", style: TextStyle()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "名称(Sever)",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                inputName = value;
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: "地址",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                inputAddress = value;
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: "端口(25565)",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                inputPort = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null), // 取消
            child: const Text("取消", style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              final name = inputName.trim().isEmpty
                  ? 'Server'
                  : inputName.trim();
              final address = inputAddress.trim();
              final portStr = inputPort.trim().isEmpty
                  ? '25565'
                  : inputPort.trim();
              final port = int.tryParse(portStr);

              if (address.isEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('请输入地址')));
                return;
              }

              if (port == null || port < 1 || port > 65535) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('端口号必须为1-65535之间的数字')),
                );
                return;
              }

              Navigator.pop(context, {
                'name': name,
                'address': address,
                'port': port.toString(),
              });
            },

            child: const Text("添加", style: TextStyle(color: Colors.black)),
          ),
        ],
      );
    },
  );
}
