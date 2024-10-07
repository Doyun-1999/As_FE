import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';

@JsonSerializable()
class AddressModel{
  final int id;
  final String name;
  final String phoneNumber;
  final bool defaultAddress;
  final String address;
  final String detailAddress;
  final String zipcode;

  AddressModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.defaultAddress,
    required this.address,
    required this.detailAddress,
    required this.zipcode,
  });

  AddressModel copyWith({
    int? id,
    String? name,
    String? phoneNumber,
    bool? defaultAddress,
    String? address,
    String? detailAddress,
    String? zipcode,
  }) {
    return AddressModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      defaultAddress: defaultAddress ?? this.defaultAddress,
      address: address ?? this.address,
      detailAddress: detailAddress ?? this.detailAddress,
      zipcode: zipcode ?? this.zipcode,
    );
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}

@JsonSerializable()
class ManageAddressModel{
  final String name;
  final String phoneNumber;
  final String address;
  final String detailAddress;
  final String zipcode;

  ManageAddressModel({
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.detailAddress,
    required this.zipcode,
  });

  factory ManageAddressModel.fromJson(Map<String, dynamic> json) => _$ManageAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$ManageAddressModelToJson(this);
}