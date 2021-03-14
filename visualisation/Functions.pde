

vec3f getPoint(vec3f loc, vec3f range) {
    float a = map(loc.x, -range.x,range.x,-boxSize.x/2,boxSize.x/2); 
    float b = map(loc.y, -range.y,range.y,-boxSize.y/2,boxSize.y/2);
    float c = map(loc.z, -range.z,range.z,-boxSize.z/2,boxSize.z/2);
    return new vec3f(a,b,c);
}

vec3f getPointWord(word w) {
    vec3f loc = w.loc(mapping);
    vec3f range = rangeWord[mapping];
    return getPoint(loc, range);
}

vec3f getPointBook(entry w) {
    vec3f loc = w.loc(mapping);
    vec3f range = rangeWord[mapping];
    return getPoint(loc, range);
}

boolean distance(vec3f p, vec3f p1) {
  if (near) {
    float bob = sq(p.x-p1.x)+sq(p.y-p1.y)+sq(p.z-p1.z);
    return (bob < 10);
  } else { 
    pushMatrix();
      translate(p.x,p.y,p.z);
      float bob = sq(mouseX-screenX(0, 0, 0))+sq(mouseY-screenY(0, 0, 0));
    popMatrix();
    return (bob < 30);
  }
}

int contains(int i, ArrayList<Integer> l) {
  for (int j = 0; j < l.size(); j++) {
    if (i == l.get(j)) { return 200; }
  }
  return 10; 
}