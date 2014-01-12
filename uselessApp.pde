/* 
 * Experiments in Software
 * Useless App
 * Based on the Useless Machine
 * Made on January 10, 2014 in Brooklyn, NY
 * Adam Harvey / ahprojects.com
 * 
 * This app uses the Java Robot class to hijack your mouse
 * and move it to the position of the application's close button
 * CC-SA-NC
 * Code signing: http://pastebin.com/SNjcFrAh
 */
import java.awt.Rectangle;
import java.awt.Point;
import java.awt.PointerInfo;
import java.awt.MouseInfo;
import java.awt.Robot;
import java.awt.event.InputEvent;
import java.awt.AWTException; 
import java.awt.Toolkit;
import processing.opengl.*;

Robot robot;
PointerInfo pointerInfo;
int targX, targY, curX, curY;
int offsetX = 14, offsetY = 12;
int bgClr = 0x00CC99; // ;)
float nextX, nextY;
float maxDistance;
boolean hasPlayed = false;
long introWait = 1400; //ms
float dStart;
long lastMouseMove = 0;
long timeoutMs = 10000;

public void init() {
  // from http://wiki.processing.org/w/Undecorated_frame
  frame.removeNotify(); 
  frame.setAlwaysOnTop( true ); // keep frame as top window
  super.init();
}

void setup() {
  size(640, 480, OPENGL);
  background(bgClr);

  try {
    robot = new Robot();
  } 
  catch(AWTException e) {
  }

  Point p = frame.getLocation();

  targX = p.x + offsetX; // java window close button X
  targY = p.y + offsetY; // java window close button X

  pointerInfo = MouseInfo.getPointerInfo();
  curX = (int) pointerInfo.getLocation().getX();
  curY = (int) pointerInfo.getLocation().getY();

  int dx = int(abs(curX - targX)); // deltaX
  int dy = int(abs(curY - targY)); // deltaY 

    dStart = sqrt(pow(dx, 2)+pow(dy, 2));
  nextX = curX;
  nextY = curY;
}

void draw() {
  background(bgClr);
  if ( millis() > introWait)
    closeMe();
}

void closeMe() {

  Point p = frame.getLocation();
  targX = p.x + offsetX; // java window close button X
  targY = p.y + offsetY; // java window close button X

  pointerInfo = MouseInfo.getPointerInfo(); // refresh
  curX = (int) pointerInfo.getLocation().getX();
  curY = (int) pointerInfo.getLocation().getY();
  int dx = int(abs(nextX - targX)); // deltaX
  int dy =  int(abs(nextY - targY)); // deltaY
  float dCur = sqrt(pow(dx, 2)+pow(dy, 2));

  float sp = map(dCur, 0f, dStart, 6.0f, 10.0f);

  nextX += (((float)targX - (float)curX) / sp);
  nextY += (((float)targY - (float)curY) / sp);

  if ( dx < 2 && dy < 2 ) {
    robot.mousePress(InputEvent.BUTTON1_MASK); // LEFT CLICK
    robot.mouseRelease(InputEvent.BUTTON1_MASK);
  } 
  else {
    robot.mouseMove(int(nextX), int(nextY));
  }

  // as a precaution, close app X seconds after no mouse movement
  if ( millis() - lastMouseMove > timeoutMs) exit();
}

void mouseMoved() {
  lastMouseMove = millis();
}

