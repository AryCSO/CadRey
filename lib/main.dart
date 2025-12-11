import 'package:cadrey/pages/clientes/client_cadastro_view.dart';
import 'package:cadrey/pages/clientes/client_service.dart';
import 'package:cadrey/pages/clientes/client_viewmodel.dart';
import 'package:cadrey/pages/produtos/product_cadastro_view.dart';
import 'package:cadrey/pages/produtos/product_service.dart';
import 'package:cadrey/pages/produtos/product_viewmodel.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // await _initHive();
  // Hive.registerAdapter(ProductModelAdapter());
  // Hive.registerAdapter(ClientModelAdapter());
  // Hive.registerAdapter(DependentModelAdapter());

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

// Future<void> _initHive() async {

class CadastreReyApp extends StatelessWidget {
  const CadastreReyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastre Rey',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.indigo[100]),
      initialRoute: '/',
      routes: {
        '/': (context) => DashboardView(),
        '/cadastro-cliente': (context) => const ClientCadastroView(),
        '/cadastro-produto': (context) => const ProductCadastroView(),
      },
    );
  }
}

class DashboardView extends StatelessWidget {
  Color get primaryColor => Colors.white;
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context);
    final clientViewModel = Provider.of<ClientViewModel>(context);

    final List<CollapsibleItem> items = [

      CollapsibleItem(
        text: 'Produtos',
        icon: Icons.inventory,
        onPressed: () {
          Navigator.pushNamed(context, '/cadastro-produto');
        },
      ),

      CollapsibleItem(
        text: 'Clientes', 
        icon: Icons.person, 
        onPressed: () {
          Navigator.pushNamed(context, '/cadastro-cliente');
        }
      ),

      CollapsibleItem(
        text: 'DashBoards',
        icon: Icons.dashboard,
        onPressed: () {
          Navigator.pushNamed(context, '');
        },
      ),

      CollapsibleItem(
        text: 'Históricos',
        icon: Icons.history,
        onPressed: () {
          Navigator.pushNamed(context, '');
        },
      ),

      CollapsibleItem(
        text: 'Configurações',
        icon: Icons.settings,
        onPressed: () {
          Navigator.pushNamed(context, '');
        },
      ),
    ];

    final totalProducts = productViewModel.products.length;
    final totalClients = clientViewModel.clients.length;
    final totalCadastros = totalProducts + totalClients;

    return Scaffold(
      /*  appBar: AppBar(
        title: const Text(
          'CadRey',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[700],
        elevation: 0,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Opções',
                style: TextStyle(color: Colors.lightBlue),
                textAlign: TextAlign.center,
              ),
              leading: const Icon(
                Icons.keyboard_return,
                color: Colors.lightBlue,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: Text(
                'Clientes',
                style: TextStyle(color: Colors.lightBlue),
              ),
              onTap: () => Navigator.pushNamed(context, '/cadastro-cliente'),
            ),

            ListTile(
              leading: const Icon(Icons.inventory, color: Colors.blue),
              title: Text(
                'Produtos',
                style: TextStyle(color: Colors.lightBlue),
              ),
              onTap: () => Navigator.pushNamed(context, '/cadastro-produto'),
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.blue),
              title: Text(
                'Históricos',
                style: TextStyle(color: Colors.lightBlue),
              ),
              onTap: () {},
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.blue),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {},
            ),
          ],
        ),
      ), */
      body: CollapsibleSidebar(
        iconSize: 30,
        items: items,
        title: 'CadRey',
        avatarImg: const AssetImage('assets/images/spider.jpeg'),

        selectedIconBox: Colors.indigo[700]!,
        backgroundColor: Colors.blue[700]!,
        selectedTextColor: Colors.white,
        selectedIconColor: Colors.white,
        unselectedTextColor: Colors.white,
        unselectedIconColor: Colors.white,

        toggleTitle: 'Recolher',
        toggleButtonIcon: Icons.menu,
        isCollapsed: true,
        toggleTitleStyle: TextStyle(
          color: Colors.blue,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),

        titleStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.blue,
        ),
        textStyle: TextStyle(fontSize: 20, color: Colors.blue),

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
      ),
      floatingActionButton: SpeedDial(
        iconTheme: IconThemeData(color: Colors.white),
        icon: Icons.add,
        activeIcon: Icons.close,
        label: const Text(
          'Adicionar',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: Colors.blue[700],
        activeBackgroundColor: Colors.indigo,
        elevation: 8,
        children: [
          SpeedDialChild(
            onTap: () => Navigator.pushNamed(context, '/cadastro-cliente'),
            backgroundColor: Colors.blue,
            label: 'Clientes',
            labelStyle: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            child: Icon(Icons.people_rounded, size: 30, color: Colors.white),
          ),

          SpeedDialChild(
            onTap: () => Navigator.pushNamed(context, '/cadastro-produto'),
            backgroundColor: Colors.teal,
            label: 'Produtos',
            labelStyle: TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
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
