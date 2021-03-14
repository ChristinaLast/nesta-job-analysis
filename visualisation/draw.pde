void drawSentence() {
  for (int i = 0; i < bookRows.length; i++) {
    if (!bookRows[i].filtered(typeP)) {
      color c = bookRows[i].getColor();
      vec3f p = getPointBook(bookRows[i]);
    //  drawCircle(p, c, 1);
      stroke(c,50);
      strokeWeight(bookRows[i].radius+5);
      pushMatrix();
        translate(p.x,p.y,p.z);
        point(0,0,0);
      popMatrix(); 
      strokeWeight(1);
      if (line) { line(p.x, p.y, p.z, 0, 0, 0); }
    }
  }
  hint(DISABLE_DEPTH_TEST);
  highlight h = new highlight(0,new vec3f(0,0,0));
  h = writeText(h, getPointBook(bookRows[0]), bookRows[0].title, select, getPointBook(bookRows[nearIndex]), 0, false);
  for (int i = 1; i< bookNumCols; i++) {
    if (!bookRows[i].filtered(typeP)) {
      h = writeText(h, getPointBook(bookRows[i]), bookRows[i].title, select, getPointBook(bookRows[nearIndex]), i, false);
      if (near) { 
        drawTitle(nearIndex, true); 
      }
    }
  }
  if (near) { 
    writeTitle(nearIndex);
  }
  if (h.count < select) { select = 0; }
  hint(ENABLE_DEPTH_TEST);
}

void drawLines(boolean draw) {
  String t = "";
  for (int i = 0; i < titleLookup.size(); i++) {
    if (!bookRows[i].filtered(typeP)) {
      int b = drawTitle(i, draw);
      if (b > 50) {
        t = t + "\n\n" + bookRows[i].title.toUpperCase();
        if (info) { t = t + "\n[ " + bookRows[i].subject.toUpperCase() + " ]"; } 
        writeTitle(i);
      }
    }
  }
  myTextlabelA.setText(t);
}

void writeTitle(int i) {
  ArrayList<Integer> innerList = titleLookup.get(i);
  for (int j = 0; j < innerList.size(); j++) {
    if(nearIndex != innerList.get(j) || sentence) {
      drawWord(wordRows[innerList.get(j)].word, getPointWord(wordRows[innerList.get(j)]), 0, i, 1);
    }
  }
}


int drawTitle(int i, boolean draw) {
  ArrayList<Integer> innerList = titleLookup.get(i);
  color c = bookRows[i].getColor();
  int b = contains(nearIndex, innerList);
  if (draw || b > 50) {
    switch(innerList.size()) {
      case 1:
        pushMatrix();
        vec3f pc = getPointWord(wordRows[innerList.get(0)]);
        translate(pc.x, pc.y, pc.z);
        noFill();
        strokeWeight(5);
        if (near) {
          stroke(c, b);
        } else { stroke(c, 10); }
        point(0,0,0);
        popMatrix(); 
        break;
      default:
        for (int j = 0; j < innerList.size()-1; j++) {
          vec3f pc0 = getPointWord(wordRows[innerList.get(j)]);
          vec3f pc1 = getPointWord(wordRows[innerList.get(j+1)]);
          strokeWeight(2);
          if (near) {
            stroke(c, b);
          } else { stroke(c, 10); }
          line(pc0.x, pc0.y, pc0.z, 
               pc1.x, pc1.y, pc1.z);
        }
        break;
    }
  }
  return b;
}

void drawGeometry() {
  for (int i = 0; i < titleLookup.size(); i++) {
    if (!bookRows[i].filtered(typeP)) {
      ArrayList<Integer> innerList = titleLookup.get(i);
      color c = bookRows[i].getColor();
      switch(innerList.size()) {
        case 1:
          pushMatrix();
          vec3f pc = getPointWord(wordRows[innerList.get(0)]);
          translate(pc.x, pc.y, pc.z);
          noFill();
          strokeWeight(5);
          stroke(c, 10); 
          point(0,0,0);
          popMatrix(); 
          break;
        case 2:
          vec3f pc0 = getPointWord(wordRows[innerList.get(0)]);
          vec3f pc1 = getPointWord(wordRows[innerList.get(1)]);
          strokeWeight(2);
          stroke(c, 10); 
          line(pc0.x, pc0.y, pc0.z, 
               pc1.x, pc1.y, pc1.z);
          break;
        case 3:
          vec3f pc0a = getPointWord(wordRows[innerList.get(0)]);
          vec3f pc1a = getPointWord(wordRows[innerList.get(1)]);
          vec3f pc2a = getPointWord(wordRows[innerList.get(2)]);
          fill(c, 10);
          stroke(c, 10);
          beginShape();
          vertex(pc0a.x, pc0a.y, pc0a.z);
          vertex(pc1a.x, pc1a.y, pc1a.z);
          vertex(pc2a.x, pc2a.y, pc2a.z);
          endShape(CLOSE);
        case 0:
          break;
        default: //draw a 4 sided triangle
          vec3f pc0b = getPointWord(wordRows[innerList.get(0)]);
          vec3f pc1b = getPointWord(wordRows[innerList.get(1)]);
          vec3f pc2b = getPointWord(wordRows[innerList.get(2)]);
          vec3f pc3b = getPointWord(wordRows[innerList.get(3)]);
          fill(c, 10);
          stroke(c, 10); 
          beginShape(TRIANGLES);
          vertex(pc0b.x, pc0b.y, pc0b.z);
          vertex(pc1b.x, pc1b.y, pc1b.z);
          vertex(pc2b.x, pc2b.y, pc2b.z);
          
          vertex(pc0b.x, pc0b.y, pc0b.z);
          vertex(pc1b.x, pc1b.y, pc1b.z);
          vertex(pc3b.x, pc3b.y, pc3b.z);
          
          vertex(pc2b.x, pc2b.y, pc2b.z);
          vertex(pc1b.x, pc1b.y, pc1b.z);
          vertex(pc3b.x, pc3b.y, pc3b.z);
          
          vertex(pc2b.x, pc2b.y, pc2b.z);
          vertex(pc0b.x, pc0b.y, pc0b.z);
          vertex(pc3b.x, pc3b.y, pc3b.z);
          endShape(CLOSE);
      }
    }
  }
}

void drawWords() {
  for (int i = 0; i< wordNumCols; i++) {
    vec3f pc = getPointWord(wordRows[i]);
    color c = color(0,0,0);
    strokeWeight(2);
    if (!geometry) {
      c = color(255,255,255);
      strokeWeight(5);
    }
    stroke(c,50);
    pushMatrix();
    translate(pc.x,pc.y,pc.z);
    point(0,0,0);
    popMatrix();
  }
}

void drawWordCloud() {
  hint(DISABLE_DEPTH_TEST);
  highlight h = new highlight(0,new vec3f(0,0,0));
  h = writeText(h, getPointWord(wordRows[0]), wordRows[0].word, select, getPointWord(wordRows[nearIndex]), 0, false);
  for (int i = 1; i< wordNumCols; i++) {
    h = writeText(h, getPointWord(wordRows[i]), wordRows[i].word, select, getPointWord(wordRows[nearIndex]), i, false);
  }
  if (h.count < select) { select = 0; }
  hint(ENABLE_DEPTH_TEST);
}

highlight writeText(highlight c, vec3f p, String title, int selected, vec3f nearPoint, int i, boolean skip) {
  if (distance(p, nearPoint) || skip == true)
  {
    if ( c.count == 0 ) { c.loc = p; }
    pushMatrix();
      translate(p.x,p.y,p.z);
      strokeWeight(5);
      stroke(255,255,255,255);
      point(0,0,0);
    popMatrix();
    drawWord(title, c.loc, c.count, i, selected);
    c.count++;
  }
  return c;
}

void drawWord(String title, vec3f loc, int count, int i, int selected){
  pushMatrix();
      float[] rotations = cam.getRotations();
      translate(loc.x,loc.y,loc.z);
      rotateX(rotations[0]);
      rotateY(rotations[1]);
      rotateZ(rotations[2]);
      translate(0,-count*4,0);
      stroke(0,0,0,0);
      fill(255,255,255);
      textFont(font, 2);
      if (count == selected && !near) {
          print("here " + i);
          nearIndex = i;
          fill(210,210,210);
          textFont(fontBold, 2);
      } else if ( near && nearIndex == i ) {
        textFont(fontBold, 2);
      }
      text(title.toUpperCase(),0,0);
    popMatrix();
}

void drawCircle(vec3f loc, color c, int d) {
  pushMatrix();
    float[] rotations = cam.getRotations();
    translate(loc.x,loc.y,loc.z);
    rotateX(rotations[0]);
    rotateY(rotations[1]);
    rotateZ(rotations[2]);
    stroke(c);
    strokeWeight(1);
    fill(0,0,0,0);
    ellipse(0,0,d,d);
  popMatrix();
}