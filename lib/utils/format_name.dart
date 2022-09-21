formatName(String name) {
  List names = name.split("'");
  return names.join("''");
}
