import hypermedia.net.*;
import L3D.*;
import java.util.List;


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
final int TEXT_MODE_END = 9;

final int ALEXA_WELCOME_MODE = 10;
final int ALEXA_PLAY_MODE = 11;
final int ALEXA_END_MODE = 12;

final int ACC_MODE = 20;
final int PROXIMITY_MODE = 21;




String message = " ";
PImage logo;

float temperature;
float humidity;
float pressure;
int proximity;


static List < Integer > accx_array = new ArrayList < Integer > ();
static List < Integer > accy_array = new ArrayList < Integer > ();
static List < Integer > accz_array = new ArrayList < Integer > ();

static List < Integer > gyrx_array = new ArrayList < Integer > ();
static List < Integer > gyry_array = new ArrayList < Integer > ();
static List < Integer > gyrz_array = new ArrayList < Integer > ();


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



void setup() {

  udp = new UDP(this, 3333, "224.0.0.1"); 
  udp.listen(true);

  size(400, 400, P3D);//  size(displayWidth, displayHeight, P3D);
  cube = new L3D(this); //  cube=new L3D(this, "your@spark.email", "your password", "cube name");
}

void draw() {
  background(0);
  cube.background(0);

  switch (mode) {

    case (SPIKE_MODE):
    spikysharp();
    break;

    case (L1_MODE):
    case (L2_MODE):

    message = "T";
    cube.scrollText(message, new PVector(-2, 0, 0), cube.colorMap( frameCount*3%600, 0, 600));
    cube.scrollText(message, new PVector(-2, 0, 1), cube.colorMap( frameCount*2%600, 0, 600));
    cube.scrollText(message, new PVector(-2, 0, 2), cube.colorMap( frameCount%600, 0, 600));

    message = "S";
    cube.scrollText(message, new PVector(0, -1, 5), cube.colorMap( frameCount%600, 0, 600));
    cube.scrollText(message, new PVector(0, -1, 6), cube.colorMap( frameCount*2%600, 0, 600));
    cube.scrollText(message, new PVector(0, -1, 7), cube.colorMap( frameCount*3%600, 0, 600));
    break;

    case (T1_MODE):
    sinusoid();
    break;
    case (T2_MODE):
    message = "Temperature";
    cube.scrollText(message, new PVector(pos, 0, 2), cube.colorMap( frameCount%500, 0, 1000));
    message = (temperature+" C");
    cube.marquis(message, pos, cube.colorMap(500+frameCount%500, 0, 1000));
    break;

    case (H1_MODE):
    intersectingCrosses();
    break;
    case (H2_MODE):
    message = "H";
    cube.scrollText(message, new PVector(-1, 0, pos%8), cube.colorMap( frameCount%500, 0, 1000));
    message = (humidity+"%RH");
    cube.scrollText(message, new PVector(pos, 0, 4), cube.colorMap(500+frameCount%500, 0, 1000));
    break;

    case (P1_MODE):
    ripple();
    break;
    case (P2_MODE):
    message = ("Pressure");
    cube.scrollSpinningText(message, new PVector(pos, 0, 3), cube.colorMap(frameCount % 1000, 0, 1000));
    message = (""+pressure);
    cube.marquis(message, pos, cube.colorMap(frameCount*2 % 1000, 0, 1000));
    break;

    case (ALEXA_WELCOME_MODE):
    message = "Welcome to ST Alexa";
    cube.background(cube.colorMap(frameCount % 500, 0, 1000));
    cube.marquis(message, pos, color(0, 0, 255));

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
    if ((mode >= TEXT_MODE_END)&&(mode < ACC_MODE))
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
  int x;
  for (int i = 7; i >= 0; i--) {
    x = accx_array.get(i);
    cube.setVoxel(new PVector(i, 4 - x, 0), cube.colorMap(4-x, 4, cube.side));
    x = accy_array.get(i);
    cube.setVoxel(new PVector(i, 4 - x, 1), cube.colorMap(4-x, cube.side, 0));
    x = accz_array.get(i);
    cube.setVoxel(new PVector(i, 4 - x, 2), cube.colorMap(4-x, 0, cube.side));

    x = gyrx_array.get(i);
    cube.setVoxel(new PVector(i, 4 - x, 5), cube.colorMap(4-x, 4, cube.side));
    x = gyry_array.get(i);
    cube.setVoxel(new PVector(i, 4 - x, 6), cube.colorMap(4-x, cube.side, 0));
    x = gyrz_array.get(i);
    cube.setVoxel(new PVector(i, 4 - x, 7), cube.colorMap(4-x, 0, cube.side));
  }
}


int proximity_status = 0;
int acc_status = 0;

void motionDecode(JSONObject json, String name, List < Integer > motion_array, int step) {
  int x = json.getInt(name)/step;
  //  println(name + x);
  motion_array.add(x);

  if (motion_array.size() > 8) {
    motion_array.remove(0);
    if (motion_array.get(6)!=motion_array.get(7))
    {
      mode = ACC_MODE;
      acc_status =0;
    } else
    {
      acc_status++;
      if (acc_status>60)
      {
        if (mode == ACC_MODE)
        {
          mode = SPIKE_MODE;
        }
      }
    }
  }
}

void receive(byte[] data, String ip, int port) {

  data = subset(data, 0, data.length);
  String sdata = new String(data);
  JSONObject json = parseJSONObject(sdata);
  if (!json.isNull("temperature")) {
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

    motionDecode(json, "acc_x", accx_array, 300 );
    motionDecode(json, "acc_y", accy_array, 300 );
    motionDecode(json, "acc_z", accz_array, 300 );

    motionDecode(json, "gyr_x", gyrx_array, 90000 );
    motionDecode(json, "gyr_y", gyry_array, 90000 );
    motionDecode(json, "gyr_z", gyrz_array, 90000);
  } else {
    String command = json.getString("command");
    String slot = json.getString("slot");
    if (command.equals("welcome"))
    {
      mode = ALEXA_WELCOME_MODE;
    } else if (command.equals("show"))
    {
      if (slot.equals("love"))
      {
        mode = L1_MODE;
      } else if (slot.equals("temperature"))
      {
        mode = T2_MODE;
      } else if (slot.equals("humidity"))
      {
        mode = H2_MODE;
      } else if (slot.equals("pressure"))
      {
        mode = P2_MODE;
      } else if (slot.equals("motion"))
      {
        mode = ACC_MODE;
      } else if (slot.equals("proximity"))
      {
        mode = PROXIMITY_MODE;
      } else if (slot.equals("sine"))
      {
        mode = T1_MODE;
      } else if (slot.equals("spiky"))
      {
        mode = SPIKE_MODE;
      } else if (slot.equals("ripple"))
      {
        mode = P1_MODE;
      }
    }
  }
  println(sdata);
}
