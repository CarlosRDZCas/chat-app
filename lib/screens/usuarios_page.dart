import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../services/aut_service.dart';
import '../services/chat_service.dart';
import '../services/socket_service.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({Key? key}) : super(key: key);

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final usuariosService = UsuariosService();
  List<Usuario> usuarios = [];

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    final authservice = Provider.of<AuthServices>(context);
    return Scaffold(
        appBar: AppBar(
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                alignment: Alignment.center,
                child: socketService.serverStatus == ServerStatus.online
                    ? Icon(Icons.check_circle, color: Colors.blue[400])
                    : const Icon(Icons.offline_bolt, color: Colors.red))
          ],
          leading: IconButton(
              onPressed: () {
                socketService.disconnect();
                AuthServices.deleteToken();
                Navigator.pushReplacementNamed(context, 'login');
              },
              icon: const Icon(Icons.exit_to_app, color: Colors.black87)),
          title: Center(
              child: Text(authservice.usuario!.nombre,
                  style: const TextStyle(color: Colors.black87))),
          elevation: 1,
          backgroundColor: Colors.white,
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _cargarUsuarios,
          child: _usuariosListView(),
        ));
  }

  ListView _usuariosListView() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: usuarios.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) =>
          _usuarioListTile(usuarios[index]),
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');
      },
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(usuario.nombre.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
    );
  }

  _cargarUsuarios() async {
    usuarios = await usuariosService.getUsuarios();
    setState(() {});
    _refreshController.refreshCompleted();
  }
}
