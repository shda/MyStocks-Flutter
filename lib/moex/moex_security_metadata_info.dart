class MoexSecurityMetadataInfo
{
  final String? secId; // Короткое имя акции, например SBER
  final double? last;//Последняя цена
  final String? sysTime;

  const MoexSecurityMetadataInfo({
      this.secId,
      this.last,
      this.sysTime}); //Время
}