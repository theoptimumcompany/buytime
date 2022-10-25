import 'dart:convert';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:json_annotation/json_annotation.dart';
part 'broadcast_state.g.dart';

@JsonSerializable(explicitToJson: true)
class BroadcastState {
  @JsonKey(defaultValue: '')
  String body;
  @JsonKey(defaultValue: false)
  bool sendNow;
  @JsonKey(fromJson: Utils.getDate, toJson: Utils.setDate)
  DateTime sendTime;
  @JsonKey(defaultValue: '')
  String senderId;
  @JsonKey(fromJson: Utils.getDate, toJson: Utils.setDate)
  DateTime timestamp;
  @JsonKey(defaultValue: '')
  String title;
  @JsonKey(defaultValue: '')
  String topic;
  @JsonKey(defaultValue: [])
  List<String> serviceIdList;


  BroadcastState({
    this.body,
    this.sendNow,
    this.sendTime,
    this.senderId,
    this.timestamp,
    this.title,
    this.topic,
    this.serviceIdList
  });

  BroadcastState toEmpty() {
    return BroadcastState(
      body: "",
      sendNow: false,
      sendTime: DateTime.now(),
      senderId: '',
      timestamp: DateTime.now(),
      title: '',
      topic: '',
      serviceIdList: [],
    );
  }

  BroadcastState.fromState(BroadcastState state) {
    this.body = state.body;
    this.sendNow = state.sendNow;
    this.sendTime = state.sendTime;
    this.senderId = state.senderId;
    this.timestamp = state.timestamp;
    this.title = state.title;
    this.topic = state.topic;
    this.serviceIdList = state.serviceIdList;
  }


  BroadcastState copyWith({
    String email,
    bool sendNow,
    DateTime sendTime,
    String senderId,
    DateTime timestamp,
    String title,
    String topic,
    List<String> serviceIdList
  }) {
    return BroadcastState(
      body: body ?? this.body,
      sendNow: sendNow ?? this.sendNow,
      sendTime: sendTime ?? this.sendTime,
      senderId: senderId ?? this.senderId,
      timestamp: timestamp ?? this.timestamp,
      title: title ?? this.title,
      topic: topic ?? this.topic,
      serviceIdList: serviceIdList ?? this.serviceIdList,
    );
  }

  factory BroadcastState.fromJson(Map<String, dynamic> json) => _$BroadcastStateFromJson(json);
  Map<String, dynamic> toJson() => _$BroadcastStateToJson(this);

}
