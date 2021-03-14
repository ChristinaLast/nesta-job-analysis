class vec3f {
  float x;
  float y;
  float z;
  
  vec3f(float pc1, float pc2, float pc3) {
    x = pc1;
    y = pc2;
    z = pc3;
  }
  
  void add(vec3f v) {
    x = x+v.x;
    y = y+v.y;
    z = z+v.z;
  }
  
  void div(float f) {
    x=x/f;
    y=y/f;
    z=z/f;
  }
  
  boolean eql(vec3f v) {
    if (x ==v.x && y == v.y && z == v.z)
    {
      return true;
    } else {
      return false;
    }
  }
}