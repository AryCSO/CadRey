// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DependentModelAdapter extends TypeAdapter<DependentModel> {
  @override
  final int typeId = 2;

  @override
  DependentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DependentModel(
      idDependente: fields[0] as String,
      idCliente: fields[1] as String,
      nome: fields[2] as String,
      parentesco: fields[3] as String,
      dataNascimento: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DependentModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.idDependente)
      ..writeByte(1)
      ..write(obj.idCliente)
      ..writeByte(2)
      ..write(obj.nome)
      ..writeByte(3)
      ..write(obj.parentesco)
      ..writeByte(4)
      ..write(obj.dataNascimento);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DependentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ClientModelAdapter extends TypeAdapter<ClientModel> {
  @override
  final int typeId = 1;

  @override
  ClientModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClientModel(
      idCliente: fields[0] as String,
      nome: fields[1] as String,
      cpf: fields[2] as String,
      dataNascimento: fields[3] as DateTime,
      telefone: fields[4] as String,
      email: fields[5] as String,
      cep: fields[6] as String,
      logradouro: fields[7] as String,
      numero: fields[8] as String,
      bairro: fields[9] as String,
      cidade: fields[10] as String,
      estado: fields[11] as String,
      complemento: fields[12] as String?,
      empresaCnpj: fields[13] as String?,
      cargo: fields[14] as String?,
      dataCadastro: fields[15] as DateTime,
      dependentes: (fields[16] as List?)?.cast<DependentModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ClientModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.idCliente)
      ..writeByte(1)
      ..write(obj.nome)
      ..writeByte(2)
      ..write(obj.cpf)
      ..writeByte(3)
      ..write(obj.dataNascimento)
      ..writeByte(4)
      ..write(obj.telefone)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.cep)
      ..writeByte(7)
      ..write(obj.logradouro)
      ..writeByte(8)
      ..write(obj.numero)
      ..writeByte(9)
      ..write(obj.bairro)
      ..writeByte(10)
      ..write(obj.cidade)
      ..writeByte(11)
      ..write(obj.estado)
      ..writeByte(12)
      ..write(obj.complemento)
      ..writeByte(13)
      ..write(obj.empresaCnpj)
      ..writeByte(14)
      ..write(obj.cargo)
      ..writeByte(15)
      ..write(obj.dataCadastro)
      ..writeByte(16)
      ..write(obj.dependentes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
