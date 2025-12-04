// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 0;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      cdBarras: fields[0] as String,
      nome: fields[1] as String,
      descricao: fields[2] as String,
      preco: fields[3] as double,
      categoria: fields[4] as String,
      marca: fields[5] as String,
      peso: fields[6] as double,
      estoque: fields[7] as int,
      urlImagem: fields[8] as String?,
      dataCadastro: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.cdBarras)
      ..writeByte(1)
      ..write(obj.nome)
      ..writeByte(2)
      ..write(obj.descricao)
      ..writeByte(3)
      ..write(obj.preco)
      ..writeByte(4)
      ..write(obj.categoria)
      ..writeByte(5)
      ..write(obj.marca)
      ..writeByte(6)
      ..write(obj.peso)
      ..writeByte(7)
      ..write(obj.estoque)
      ..writeByte(8)
      ..write(obj.urlImagem)
      ..writeByte(9)
      ..write(obj.dataCadastro);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
