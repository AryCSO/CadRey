import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cadrey/view/product_cadastro_view.dart';
import 'package:cadrey/view/client_cadastro_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'viewmodels/product_viewmodel.dart';
import 'viewmodels/client_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'services/product_service.dart';
import 'package:flutter/material.dart';
import 'services/client_service.dart';
import 'models/product_model.dart';
import 'models/client_model.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await _initHive();

  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(ClientModelAdapter());
  Hive.registerAdapter(DependentModelAdapter());

  // await Firebase.initializeApp();

  // FirebaseFirestore.instance.collection('Cad').doc('Cad1').set({
  //   'Nome': 'Aryel',
  // }); 

  // var collection = FirebaseFirestore.instance.collection('Cad');

  //   var result = await collection.get();
  //   collection.snapshots().listen((result) {
  //     if (kDebugMode) {
  //       print(result.docs[0]['Nome']);
  //     }
  //   });

  //   for(var doc in result.docs){
  //     if (kDebugMode) {
  //       print(doc['Nome']);
  //     }
  //   } // teste de firestore

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductViewModel(ProductService())..loadProducts(),
        ),

        ChangeNotifierProvider(
          create: (_) => ClientViewModel(ClientService())..loadClients(),
        ),
      ],
      child: const CadastreReyApp(),
    ),
  );
}

Future<void> _initHive() async {
  if (!kIsWeb) {
    try {
      final dir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(dir.path);
    } catch (e) {
      if (kDebugMode) {
        print(
          'Erro ao obter o diretório de documentos', //hive com erro (deu pau)
        );
      }
      await Hive.initFlutter();
    }
  } else {
    await Hive.initFlutter();
  }
}

class CadastreReyApp extends StatelessWidget {
  const CadastreReyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastre Rey',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blue[700]),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardView(),
        '/cadastro-cliente': (context) => const ClientCadastroView(),
        '/cadastro-produto': (context) => const ProductCadastroView(),
      },
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context);
    final clientViewModel = Provider.of<ClientViewModel>(context);

    final totalProducts = productViewModel.products.length;
    final totalClients = clientViewModel.clients.length;
    final totalCadastros = totalProducts + totalClients;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastra Rey',
          style: TextStyle(
            color: Colors.white, 
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.blue[700],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildTotalCard(
                        context,
                        title: 'Total Cadastros',
                        value: totalCadastros,
                        icon: Icons.storage_rounded,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildInfoCard(
                            context,
                            title: 'Clientes',
                            value: totalClients,
                            icon: Icons.people_rounded,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 10),
                          _buildInfoCard(
                            context,
                            title: 'Produtos',
                            value: totalProducts,
                            icon: Icons.inventory_2_sharp,
                            color: Colors.teal,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(

        iconTheme: IconThemeData(color: Colors.white),
        icon:  Icons.add,
        activeIcon: Icons.close,
        label: const Text('Adicionar', style: TextStyle(color: Colors.white,fontSize: 16)),
        backgroundColor: Colors.blue[700],

        children: [

          SpeedDialChild(
            onTap: () => Navigator.pushNamed(context, '/cadastro-cliente'),
            backgroundColor: Colors.blue,
            label: 'Clientes',
            labelStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
            child: Icon(Icons.people_rounded, size: 30, color: Colors.white),
          ),

          SpeedDialChild(
            onTap: () => Navigator.pushNamed(context, '/cadastro-produto'),
            backgroundColor: Colors.teal,
            label: 'Produtos',
            labelStyle: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 16),
            child: Icon(Icons.inventory_2_sharp, size: 30, color: Colors.white),
          ),

        ],
      ),
    );
  }

  Widget _buildTotalCard(
    BuildContext context, {
    required String title,
    required int value,
    required IconData icon,
    required Color color,
    String? subtitle,
  }) {
    final isLoading =
        context.watch<ProductViewModel>().isLoading ||
        context.watch<ClientViewModel>().isLoading;

    return Card(
      elevation: 8,

      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 330),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 48, color: color),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  isLoading
                      ? const SizedBox(
                          height: 40,
                          child: LinearProgressIndicator(color: Colors.grey),
                        )
                      : Text(
                          value.toString(),
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required int value,
    required IconData icon,
    required Color color,
    String? subtitle,
  }) {
    final isLoading =
        context.watch<ProductViewModel>().isLoading ||
        context.watch<ClientViewModel>().isLoading;

    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 36, color: color),
                isLoading
                    ? const SizedBox(
                        width: 50,
                        height: 5,
                        child: LinearProgressIndicator(color: Colors.grey),
                      )
                    : Text(
                        value.toString(),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
          ],
        ),
      ),
    );
  }
}