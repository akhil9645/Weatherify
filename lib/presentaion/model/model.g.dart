// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      cityname: json['name'] as String?,
      cloudcover: json['all'] as num?,
      humidity: json['humidity'] as num?,
      pressure: json['pressure'] as num?,
      temp: json['temp'] as num?,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'name': instance.cityname,
      'temp': instance.temp,
      'humidity': instance.humidity,
      'pressure': instance.pressure,
      'all': instance.cloudcover,
    };
