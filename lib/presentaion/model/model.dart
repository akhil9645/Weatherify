import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class Post {
  @JsonKey(name: 'name')
  final String? cityname;

  @JsonKey(name: 'temp')
  final num? temp;

  @JsonKey(name: 'humidity')
  final num? humidity;

  @JsonKey(name: 'pressure')
  final num? pressure;

  @JsonKey(name: 'all')
  final num? cloudcover;

  Post(
      {this.cityname,
      this.cloudcover,
      this.humidity,
      this.pressure,
      this.temp});

  factory Post.fromJson(Map<String, dynamic> json) {
    return _$PostFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
