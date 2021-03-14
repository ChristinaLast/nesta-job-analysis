class entry {
  float[][] itemType;
  String subject;
  String title;
  vec3f[] locArray;
  float type;
  float radius;
  
  entry(float[][] i, String t, vec3f[] l, String s, float r) {
    itemType = i;
    title = t;
    locArray = l;
    subject = s;
    radius = r;
    type = i[0][0];
    float max = i[0][1];
    for(int j = 1; j < i.length; j++) {
      if (i[j][1] > max) {
        type = i[j][0];
        max = i[j][1];
      }
    }
  }
  
  vec3f loc(int i) {
    return locArray[i];
  }
  
  boolean filtered(boolean[] t) {
    return !t[int(type)];
  }
  
  color getColor() {
    
    color c = color(0,0,0);
    
    switch(int(type)) {
      case 0:
        return color(255,20,147);
      case 1:
        return color(255,0,0);
      case 2:
        return color(255,69,0);
      case 3:
        return color(255,165,0);
      case 4:
        return color(255,255,0);
      case 5:
        return color(50,205,50);
      case 6:
        return color(34,139,34);
      case 7:
        return color(0,206,209);
      case 8:
        return color(10,10,255);
      case 9:
        return color(138,43,226);
      case 10:
        return color(139,69,19);
    }
    return c;
  }
  
}