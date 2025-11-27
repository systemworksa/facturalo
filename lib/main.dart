import 'dart:io';

import 'package:facturaloapp2025/pages/clientes/crear_clientes_page.dart';
import 'package:facturaloapp2025/pages/clientes/crear_clientes_venta_page.dart';
import 'package:facturaloapp2025/pages/clientes/editar_cliente_page.dart';
import 'package:facturaloapp2025/pages/clientes/listar_cliente_venta_page.dart';
import 'package:facturaloapp2025/pages/clientes/listar_clientes_page.dart';
import 'package:facturaloapp2025/pages/empresa/configuracion_page.dart';
import 'package:facturaloapp2025/pages/empresa/editar_empresa_page.dart';
import 'package:facturaloapp2025/pages/inicio/dashboard_page.dart';
import 'package:facturaloapp2025/pages/inicio/home_page.dart';
import 'package:facturaloapp2025/pages/inicio/informacion_page.dart';
import 'package:facturaloapp2025/pages/pagos/planes_page.dart';
import 'package:facturaloapp2025/pages/productos/crear_producto_page.dart';
import 'package:facturaloapp2025/pages/productos/editar_producto_page.dart';
import 'package:facturaloapp2025/pages/productos/listar_productos_page.dart';
import 'package:facturaloapp2025/pages/transacciones/consultar_documentos_page.dart';
import 'package:facturaloapp2025/pages/transacciones/ventas/crear_ventas_page.dart';
import 'package:facturaloapp2025/pages/usuario/acceso_page.dart';
import 'package:facturaloapp2025/pages/usuario/login_page.dart';
import 'package:facturaloapp2025/pages/inicio/onboarding_page.dart';
import 'package:facturaloapp2025/pages/inicio/splash_screen.dart';
import 'package:facturaloapp2025/pages/usuario/perfil_page.dart';
import 'package:facturaloapp2025/pages/usuario/ping/actualizar_ping_page.dart';
import 'package:facturaloapp2025/pages/usuario/ping/codigo-rec-ping-page.dart';
import 'package:facturaloapp2025/pages/usuario/ping/crear_ping.dart';
import 'package:facturaloapp2025/pages/usuario/ping/email_recupar_ping.dart';
import 'package:facturaloapp2025/pages/usuario/ping/validar_ping.dart';
import 'package:facturaloapp2025/pages/usuario/recuperar-clave/actualizar_clave_page.dart';
import 'package:facturaloapp2025/pages/usuario/recuperar-clave/codigo_page.dart';
import 'package:facturaloapp2025/pages/usuario/recuperar-clave/email_page.dart';
import 'package:facturaloapp2025/pages/usuario/registro_page.dart';
import 'package:facturaloapp2025/pages/establecimientos/listar_establecimientos_page.dart';
import 'package:facturaloapp2025/pages/establecimientos/crear_establecimientos_page.dart';
import 'package:facturaloapp2025/pages/establecimientos/editar_establecimientos_page.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'common/colorExadecimal.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'pages/inicio/home2_page.dart';
import 'pages/transacciones/ventas/editar_venta_page.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Color color = HexColor.fromHex('#262f69');

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: false,
            appBarTheme: AppBarTheme(
          color: color,
        )),
        title: 'FACTURERO APP',
        builder: BotToastInit(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        locale: const Locale('Es'),
        initialRoute: '/',
        routes: {
          //inicio
          '/': (_) => const SplashScrenPage(),
          'onboard': (_) => const OnboardingPage(),
          'inicio': (_) => const InicioPage(),
          'home2': (_) => const HomeScreen(),
          'home': (_) => const MyWidget(),
          'info': (_) => const InfoPage(),

          //USUARIO
          'login': (_) => const LoginPage(),
          'registrar': (_) => const RegistrarUsuarioPago(),
          'perfil': (_) => const PerfilPage(),

          //EMPRESA
          'configuracion-empresa': (_) => const ConfiguracionEmpresaPage(),
          'editar-empresa': (_) => const EditarEmpresaPage(),

          //RECUPERAR ACCESOS
          'email-verificacion': (_) => const EmailVerificacionPage(),
          'validar-codigo': (_) => const VerificarCodigoPage(),
          'actualizar-clave': (_) => const ActualizarclavePage(),
          'accesos': (_) => const AccesosPage(),
          'crear-ping': (_) => const CrearPingPage(),
          'validar-ping': (_) => const ValidarPingPage(),
          'validar-email-ping': (_) => const ValidarEmailPingPage(),
          'validar-codigo-ping': (_) => const ValidarCodigoPingPage(),
          'actualizar-ping': (_) => const ActualizarPingPage(),

          //CLIENTES
          'listar-clientes': (_) => const ListarClientesPage(),
          'listar-clientes-venta': (_) => const ListarClientesVentaPage(),
          'crear-cliente': (_) => const CrearClientePage(),
          'crear-cliente-venta': (_) => const CrearClienteVentaPage(),
          'editar-cliente': (_) => const EditarClientePage(),

          //PRODUCTOS
          'listar-productos': (_) => const ListarProductosPage(),
          'crear-producto': (_) => const CrearProductoPage(),
          'editar-producto': (_) => const EditarProductoPage(),

          //GENERAR PAGO
          'planes': (_) => const PlanesPage(),

          //TRANSACCIONES
          'listar-documentos': (_) => const ListarDocumentosPage(),
          'crear-factura': (_) => const CrearVentaPage(),
          'editar-factura': (_) => const EditarVentaPage(),

          //PUNTOS DE EMISION
          'listar-establecimientos': (_) => const ListarEstablecimientosPage(),
          'crear-establecimientos': (_) => const CrearEstablecimientoPage(),
          'editar-establecimientos': (_) => const EditarEstablecimientoPage()
        });

  }
}

 class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}