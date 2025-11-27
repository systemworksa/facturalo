import 'package:facturaloapp2025/common/location.dart';
import 'package:facturaloapp2025/common/user.dart';

var users = [
  User(
      name: "Documentos",
      image: "assets/img/document.png",
      from: "England",
      acction: 'listar-documentos'),
  User(
      name: "Clientes",
      image: "assets/img/cliente-c.png",
      from: "England",
      acction: 'listar-clientes'),
  User(
      name: "Proveedores",
      image: "assets/img/cliente-c.png",
      from: "England",
      acction: ''),
  User(
      name: "Productos\nServicios",
      image: "assets/img/productos-c.png",
      from: "England",
      acction: 'listar-productos'),
  User(
      name: "Eliminar cuenta",
      image: "assets/img/eliminar.jpeg",
      from: "Canada",
      acction: 'eliminar'),
  User(
      name: "Información",
      image: "assets/img/informacion-c.png",
      from: "Canada",
      acction: 'info'),
  User(
      name: "Retención",
      image: "assets/img/invoice.png",
      from: "Canada",
      acction: ''),
];

var locations = [
  Location(
      name: "Crear factura",
      image: "assets/img/invoice.png",
      accion: 'Generar',
      pagina: 'crear-factura',
      users: [users[3], users[3]]),
  Location(
      name: "Planes",
      image: "assets/img/invoice.png",
      accion: 'Visualizar',
      pagina: 'planes',
      users: [users[3], users[3]]),
];
