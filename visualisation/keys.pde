
void keyPressed() {

  switch(key) {
    case '0':
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    case '7':
    case '8':
    case '9':
      int i = Integer.parseInt(str(key));
      typeP[i] = !typeP[i];
      if (typeP[i]) {r.activate(i);} else {r.deactivate(i);}
      break;
/*    case '/':
      mapping = (mapping + 1)%numLoc;
      String t = "";
      if (mapping > 0 ) {t = "s";}
      trainingLabel.setText("Trained "+str(mapping+1) + " time" + t);
      break;*/
    case '.':
      if (!sentence) {
        geometry = !geometry;
        if (geometry) {
          b.activate(1);
        } else {
          b.activate(0);
        }
      }
      break;
    case ',':
      myTextlabelA.setText("");
      nearIndex = 0;
      near = false;
      geometry = true;
      sentence = !sentence;
      geometry = sentence;
      if (sentence) {
          b.activate(2);
        } else {
          b.activate(0);
        }
      break;
    case CODED:
      if (keyCode == UP) {
        if (!near) {select++;}
      } else if (keyCode == DOWN) {
        if (!near) {select = max(0, select-1);}
      } else if (keyCode == LEFT || keyCode == RIGHT) {
        myTextlabelA.setText("");
        near = !near;
      }
      break;
  }
}