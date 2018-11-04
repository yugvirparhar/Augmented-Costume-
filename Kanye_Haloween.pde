import KinectPV2.KJoint;
import KinectPV2.*;

PShape object;
KinectPV2 kinect;
PImage img;
PImage img2;
PImage img3;
PShape object2;
PShape object3;

float zVal = 300;
float rotX = PI;


float x[] = new float[4];
float y[] = new float[4];
float z[] = new float[4];

void setup() 
{
  size(1920, 1080, P3D); 
 
  img = loadImage("kanye.png");
  object = loadShape("Kanye (1).obj");
  object3 = loadShape("chain.obj");
  object2 = loadShape("pants.obj");
  img3 = loadImage("chain.png");
  img2 = loadImage("pants.png");
  kinect = new KinectPV2(this);
  kinect.enableColorImg(true);
  kinect.enableSkeleton3DMap(true);
  kinect.enableSkeletonColorMap(true);
  kinect.init();
}

void draw()
{
  background(0);

  image(kinect.getColorImage(), 0, 0, width, height);

  ArrayList<KSkeleton> SkeletonArray2 = kinect.getSkeleton3d();
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

  for (int i = 0; i < SkeletonArray2.size(); i++) {
    KSkeleton skeleton = (KSkeleton) SkeletonArray2.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints1 = skeleton.getJoints();
      println(joints1[KinectPV2.JointType_SpineShoulder].getX());
      
     z[0]=joints1[KinectPV2.JointType_SpineShoulder].getZ();
     z[1]=joints1[KinectPV2.JointType_ShoulderLeft].getZ();
     z[2]=joints1[KinectPV2.JointType_SpineBase].getZ();
      
      
    }}
  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();

      //draw different color for each hand state
      drawHandState(joints[KinectPV2.JointType_HandRight]);
      drawHandState(joints[KinectPV2.JointType_HandLeft]);

      //Draw body
      color col  = skeleton.getIndexColor();
      stroke(col);
      drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase); 
    }
  }
  



  fill(255, 0, 0);
  text(frameRate, 50, 50);
}

void drawBody(KJoint[] joints) {
  
  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  // Right Arm    
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

  drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  drawJoint(joints, KinectPV2.JointType_HandTipRight);
  drawJoint(joints, KinectPV2.JointType_FootLeft);
  drawJoint(joints, KinectPV2.JointType_FootRight);

  drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  drawJoint(joints, KinectPV2.JointType_ThumbRight);

  drawJoint(joints, KinectPV2.JointType_Head);
}

void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  popMatrix();
}

//draw bone
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  lights();
  drawKanye(object, object2,object3,joints, KinectPV2.JointType_SpineMid , KinectPV2.JointType_SpineBase);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
}

//draw hand state
void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
  popMatrix();
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */
void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(255, 255, 255);
    break;
  }
}
void drawKanye(PShape kanye, PShape pants, PShape chain, KJoint[] joints,int jointType1 , int jointType2)
  { float diff = abs(joints[jointType1].getY() - joints[jointType2].getY());
    float new_diff = diff/ joints[jointType2].getY()*100;
  
     x[0]=joints[ KinectPV2.JointType_SpineShoulder].getX();
     y[0]=joints[KinectPV2.JointType_SpineShoulder].getY();
     x[1]=joints[KinectPV2.JointType_ShoulderLeft].getX();
     y[1]=joints[KinectPV2.JointType_ShoulderLeft].getY();
     x[2]=joints[KinectPV2.JointType_SpineBase].getX();
     y[2]=joints[KinectPV2.JointType_SpineBase].getY();
     
    println(x[0] + " " + y[0] + " " + z[0]);
    print("Difference is "+ new_diff);
    scale(2.5 * new_diff);
    
    rotateZ(PI);
    rotateY(PI/2);
   
    translate(0,0,1.2);
      
      PVector v1 = new PVector(x[1] - x[0], y[1]-y[0],z[1]-z[0]);
      PVector v2 = new PVector(x[2] - x[0], y[2]-y[0],z[2]-z[0]);
   
      float denominator = (sqrt((x[1]-x[0])*(x[1]-x[0])+ (y[1]-y[0])*(y[1]-y[0])+(z[1]-z[0])*(z[1]-z[0])))*(sqrt((x[2]-x[0])*(x[2]-x[0])+ (y[2]-y[0])*(y[2]-y[0])+(z[2]-z[0])*(z[2]-z[0])));
      PVector normal1 = v1.cross(v2);
      normal1.div(denominator);
     
    println("rotation"+PI*normal1.z*5); 
    translate(-3,0,1);
    lights();
    shape(chain);     
    translate(3,0,-1);
    shape(kanye); 
    translate(0.6,-1.3,1);
    shape(pants);  
    pants.setTexture(img2);
    chain.setTexture(img3);
    kanye.setTexture(img);
  }
  