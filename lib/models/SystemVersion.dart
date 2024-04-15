enum versionName {HOME, PRO}
class SystemVersion {
  versionName version;
  int switches;
  int heavySwitches;
  int peristalticPumpsCount;

  SystemVersion({
    required this.version,
    required this.switches,
    required this.heavySwitches,
    required this.peristalticPumpsCount,
});
}