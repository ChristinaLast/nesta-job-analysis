/*************************************************************************************
 Data Visualization - Nesta Data Science Challenge Assignment                                                  
 
 Author: Christina Last      
 
 Purpose:

DATASETS:
Google dataset
  https://code.google.com/archive/p/word2vec/
  https://github.com/mmihaltz/word2vec-GoogleNews-vectors

Job dataset:

Update created word vectors with their dataset
  https://rare-technologies.com/word2vec-tutorial/

 
 Usage: 
 1. A mouse left-drag will rotate the camera around the subject.
 2. A right drag will zoom in and out. 
 3. A middle-drag (command-left-drag on mac) will pan. 
 4. A double-click restores the camera to its original position. 
 5. The shift key constrains rotation and panning to one axis or the other.
 *************************************************************************************/
//cam.set_wheel_scale
import peasy.*;

import com.jogamp.opengl.GL;
import controlP5.*;

ControlP5 cp5;

PeasyCam cam;

PFont font;
PFont fontBold;
int numLoc;
word [] wordRows;
int wordNumCols;
vec3f [] rangeWord;
int bookNumCols;
vec3f boxSize = new vec3f(300,300,300);
entry [] bookRows;
ArrayList<ArrayList<Integer>> titleLookup = new ArrayList<ArrayList<Integer>>();
int maxCheckout;
String [] typeDef;
boolean [] typeP;
boolean geometry = true;
boolean sentence = true;
int select = 0;
boolean near = false;
int nearIndex = 0;
int mapping = 0;
boolean line = false;
boolean info = false;

CheckBox r;
RadioButton b;
RadioButton rInfo;
RadioButton rVector;
Textarea myTextlabelA;
Textlabel titleLabel;
Textlabel trainingLabel;

void setup() {
  size(1500, 1200, P3D);
  cam = new PeasyCam(this, 250);
  fontBold = loadFont("Lato-Black-40.vlw");
  font = loadFont("Lato-Light-40.vlw");
  perspective(PI/3.0,(float)width/height,1,100000);
  
  numLoc = 1;
  for (int j = 0; j < numLoc; j++) {
    Table table = loadTable("word_2_vec_trained_occupations.csv");
    if (j == 0) {
      wordNumCols = table.getRowCount();
      wordRows = new word[wordNumCols];
      rangeWord = new vec3f[numLoc];
    }
    rangeWord[j] = new vec3f(0,0,0);
    for (int i = 0; i < wordNumCols; i++) {
      vec3f t = new vec3f(table.getFloat(i,0), table.getFloat(i,1), table.getFloat(i,2));
      rangeWord[j] = new vec3f(max(abs(t.x),rangeWord[j].x), max(abs(t.y),rangeWord[j].y), max(abs(t.z),rangeWord[j].z));
      if (j == 0) {
        wordRows[i] = new word(table.getString(i,3), numLoc);
      }
      wordRows[i].updateLoc(j, t);
    }
  }
  // order of rows and cols depends on orientation
  Table tableTitles = loadTable("processed_only_job_title_occupation.csv");
  Table tableSubjects = loadTable("occupations_lda_10_topics.csv");
  Table lookup = loadTable("lookupTable-circles.csv");
  bookNumCols = tableTitles.getRowCount();
  int subjectWordsLength = tableTitles.getColumnCount();
  int subjectArrayLength = tableSubjects.getColumnCount();
  String[] writeMeList = new String[bookNumCols]; //make lookup table
  println("length "+str(subjectWordsLength) + " length "+str(subjectArrayLength) );
  bookRows = new entry[bookNumCols];
  for (int i = 0; i < bookNumCols; i++) {
    vec3f[] sumArray = new vec3f[numLoc];
    for (int l = 0; l < numLoc; l++) {
      sumArray[l] = new vec3f(0,0,0);
    }
    String subject = tableTitles.getString(i,1);
    float[][] itemType = new float[(subjectArrayLength-2)/2][2];
    for (int l = 0; l < (subjectArrayLength-2)/2; l++) {
      if (tableSubjects.getString(i,(l+1)*2) != null) {
        itemType[l][0] = tableSubjects.getInt(i,(l+1)*2);
        itemType[l][1] = tableSubjects.getFloat(i,(l+1)*2+1);
      }
    }
    float radius = lookup.getInt(i,0);
    String title = tableTitles.getString(i,0);
    ArrayList<Integer> titleArray = new ArrayList<Integer>();
    for (int j = 1; j < lookup.getColumnCount(); j++) {
      if (lookup.getString(i,j) != null) {
        int k = lookup.getInt(i,j);
        titleArray.add(k);
        for (int l = 0; l < numLoc; l++) {
          sumArray[l].add(wordRows[k].loc(l));
        }
      } else { break; }
    }
    //make lookup table
    //String subjected[] = split(subject.toLowerCase(), ' ');
    //String s = "";
    //for (int j = 0; j< subjected.length; j++) {
    //  for (int k = 0; k < wordNumCols; k++) {
    //    if (trim(subjected[j]).equals(trim(wordRows[k].word.toLowerCase())) == true) {
    //      s = s + "," + str(k);
    //      titleArray.add(k);
    //      for (int l = 0; l < numLoc; l++) {
    //        sumArray[l].add(wordRows[k].loc(l));
    //      }
    //    }
    //  }
    //}
    //writeMeList[i] = s.substring(1);

    for (int l = 0; l < numLoc; l++) {
      sumArray[l].div(titleArray.size());
    }
    titleLookup.add(titleArray);   
    bookRows[i] = new entry(itemType, title, sumArray, subject, radius);
  }
  //saveStrings("lookupTable.csv", writeMeList);  //make lookup table
  Table tableTypes = loadTable("lda_10_topics.csv");
  typeP = new boolean[tableTypes.getRowCount()];
  typeDef = new String[tableTypes.getRowCount()];
  for (int i = 0; i < tableTypes.getRowCount(); i++) {
    typeDef[i] = tableTypes.getString(i,1);
    typeP[i] = true;
  }
  
  guiSetup();
  
  println("the title never gets known");
  println(maxCheckout);
//  print(titleLookup);

}

void draw() {
  
  if (cp5.getWindow().isMouseOver()) {
    cam.setActive(false);
  } else {
    cam.setActive(true);
  }
 
  background(0);
  if (!sentence) {
    if (geometry) {
      if (near) {
        drawLines(true);
      } else {
        drawGeometry();
      }
    } else if (near) {
      drawLines(false);
    }
    drawWords();
    drawWordCloud();
  } else {
    drawSentence();
  }
  
  gui();
}
