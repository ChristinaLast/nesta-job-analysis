void gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  cp5.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

void guiSetup() {
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  r = cp5.addCheckBox("checkBox")
         .setPosition(20,100)
         .setSize(25,25)
         .setColorBackground(color(50))
         .setColorForeground(color(210))
         .setColorActive(color(255))
         .setColorLabel(color(255))
         .setItemsPerRow(1)
         .setSpacingColumn(80)
         .addItem(typeDef[0],1)
         .addItem(typeDef[1],2)
         .addItem(typeDef[2],3)
         .addItem(typeDef[3],4)
         .addItem(typeDef[4],5)
         .addItem(typeDef[5],6)
         .addItem(typeDef[6],7)
         .addItem(typeDef[7],8)
         .addItem(typeDef[8],9)
         .addItem(typeDef[9],10)
         ;
     
   int a = 50;
   color[] clist = {color(255,20,147,a), color(255,0,0,a), color(255,69,0,a),
   color(255,165,0,a), color(255,255,0,a),  color(50,205,50,a), color(34,139,34,a),
   color(0,206,209,a), color(10,10,255,a), color(138,43,226,a), color(139,69,19,a)};
   int count = 0;
   for(Toggle t:r.getItems()) {
     t.getCaptionLabel().setColorBackground(clist[count]);
     t.getCaptionLabel().getStyle().moveMargin(-7,0,0,-3);
     t.getCaptionLabel().getStyle().movePadding(7,0,0,3);
     t.getCaptionLabel().getStyle().backgroundWidth = 80;
     t.getCaptionLabel().getStyle().backgroundHeight = 20;
     t.getCaptionLabel().setFont(createFont("Lato-Light",10));
     count++;
   }
   
  r.activateAll();
     
  b = cp5.addRadioButton("viewButton")
         .setPosition(20,380)
         .setSize(25,25)
         .setColorBackground(color(50))
         .setColorForeground(color(210))
         .setColorActive(color(255))
         .setColorLabel(color(255))
         .setItemsPerRow(4)
         .setSpacingColumn(80)
         .addItem("words",1)
         .addItem("geometry",2)
         .addItem("job titles",3)
         .addItem("vectors",4)
         ;
         
  rInfo = cp5.addRadioButton("infoButton")
         .setPosition(20,420)
         .setSize(25,25)
         .setColorBackground(color(50))
         .setColorForeground(color(210))
         .setColorActive(color(255))
         .setColorLabel(color(255))
         .setSpacingColumn(80)
         .addItem("subject information",1)
         ;

  rVector = cp5.addRadioButton("vectorButton")
         .setPosition(20,420)
         .setSize(25,25)
         .setColorBackground(color(50))
         .setColorForeground(color(210))
         .setColorActive(color(255))
         .setColorLabel(color(255))
         .setSpacingColumn(80)
         .addItem("vectors",1)
         ;
  
  rInfo.setVisible(false);
         
  for(Toggle t:b.getItems()) {
     t.getCaptionLabel().setColorBackground(color(0,0,0,a));
     t.getCaptionLabel().getStyle().moveMargin(-7,0,0,-3);
     t.getCaptionLabel().getStyle().movePadding(7,0,0,3);
     t.getCaptionLabel().getStyle().backgroundWidth = 80;
     t.getCaptionLabel().getStyle().backgroundHeight = 20;
     t.getCaptionLabel().setFont(createFont("Lato-Light",10));
     count++;
   }
   
   for(Toggle t:rInfo.getItems()) {
     t.getCaptionLabel().setColorBackground(color(0,0,0,a));
     t.getCaptionLabel().getStyle().moveMargin(-7,0,0,-3);
     t.getCaptionLabel().getStyle().movePadding(7,0,0,3);
     t.getCaptionLabel().getStyle().backgroundWidth = 80;
     t.getCaptionLabel().getStyle().backgroundHeight = 20;
     t.getCaptionLabel().setFont(createFont("Lato-Light",10));
     count++;
   }
   
   for(Toggle t:rVector.getItems()) {
     t.getCaptionLabel().setColorBackground(color(0,0,0,a));
     t.getCaptionLabel().getStyle().moveMargin(-7,0,0,-3);
     t.getCaptionLabel().getStyle().movePadding(7,0,0,3);
     t.getCaptionLabel().getStyle().backgroundWidth = 80;
     t.getCaptionLabel().getStyle().backgroundHeight = 20;
     t.getCaptionLabel().setFont(createFont("Lato-Light",10));
     count++;
   }

   b.activate(2);
   
   myTextlabelA = cp5.addTextarea("label")
                    .setText("")
                    .setSize(400,530)
                    .setPosition(20,450)
                    .setColor(255)
                    .setFont(createFont("Lato-Light",10))
                    ;                      
   titleLabel = cp5.addTextlabel("label2")
                    .setText("Topic Modelling and Word Vector Visualization of ESCO Job Titles and Descriptions")
                    .setPosition(20,30)
                    .setColorValue(255)
                    .setFont(createFont("Lato-Light",20))
                    ;
/*   
   trainingLabel = cp5.addTextlabel("label3")
                    .setText("trained 1 time")
                    .setPosition(20,65)
                    .setColorValue(255)
                    .setFont(createFont("Lato-Light",15))
                    ;
 */                   
}

void infoButton(int a) {
    info = !info;
}

void vectorButton(int a) {
    line = !line;
}

void viewButton(int a) {
  boolean prevSentence = sentence;
  if (a == 1) {
    geometry = false;
    sentence = false;
  } else if (a == 2) {
    geometry = true;
    sentence = false;
  } else if (a == 3) {
    geometry = true;
    sentence = true;
  }
  if (sentence != prevSentence) { 
    rInfo.setVisible(!sentence);
    rVector.setVisible(sentence);
    myTextlabelA.setText("");
    near = false; 
    nearIndex = 0;
  }
}

void checkBox(float[] a) {
  for (int i = 0; i < typeP.length; i++) {
    typeP[i] = parseBoolean(int(a[i]));
  }
}
