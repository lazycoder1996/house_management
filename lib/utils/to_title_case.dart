toTitle(String name) {
  List<String> names = name.split(" ");
  int i = 0;
  for (var name in names) {
    names[i] = name[0].toUpperCase() + name.substring(1);
    i++;
  }
  return names.join(" ");
}
