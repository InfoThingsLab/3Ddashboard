import hypermedia.net.*;
import L3D.*;
import java.util.List;
/*
import meter.*;
 Meter mC, mH;
 final int minInC = 0;
 final int maxInC = 50;
 final int minInH = 20;
 final int maxInH = 90;
 */



float offset=0;
float fade=1;

L3D cube;
UDP udp;

JSONObject json;
float pos = 0;
float posInc = .1;

int mode = 0;

final int SPIKE_MODE = 0;
final int L1_MODE = 1;
final int L2_MODE = 2;

final int T1_MODE = 3;
final int T2_MODE = 4;

final int H1_MODE = 5;
final int H2_MODE = 6;

final int P1_MODE = 7;
final int P2_MODE = 8;

final int TEXT_MODE_END = P2_MODE +1;

final int ACC_MODE = 20;
final int PROXIMITY_MODE = 21;




String message = " ";
PImage logo;

float temperature;
float humidity;
float pressure;
int proximity;

int acc_x;
int acc_y;
int acc_z;

static List < Integer > accx_array = new ArrayList < Integer > ();
static List < Integer > accy_array = new ArrayList < Integer > ();
static List < Integer > accz_array = new ArrayList < Integer > ();

int p;
int side = 0;
int inc = 1;
color cubeCol;

float h;
PVector center;
float radius;
float popRadius;
float speed;
color sphereColor;



String[] info = {
  "ST Sensor Demo", 
};

PFont f;

void setup() {

  udp = new UDP(this, 3333, "224.0.0.1"); 
  udp.listen(true);

  size(400, 400, P3D);//  size(displayWidth, displayHeight, P3D);
  cube = new L3D(this); //  cube=new L3D(this, "your@spark.email", "your password", "cube name");

  //logo = loadImage("stlogo.png");

  //surface.setVisible(false);


  /*
  f = createFont("Arial", 16, true);
   
   // Centegrade Temperature Meter
   mC = new Meter(this, 10, 100); 
   mC.setMeterWidth(300);
   String[] scaleLabelsC = {"0.0", "10.0", "20.0", "30.0", "40.0", "50.0"};
   mC.setScaleLabels(scaleLabelsC);
   mC.setUp(minInC, maxInC, 0.0f, 50.0f, 180.0f, 360.0f);
   mC.setTitle("Centegrade" + "\u00B0");  // Added the degree symbol
   mC.setInformationAreaText("Temperature = %.2f\u00B0");
   mC.setDisplayDigitalMeterValue(true);
   mC.updateMeter(20);
   
   d   // Humity Meter
   mH = new Meter(this, 10, 400); 
   mH.setMeterWidth(300);
   mH.setUp(minInH, maxInH, 20.0f, 90.0f, 180.0f, 360.0f);
   mH.setTitle("Humidity %");
   String[] scaleLabelsH = {"20", "30", "40", "50", "60", "70", "80", "90"};
   mH.setScaleLabels(scaleLabelsH);
   mH.setDisplayDigitalMeterValue(true);
   mH.updateMeter(50);
   */
}

void draw() {
  background(150);

  //image(logo, 0, 0);
  /*
  fill(255);
   textSize(48);
   textFont(f, 16);
   textAlign(LEFT);
   text("The Temperature is " + temperature, 300, 300, 0);
   text("The Humidity is " + humidity, 300, 320, 0);
   text("The Pressure is " + pressure, 300, 340, 0);
   text("The Proximity is " + proximity, 300, 360, 0);
   text(info, new PVector(0, 100, 0));
   
   
   mC.updateMeter(int(temperature));
   mH.updateMeter(int(humidity));
   */

  cube.background(0);
  //translate(200, -10);
  switch (mode) {

    case (SPIKE_MODE):
    spikysharp();
    break;

    case (L1_MODE):
    case (L2_MODE):

    message = "T";
    cube.scrollText(message, new PVector(-2, 0, 2), cube.colorMap( 0, frameCount%1000, 1000));
    cube.scrollText(message, new PVector(-2, 0, 3), cube.colorMap( 0, frameCount%1000, 1000));

    message = "S";
    cube.scrollText(message, new PVector(0, -1, 6), cube.colorMap(frameCount%1000, 0, 1000));
    cube.scrollText(message, new PVector(0, -1, 7), cube.colorMap(frameCount%1000, 0, 1000));
    break;

    case (T1_MODE):
    sinusoid();
    break;
    case (T2_MODE):
    message = "Temperature";
    cube.scrollText(message, new PVector(pos, 0, 2), cube.colorMap( 0, frameCount%1000, 1000));
    message = (temperature+" C");
    cube.marquis(message, pos, cube.colorMap(frameCount % 1000, 0, 1000));
    break;

    case (H1_MODE):
    intersectingCrosses();
    break;
    case (H2_MODE):
    message = "H";
    cube.scrollText(message, new PVector(-1, 0, pos%8), cube.colorMap( 1000, frameCount%1000, 0));
    message = (humidity+"%RH");
    cube.scrollText(message, new PVector(pos, 0, 4), cube.colorMap(frameCount % 1000, 0, 1000));
    break;

    case (P1_MODE):
    ripple();
    break;
    case (P2_MODE):
    message = ("Pressure");
    cube.scrollSpinningText(message, new PVector(pos, 0, 3), cube.colorMap(frameCount % 1000, 0, 1000));
    message = (""+pressure);
    cube.marquis(message, pos, cube.colorMap( 0, 0, frameCount % 1000));

    break;

    case (ACC_MODE):
    accWave();
    break;
    case (PROXIMITY_MODE):
    proximitySombrero();
    break;
  }
  offset+=0.1;
  if (offset>8*PI)
  {
    offset=0;
  }

  pos += posInc;
  if (pos > (message.length() + 1) * 8) {
    pos = 0;
    if (mode<TEXT_MODE_END)
    {
      mode++;
    }
    if (mode == TEXT_MODE_END)
    {
      mode = 0;
    }
  }
}

void intersectingCrosses()
{
  for (float x=0; x<cube.side; x++)
    for (float z=0; z<cube.side; z++)
    {
      float y=map(0.75/exp(pow(((x-cube.center.x)*2*pow(sin(offset), 2)), 2)*pow(((z-cube.center.z)*2*pow(sin(offset), 2)), 2)), 0, 1, 0, cube.side);
      PVector point=new PVector(x, y, z);
      cube.setVoxel(point, cube.colorMap(y, 0, cube.side));
    }
}

void ripple()
{
  for (float x=0; x<cube.side; x++)
    for (float z=0; z<cube.side; z++)
    {
      float y=8*sin(10*(pow((x-cube.center.x), 2)+pow((z-cube.center.z), 2))+offset);
      PVector point=new PVector(x, y, z);
      cube.setVoxel(point, cube.colorMap(y, 0, cube.side));
    }
}


void sinusoid()
{
  float xScale=0.5;
  float zScale=0.3;
  for (float x=0; x<cube.side; x++)
    for (float z=0; z<cube.side; z++)
    {
      float y=map(sin(xScale*x+offset)*cos(zScale*z+offset), -1, 1, 0, cube.side);
      PVector point=new PVector(x, y, z);
      cube.setVoxel(point, cube.colorMap(y, 0, cube.side));
    }
}

void spikysharp()
{
  float xScale=0.5;
  float zScale=0.5;
  for (float x=0; x<cube.side; x++)
    for (float z=0; z<cube.side; z++)
    {
      float y=1/(sin(zScale*abs(x)+x*xScale+offset)-cos(zScale*abs(z)+z*zScale+offset));
      PVector point=new PVector(x, y, z);
      cube.setVoxel(point, cube.colorMap(y, 0, cube.side));
    }
}

void proximitySombrero()
{
  //max proximity = 320  320/8 = 40
  int h = proximity / 40;
  if (h > 7) {
    h = 7;
  }
  for (float x=0; x<cube.side; x++)
    for (float z=0; z<cube.side; z++)
    {
      float rho=pow(x-(cube.side/2), 2)+pow(z-(cube.side/2), 2);
      float y=2*cube.side*sin(2*sqrt(rho)+offset)/rho;
      if (y>h) {
        y=h;
      }
      PVector point=new PVector(x, y, z);
      cube.setVoxel(point, cube.colorMap(y, 0, cube.side));
    }
}


void text(String[] info, PVector origin) {
  fill(255);
  for (int i = 0; i < info.length; i++)
    text(info[i], origin.x, origin.y + 15 * i, origin.z);
}

void accWave() {
  for (int i = accx_array.size() - 1; i >= 0; i--) {
    int x = accx_array.get(i);
    cube.setVoxel(new PVector(i, 4 - x, 0), cube.colorMap(4-x, 4, cube.side));
    cube.setVoxel(new PVector(i, 4 - x, 1), cube.colorMap(4-x, 4, cube.side));
  }

  for (int i = accy_array.size() - 1; i >= 0; i--) {
    int x = accy_array.get(i);
    cube.setVoxel(new PVector(i, 4 - x, 3), cube.colorMap(4-x, cube.side, 0));
    cube.setVoxel(new PVector(i, 4 - x, 4), cube.colorMap(4-x, cube.side, 0));
  }

  for (int i = accz_array.size() - 1; i >= 0; i--) {
    int x = accz_array.get(i);
    cube.setVoxel(new PVector(i, 4 - x, 6), cube.colorMap(4-x, 0, cube.side));
    cube.setVoxel(new PVector(i, 4 - x, 7), cube.colorMap(4-x, 0, cube.side));
  }
}


void newhumidity() {

  center = new PVector(3, 3, 0);
  popRadius = random(cube.side); //how big the sphere will be when it pops
  //speed=0.01+random(0.1);  //how fast the sphere will grow.  
  sphereColor = color(random(255), random(255), random(255));
}



void newproximity(PVector topLeft, int side, color col) {
  int p = proximity / 249;
  if (p > 7) {
    p = 7;
  }
  PVector[] topPoints = new PVector[4];
  PVector[] bottomPoints = new PVector[4];
  topPoints[0] = topLeft;
  topPoints[1] = new PVector(topLeft.x + p, topLeft.y, topLeft.z);
  topPoints[2] = new PVector(topLeft.x + p, topLeft.y + p, topLeft.z);
  topPoints[3] = new PVector(topLeft.x, topLeft.y + p, topLeft.z);
  PVector bottomLeft = new PVector(topLeft.x, topLeft.y, topLeft.z + p);
  bottomPoints[0] = bottomLeft;
  bottomPoints[1] = new PVector(bottomLeft.x + p, bottomLeft.y, bottomLeft.z);
  bottomPoints[2] = new PVector(bottomLeft.x + p, bottomLeft.y + p, bottomLeft.z);
  bottomPoints[3] = new PVector(bottomLeft.x, bottomLeft.y + p, bottomLeft.z);
  for (int i = 0; i < 4; i++) {
    drawLine(topPoints[i], bottomPoints[i], col);
    drawLine(topPoints[i], topPoints[(i + 1) % 4], col);
    drawLine(bottomPoints[i], bottomPoints[(i + 1) % 4], col);
  }
  color complement = complement(col);
  for (int i = 0; i < 4; i++) {
    cube.setVoxel(topPoints[i], complement);
    cube.setVoxel(bottomPoints[i], complement);
  }
}
void drawLine(PVector p1, PVector p2, color col) {
  float dx, dy, dz, l, m, n, dx2, dy2, dz2, i, x_inc, y_inc, z_inc, err_1, err_2;
  PVector currentPoint = new PVector(p1.x, p1.y, p1.z);
  dx = p2.x - p1.x;
  dy = p2.y - p1.y;
  dz = p2.z - p1.z;
  x_inc = (dx < 0) ? -1 : 1;
  l = Math.abs(dx);
  y_inc = (dy < 0) ? -1 : 1;
  m = Math.abs(dy);
  z_inc = (dz < 0) ? -1 : 1;
  n = Math.abs(dz);
  dx2 = l * 2;
  dy2 = m * 2;
  dz2 = n * 2;

  if ((l >= m) && (l >= n)) {
    err_1 = dy2 - l;
    err_2 = dz2 - l;
    for (i = 0; i < l; i++) {
      mixVoxel(currentPoint, col);
      if (err_1 > 0) {
        currentPoint.y += y_inc;
        err_1 -= dx2;
      }
      if (err_2 > 0) {
        currentPoint.z += z_inc;
        err_2 -= dx2;
      }
      err_1 += dy2;
      err_2 += dz2;
      currentPoint.x += x_inc;
    }
  } else if ((m >= l) && (m >= n)) {
    err_1 = dx2 - m;
    err_2 = dz2 - m;
    for (i = 0; i < m; i++) {
      mixVoxel(currentPoint, col);
      if (err_1 > 0) {
        currentPoint.x += x_inc;
        err_1 -= dy2;
      }
      if (err_2 > 0) {
        currentPoint.z += z_inc;
        err_2 -= dy2;
      }
      err_1 += dx2;
      err_2 += dz2;
      currentPoint.y += y_inc;
    }
  } else {
    err_1 = dy2 - n;
    err_2 = dx2 - n;
    for (i = 0; i < n; i++) {
      mixVoxel(currentPoint, col);
      if (err_1 > 0) {
        currentPoint.y += y_inc;
        err_1 -= dz2;
      }
      if (err_2 > 0) {
        currentPoint.x += x_inc;
        err_2 -= dz2;
      }
      err_1 += dy2;
      err_2 += dx2;
      currentPoint.z += z_inc;
    }
  }
}

void mixVoxel(PVector currentPoint, color col) {
  color currentCol = cube.getVoxel(currentPoint);
  color newCol = color(red(currentCol) + red(col), green(currentCol) + green(col), blue(currentCol) + blue(col));
  cube.setVoxel(currentPoint, newCol);
}

color complement(color original) {
  float R = red(original);
  float G = green(original);
  float B = blue(original);
  float minRGB = min(R, min(G, B));
  float maxRGB = max(R, max(G, B));
  float minPlusMax = minRGB + maxRGB;
  color complement = color(minPlusMax - R, minPlusMax - G, minPlusMax - B);
  return complement;
}


int proximity_status = 0;
int acc_status = 0;
void receive(byte[] data, String ip, int port) {

  data = subset(data, 0, data.length);
  String message = new String(data);
  JSONObject json = parseJSONObject(message);
  temperature = json.getFloat("temperature");
  humidity = json.getFloat("humidity");
  pressure = json.getFloat("pressure");

  proximity = json.getInt("proximity");
  //(proximity <400 for 5 times )=proximity mode
  if (proximity<400)
  {
    proximity_status++;
  } else
  {
    proximity_status = 0;
  }
  if (proximity_status > 5)
  {
    if (mode != ACC_MODE)
    {
      mode = PROXIMITY_MODE;
    }
  } else
  {
    if (mode==PROXIMITY_MODE)
    {
      mode = 1;
    }
  }


  acc_x = json.getInt("acc_x");
  accx_array.add(acc_x / 300);
  if (accx_array.size() > 8) {
    accx_array.remove(0);
    if (accx_array.get(6)!=accx_array.get(7))
    {
      mode = ACC_MODE;
      acc_status =0;
    } else
    {
      acc_status++;
      if (acc_status>30)
      {
        if (mode == ACC_MODE)
        {
          mode = SPIKE_MODE;
        }
      }
    }
  }

  acc_y = json.getInt("acc_y");
  accy_array.add(acc_y / 300);
  if (accy_array.size() > 8) {
    accy_array.remove(0);
    if (accy_array.get(6)!=accy_array.get(7))
    {
      mode = ACC_MODE;
      acc_status =0;
    } else
    {
      acc_status++;
      if (acc_status>30)
      {
        if (mode == ACC_MODE)
        {
          mode = SPIKE_MODE;
        }
      }
    }
  }

  acc_z = json.getInt("acc_z");
  accz_array.add(acc_z / 300);
  if (accz_array.size() > 8) {
    accz_array.remove(0);
    if (accz_array.get(6)!=accz_array.get(7))
    {
      mode = ACC_MODE;
      acc_status =0;
    } else
    {
      acc_status++;
      if (acc_status>30)
      {
        if (mode == ACC_MODE)
        {
          mode = SPIKE_MODE;
        }
      }
    }
  }


 //println(atan2(json.getInt("mag_y"), json.getInt("mag_x"))*57.2958);

  println("receive: \"" + message + "\" from " + ip + " on port " + port);
  println("temperature ====== " + temperature);
  println("humidity ====== " + humidity);
  println("pressure ====== " + pressure);
  println("proximity ====== " + proximity);

  println("acc_x " + acc_x);
  println("acc_y " + acc_y);
  println("acc_z " + acc_z);

}
