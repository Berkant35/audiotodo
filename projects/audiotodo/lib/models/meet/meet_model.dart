import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'meet_model.freezed.dart';
part 'meet_model.g.dart';

@freezed
class Meet with _$Meet {
  const factory Meet({
    /// This parameter reference to your meet. Also you can find any
    /// WordMatchTimes and who created for todos
    @JsonKey(name: 'meetId',required: true) String? meetId,
    /// This parameter help to user for help which match to meet
    @JsonKey(name: 'meetTitle') String? meetTitle,
    @JsonKey(name: 'meetSubtitle') String? meetSubtitle,
    /// Customer may have multi disciplines so when he want any sorting with
    /// category he can use this parameter.
    @JsonKey(name: 'meetCategory') String? meetCategory,
    /// All meet dialogs and words.
    @JsonKey(name: 'meetContent') String? meetContent,
    /// For now idk why added to this parameter
    @JsonKey(name: 'meetLocaleFile') String? meetLocaleFile,
    /// Meet Due Date may help to answer that when did it happen
    @JsonKey(name: 'meetDueDate') String? meetDueDate,
    /// Auto Created Date
    @JsonKey(name: 'createdAt') String? createdAt,
    /// Current User
    @JsonKey(name: 'userId') String? userId,
    /// Any created pdf or word file for this meet
    @JsonKey(name: 'createdPdfFile', defaultValue: false) bool? createdPdfFile,
    @JsonKey(name: 'createdWordFile',defaultValue: false) bool? createdWordFile,
    /// You can see how long time about of meeting by minute.
    @JsonKey(name: 'recordTimeMin') int? recordTimeMin,
    /// You can see how long time about of meeting by millisecond.
    @JsonKey(name: 'recordTimeMs') int? recordTimeMs,
    /// This parameter can handle dialog word counts this
    /// field created for query from firebase.
    @JsonKey(name: 'contentWordCount') int? contentWordCount,
    /// When you want download audio sound file customer use this link.
    @JsonKey(name: 'soundFileLink') String? soundFileLink,
    /// File type
    @JsonKey(name: 'soundFileType') String? soundFileType,
    /// This parameter gives info people of join to meeting about they languages
    @JsonKey(name: 'lang') String? lang,
  }) = _Meet;

  factory Meet.fromJson(Map<String, Object?> json) => _$MeetFromJson(json);
}
