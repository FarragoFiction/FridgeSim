import "dart:async";
import "dart:html";

import 'package:CommonLib/Colours.dart';
import 'package:CommonLib/Random.dart';
import 'package:CommonLib/Utility.dart';

//############################################################################################
// DATA! Mmmmm data.
//############################################################################################

List<ArtCategory> categores = <ArtCategory>[
  new ArtCategory("All Fanart",               "All Fanart",   "fanArt",   action: drawAllFanArt),
  new ArtCategory("First Player",             "First Player Post Great Refactoring",  "firstPlayer",      url: "/FanArt/FirstPlayer/"),
  new ArtCategory("GrimDark AB FanArt",       "GrimDark AB Gallery",                  "grimAB",           url: "/FanArt/ABFanArt/"),
  new ArtCategory("star.eyes' Memes FanArt",  "star.eyes' memes",                     "stareyes",         url: "/FanArt/star.eyes/"),
  new ArtCategory("Wranglers",              "Wranglers",                    "Wranglers",             url: "/FanArt/Wranglers/"),
  new ArtCategory("Misc FanArt",              "Miscellaneous Art",                    "misc",             url: "/FanArt/miscFanArt/"),
  new ArtCategory("Misc Meme Art",              "Miscellaneous Meme Art",                    "miscmeme",             url: "/FanArt/MiscMemes/"),
  new ArtCategory("JR Misc FanArt",              "JR Miscellaneous Art",                    "jrmisc",             url: "/FanArt/JRMiscArt/"),
  new ArtCategory("LOHAE FanArt",              "LOHAE Art",                    "LOHAE",             url: "/FanArt/LOHAE/"),
  new ArtCategory("Manic LOHAE Contest",              "Manic LOHAE Contest",                    "Manic Contest",             url: "/FanArt/ManicLOHAEContest/"),

  new ArtCategory("WigglerSim FanArt",              "WigglerSim Art",                    "WigglerSim",             url: "/FanArt/WigglerSim/"),
  new ArtCategory("Gif FanArt",               "Gif Gallery",                          "gifs",             url: "/FanArt/gifs/"),
  new ArtCategory("Octobermas FanArt",        "Octobermas!",                          "octobermas",       url: "/FanArt/OctoberMas/"),
  new ArtCategory("Art By Shogun",         "Art By Shogun",                    "Art By Shogun",        url: "/FanArt/ArtByShogun/"),
  new ArtCategory("ShogunSim FanArt",         "ShogunSim Gallery",                    "shogunsim",        url: "/FanArt/ShogunSim/"),
  new ArtCategory("Shogun Day 2018",         "Shogun Day 2018",                    "ShogunDay2018",        url: "/FanArt/ShogunDay2018/"),

  new ArtCategory("Shogun vs JR",             "Shogun vs JR: <a href = 'https://drive.google.com/drive/folders/1dUSRkaW4zZD6r21gywPvR_YHcL7gvzUn?usp=sharing'>https://drive.google.com/drive/folders/1dUSRkaW4zZD6r21gywPvR_YHcL7gvzUn?usp=sharing PUT YOUR NAME IN THE FILE NAME SO WE KNOW WHO MADE IT</a>", "mascotCompetition",    url: "/FanArt/MascotCompetition/"),
  new ArtCategory("oblivionSurfer's FanArt",  "oblivionSurfer's FanArt Gallery",      "oblivionSurfer",   url: "/FanArt/oblivionSurfer/"),
];

List<String> extensions = <String>[
  "png",
  "gif",
  "jpg",
  "jpeg",
];

//############################################################################################

RegExp filePattern = new RegExp('<a href="([^?]*?)">');
RegExp extensionPattern = new RegExp("\\\.(${extensions.join("|")})\$");
RegExp numberedFilePattern = new RegExp("([a-zA-Z_]+?)(\\d+?)\\.");
Element imageContainer = querySelector("#images");

List<Element> imageTiles = <Element>[];

class ArtCategory {
  static const String testPath = "http://farragofiction.com";
  static const bool testMode = true;

  String name;
  String title;
  String tag;
  String url;
  Action action;

  ArtCategory(String this.name, String this.title, String this.tag, {String this.url = null, Action this.action = null});
}

NodeValidator _validator = new NodeValidatorBuilder()..allowElement("span");
Element setHtml(Element node, String html) {
  node.setInnerHtml(html,treeSanitizer: NodeTreeSanitizer.trusted,validator: _validator);
  return node;
}
void appendHtml(Element node, String html) {
  node.appendHtml(html, treeSanitizer: NodeTreeSanitizer.trusted,validator: _validator);
}

Future<Null> main() async{
    //if i don't do this shit fucks up and it can't find the divs and i don't know why anymore but whatever.
    //i remember this used to happen to early sburbsim days but why is it happening NOW?
    await new Future.delayed(const Duration(milliseconds: 10));

    print("its main");
  print("loading fridge");
  List<String> title = <String>[];

  for (ArtCategory cat in categores) {
    print("processing category ${cat.name}");
    if (Uri.base.queryParameters.containsKey(cat.tag) && Uri.base.queryParameters[cat.tag].toLowerCase() == "true") {
      if (cat.action != null) {
        cat.action();
      } else {
        drawImageCategory(cat);
      }
      title.add(cat.title);
    }
  }

  print("trying to set title, title is $title");
  //setTitle(title.isEmpty ? "Select a category:" : title.join(" +<br/>"));
  print("set title somehow");
  Element links = querySelector("#links");
  print("links is $links which is ${querySelector("#links")}");
  setHtml(querySelector("#title"), rainbowifyMe("FARRAGO FICTION FANART FRIDGE"));
  print("set header");

  print("wired up header");
  for (ArtCategory cat in categores) {
      print("displaying category ${cat.name}");
    links.append(setHtml(new AnchorElement(href:"?${cat.tag}=true"), fridgePoetryMe(cat.name)));
  }

  Element header = querySelector("#header");
  appendHtml(header, fridgePoetryMe("I am looking for :"));
    header..append(Search.createListSearchBox(() => imageTiles, (Set<Element> s) {

    for(Element tile in imageTiles) {
      if (s.contains(tile)) {
        tile.style.display = "inline-block";
      } else {
        tile.style.display = "none";
      }
    }
  }, mapping: (Element e) => e.dataset["name"],
      emptyCaption: "Filter..."
  )..className="filter fridgePoetryBox");
  print("done with shit");
}

//List<String> letterColours = <String>["#d12136","#69ac39","#d2d73c","#019ee1","#6c33a4","#ff8d34"];

int colourCount = 18;
List<String> letterColours = new List<String>.generate(colourCount, (int i) => new Colour.hsv((1.0 / colourCount) * i, 1.0, 1.0).toStyleString());
Map<int, int> letterColourIDs = <int,int>{};

String rainbowifyMe(String text) {
  String ret = "";

  for(int i = 0; i< text.length; i++) {

    int charCode = text.codeUnitAt(i);

    if (!letterColourIDs.containsKey(charCode)) {
      letterColourIDs[charCode] = new Random(charCode).nextInt(letterColours.length);
    }

    int id = letterColourIDs[charCode];

    ret = "$ret<span style='color:${letterColours[id]}'>${new String.fromCharCode(charCode)}</span>";
    //ret = "$ret<span style='color:${letterColours[charCode%(letterColours.length-1)]}'>${new String.fromCharCode(charCode)}</span>";
  }

  return ret;
}

String letterDistribution = "AAAAAAAAABBCCDDDDEEEEEEEEEEEEFFGGGHHIIIIIIIIIJKLLLLMMNNNNNNOOOOOOOOPPQRRRRRRSSSSTTTTTTUUUUVVWWXYYZ";
String pickALetter(Random rand) {
  return letterDistribution[rand.nextInt(letterDistribution.length)];
}

String fridgePoetryMe(String text) {
  //fridgePoetryBox
  Random rand = new Random(text.hashCode);

  String ret = "";
  List<String> parts = text.split(" ");
  for(String part in parts) {
    int deviation = 3;
    if (part.length < 4) {
      deviation = 7;
    } else if (part.length < 8) {
      deviation = 4;
    }

    ret = "$ret<span class='fridgePoetryBox' style='transform: rotate(${rand.nextInt(deviation*2) - deviation}deg);'>$part</span>";
  }
  return ret;
}

String adjustURL(String url) {
  if (ArtCategory.testMode) {
    return "${ArtCategory.testPath}$url";
  }
  return url;
}

void setTitle(String title) {
  querySelector("#header")..setInnerHtml(title);
}

void addImageToPage(Element image, String title, bool alwaysShowTitle, {String imageClass = "image", String tileClass = "imageTile"}) {
  image.className = imageClass;

  Element tile = new DivElement()
    ..className = tileClass
    ..dataset["name"] = title;

  if (image is ImageElement) {
    tile
      ..append(new AnchorElement(href:image.src)
        ..target="_blank"
        ..append(image)
      );
  } else {
    tile..append(image);
  }

  if (alwaysShowTitle) {
    tile..append(new DivElement()..className="imagename_always"..text = title);
  } else {
    tile..append(new DivElement()..className="imagename"..text = title);
  }

  Random rand = new Random(title.hashCode);

  Element magnet = setHtml(new DivElement()..className="magnet", rainbowifyMe(pickALetter(rand)));
  tile.append(magnet);
  tile.style.transform = "rotate(${rand.nextInt(3) - 1}deg)";

  imageContainer.append(tile);
  imageTiles.add(tile);
}


Future<List<String>> getDirectoryListing(String url) async {
  url = adjustURL(url);
  List<String> files = <String>[];
  String content = await HttpRequest.getString(url);
  Iterable<Match> matches = filePattern.allMatches(content); // find all link targets
  for (Match m in matches) {
    String filename = m.group(1);
    if (!extensionPattern.hasMatch(filename)) { continue; } // extension rejection

    //print(filename);

    files.add(filename);
  }

  return files;
}

Future<Null> drawImageCategory(ArtCategory category) async {
  List<String> files = await getDirectoryListing(category.url);

  for (String filename in files) {
    addImageToPage(new ImageElement(src:"${adjustURL(category.url)}$filename"), filename, false);
  }
}

void drawAllFanArt() {
  drawImageCategory(categores[4]); // grim AB
  drawImageCategory(categores[5]); // star.eyes
  drawImageCategory(categores[7]); // gifs
  drawImageCategory(categores[6]); // misc
}

int getHighestSequentialFile(List<String> files, String filename) {
  List<int> numbers = <int>[];

  for (String file in files) {
    Match m = numberedFilePattern.firstMatch(file);
    if (m == null) { continue; }

    if (m.group(1) == filename) {
      numbers.add(int.parse(m.group(2)));
    }
  }

  numbers.sort();

  int current = 0;
  int expected = 1;

  for (int n in numbers) {
    if (n == expected) {
      expected++;
      current = n;
    } else {
      break;
    }
  }

  return current;
}

Future<Null> drawHair() async {
  List<String> files = await getDirectoryListing("/SBURBSimE/images/Hair/");

  int count = getHighestSequentialFile(files, "hair");

  for (int i=1; i<=count; i++) {
    addImageToPage(makeSpriteStack(<String>["/SBURBSimE/images/Hair/hair_back$i.png","/SBURBSimE/images/Hair/head.png","/SBURBSimE/images/Hair/hair$i.png"]), i.toString(), true, imageClass: "head", tileClass: "headTile");
  }
}

Future<Null> drawHorns() async {
  List<String> files = await getDirectoryListing("/SBURBSimE/images/Horns/");

  int count = getHighestSequentialFile(files, "left");

  for (int i=1; i<=count; i++) {
    addImageToPage(makeSpriteStack(<String>["/SBURBSimE/images/Horns/right$i.png","/SBURBSimE/images/Hair/head.png","/SBURBSimE/images/Horns/left$i.png"]), i.toString(), true, imageClass: "head", tileClass: "headTile");
  }
}

Element makeSpriteStack(List<String> urls) {
  Element tile = new DivElement()..className="spriteStack";

  for (String url in urls) {
    tile..append(new ImageElement(src: adjustURL(url)));
  }

  return tile;
}



