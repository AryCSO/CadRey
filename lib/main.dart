import 'package:cadrey/pages/clientes/client_cadastro_view.dart';
import 'package:cadrey/pages/clientes/client_service.dart';
import 'package:cadrey/pages/clientes/client_viewmodel.dart';
import 'package:cadrey/pages/produtos/product_cadastro_view.dart';
import 'package:cadrey/pages/produtos/product_service.dart';
import 'package:cadrey/pages/produtos/product_viewmodel.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sidebarx/sidebarx.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  MaterialApp(
    debugShowCheckedModeBanner: false,

    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate, 
    ],

    supportedLocales: [const Locale('pt', 'BR')],
  );

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

      child: CadastreReyApp(),

    ),
  );
}

class CadastreReyApp extends StatelessWidget {
  CadastreReyApp({super.key});

  final _controller = SidebarXController(
    selectedIndex: 0, 
    extended: true
  );
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CadRey',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primaryColor: primaryColor,
        canvasColor: canvasColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,

        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 46,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      home: Builder(
        builder: (context) {
          final isSmallScreen = MediaQuery.of(context).size.width < 600;

          return Scaffold(
            key: _key,
            appBar: isSmallScreen

            ? AppBar(
                backgroundColor: canvasColor,
                title: Text(_getTitleByIndex(_controller.selectedIndex)),

                leading: IconButton(
                  onPressed: () {_key.currentState?.openDrawer();},

                  icon: const Icon(
                    Icons.menu, 
                    color: Colors.white,
                  ),
                ),
              ): null,

            drawer: DashboardDrawer(controller: _controller),

            body: Row(
              children: [
                if (!isSmallScreen) DashboardDrawer(controller: _controller),

                Expanded(
                  child: Center(child: _ScreensExample(controller: _controller),),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key, required SidebarXController controller})
  : _controller = controller;
  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,

      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),

        decoration: BoxDecoration(
          color: const Color(0x5F0A1520),
          borderRadius: BorderRadius.circular(20),
        ),

        hoverColor: scaffoldBackgroundColor,

        textStyle: const TextStyle(color: Colors.white),

        selectedTextStyle: const TextStyle(color: Colors.white),

        hoverTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),

        itemTextPadding: const EdgeInsets.only(left: 30),

        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),

        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: actionColor),

          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey, 
              blurRadius: 7,
            ),
          ],
        ),

        iconTheme: const IconThemeData(
          color: Colors.white, 
          size: 20
        ),

        selectedIconTheme: const IconThemeData(
          color: Colors.white, 
          size: 20
        ),
      ),

      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(color: canvasColor),
      ),

      footerDivider: divider,

      headerBuilder: (context, extended) {
        return SizedBox(

          height: 100,

          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Image.asset('assets/images/datafile.png', scale: 3.0,),
          ),
        );
      },

      items: [
        SidebarXItem(
          icon: Icons.home, 
          label: 'Home'
        ),
        SidebarXItem(
          icon: Icons.inventory,
          label: 'Produtos'
        ),
        SidebarXItem(
          icon: Icons.people, 
          label: 'Clientes'
        ),
      ],
    );
  }
}

class _ScreensExample extends StatelessWidget {
  const _ScreensExample({required this.controller});
  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,

      builder: (context, child) {
        switch (controller.selectedIndex) {
          case 0:
            return const DashboardHomeContent();
          case 1:
            return const ProductCadastroView();
          case 2:
            return const ClientCadastroView();
          default:
            return const Center(child: Text('Página não encontrada'));
        }
      },
    );
  }
}

class DashboardHomeContent extends StatelessWidget {
  const DashboardHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context);
    final clientViewModel = Provider.of<ClientViewModel>(context);
    final totalProducts = productViewModel.products.length;
    final totalClients = clientViewModel.clients.length;
    final totalCadastros = totalProducts + totalClients;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
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
    );
  }

  Widget _buildTotalCard(
    BuildContext context, {
    required String title,
    required int value,
    required IconData icon,
    required Color color,
    }
  ) {
    final isLoading =
        context.watch<ProductViewModel>().isLoading ||
        context.watch<ClientViewModel>().isLoading;

    return Card(
      color: const Color(0x0007171b),
      elevation: 8,

      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 330),

        child: Padding(
          padding: const EdgeInsets.all(24.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Icon(
                icon, 
                size: 48, 
                color: Colors.white
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  isLoading
                  ? const SizedBox(
                      height: 40,
                      child: LinearProgressIndicator(color: Colors.white),
                    )
                  
                  : Text(
                      value.toString(),

                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
  }) {
    final isLoading =
        context.watch<ProductViewModel>().isLoading ||
        context.watch<ClientViewModel>().isLoading;

    return Card(
      color: Color(0x0007171b),
      elevation: 5,

      child: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Icon(
                  icon, 
                  size: 36, 
                  color: color
                ),

                isLoading

                ? const SizedBox(
                    width: 50,
                    height: 5,
                    child: LinearProgressIndicator(color: Colors.white),
                  )
                : Text(
                    value.toString(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              title,
              style: TextStyle(
                fontSize: 14, 
                color: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return '';
    case 1:
      return '';
    case 2:
      return '';
    default:
      return '';
  }
}

const primaryColor = Colors.blueAccent;
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7);
final divider = Divider(color: white, height: 1);