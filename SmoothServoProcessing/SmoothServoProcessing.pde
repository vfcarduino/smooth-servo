import oscP5.*;
import netP5.*;

Servo xAxis = new Servo();
SmoothServo smoothXAxis;

int[] graph = new int[2000];
int gp = 0;

int s1 = -1;
int s2 = -1;

OscP5 oscP5;
NetAddress broadCast;

void setup()
{
  size(500, 500, FX2D);

  // setup osc
  oscP5 = new OscP5(this, 8000);

  broadCast = new NetAddress("172.20.10.2", 8000);

  // max speed = 180 ms per 60° -> 0.3333° per 1ms
  smoothXAxis = new SmoothServo(xAxis, 60.0 / 180.0, 0.02);
}

void draw()
{
  background(255);

  // update smooth servo
  smoothXAxis.update();

  // draw line
  stroke(0);
  strokeWeight(1);
  line(0, height / 2, width, height / 2);

  pushMatrix();
  translate(width / 2, height / 2);
  xAxis.render();
  popMatrix();

  drawGraph();

  // fps
  fill(0);
  text("Position: " + xAxis.position + "°", 20, 20);
}

void drawGraph()
{
  float zero = height / 7 * 6;
  float maxH = zero - 100;
  float border = 20;
  float maxW = width - 2 * border;

  stroke(0);
  line(border, zero, width - border, zero);

  float lastX = border;
  float lastY = zero;

  for (int i = 0; i < gp; i++)
  {
    float x = map(i, 0, gp, border, width - border);
    float y = map(graph[i], 0, 180, zero, maxH);

    //draw line
    stroke(255, 0, 0);
    noFill();
    line(lastX, lastY, x, y);

    stroke(255, 0, 0);
    noFill();
    ellipseMode(CENTER);
    ellipse(x, y, 5, 5);

    if (i == s1 || i == s2)
    {
      // vertical line
      stroke(0, 255, 0);
      noFill();
      line(x, zero - 100, x, zero);
    }

    lastX = x;
    lastY = y;
  }
}

void keyPressed()
{
  if (key == ' ')
  {
    int target = (int)random(0, 180);
    println("Moving to " + target + "°");
    smoothXAxis.moveTo(target, 0.25);
  } else
  {
    // stop
    smoothXAxis.stop();
  }
}