class word {
  String word;
  vec3f[] locArray;
  
  word(String w, int p) {
    word = w;
    locArray = new vec3f[p];
  }
  
  vec3f loc(int i) {
    return locArray[i];
  }
  
  void updateLoc(int i, vec3f l) {
    locArray[i] = l;
  }
  
}

class highlight {
  int count;
  vec3f loc;
  
  highlight(int w, vec3f p) {
    count = w;
    loc = p;
  }
}