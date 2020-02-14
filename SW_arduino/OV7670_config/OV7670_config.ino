#include <Wire.h>

#define OV7670_I2C_ADDRESS 0x21 /*Dirección del bus i2c para ña camara*/


void setup() {
  Wire.begin();
  Serial.begin(9600);  
  Serial.println("prueba");
  set_cam_RGB565_QCIF();
  set_color_matrix();
  delay(100);
  get_cam_register();
  
}


void set_cam_RGB565_QCIF(){
   
  OV7670_write(0x12, 0x80);

delay(100);

 //OV7670_write(0xFF, 0xF0); //no hay cambio
 OV7670_write(0x12, 0x0C);  //COM7: Set QCIF and RGB
 //OV7670_write(0x12, 0x04);  //COM7: Set RGB
 OV7670_write(0x11, 0xC0);       //CLKR: Set internal clock to use external clock
 //OV7670_write(0x11, 0x80);    
 OV7670_write(0x0C, 0x08);       //COM3: Enable Scaler
 //OV7670_write(0x0C, 0x00);
 OV7670_write(0x3E, 0x00);
 //OV7670_write(0x3E, 0x13);   //Enable Scaling for Predefined Formats using COM14
 OV7670_write(0x40,0xD0);      //COM15: Set RGB 565

 //Color Bar
 //OV7670_write(0x42, 0x08); 
 //OV7670_write(0x12, 0x0E);

 OV7670_write(0x3A,0x04); //se ve color como morado y pixelado / controla ganancia? / reservado / necesario
 //OV7670_write(0x14,0x18); // se ve mucha luz / techo de gancia x16 /necesario
 //OV7670_write(0x4F,0xB3);  //Coeficiente de matriz 1 
 //OV7670_write(0x50,0xB3);  // Coeficiente de matriz 2
 //OV7670_write(0x51,0x00);  // Coeficiente de matriz 3 / se ve rojo y pixelado 
 //OV7670_write(0x52,0x3D); // Coeficiente de matriz 4 / se ve rojo y pixelado
 //OV7670_write(0x53,0xA7);  // Coeficiente de matriz 5 /se ve más azul / mejor?
 //OV7670_write(0x54,0xE4);  //Coeficiente de matriz 6 / se ve más rojo y pixelado
 //OV7670_write(0x58,0x9E); // Signo de los coeficientes de matriz 
 OV7670_write(0x3D,0xC0);  //Activa gamma y nivel de saturación
 //OV7670_write(0x17,0x14);  //Hstart / sin cambios
 OV7670_write(0x18,0x02);  //Hstop / necesario!!! / se descuadra la imagen
 //OV7670_write(0x32,0x80);  //Href / default / sin cambios
 //OV7670_write(0x19,0x03); //Vstart /sin cambios
 //OV7670_write(0x1A,0x7B); //Vstop /sin cambios
 //OV7670_write(0x03,0x0A); //Vref /sin cambios
 //OV7670_write(0x0F,0x41); //Com6 /sin cambios / reservado
 //OV7670_write(0x1E,0x00); // desactivar modo espejo
 //OV7670_write(0x33,0x0B); // control de corriente del arreglo / reservado 
 //OV7670_write(0x3C,0x78); //Com12 / sin cambios / reservado
 //OV7670_write(0x69,0x00); // Control de ganancia / default / sin cambios
 //OV7670_write(0x74,0x00); // Reg74 / default / sin cambios
 OV7670_write(0xB0,0x84); // reservado / color verdoso-morado
 //OV7670_write(0xB1,0x0C); //ABLC1 / sin cambios
 //OV7670_write(0xB2,0x0E); //reservado / sin cambios
 //OV7670_write(0xB3,0x80); //THL_ST / sin cambios
         


/*prubas de ferney*/

/*
   OV7670_write(0x12, 0x00);  //COM7: Set QCIF and RGB Using COM7 and Color Bar    
  OV7670_write(0x40,0xC0);        //COM15: Set RGB 565  
  OV7670_write(0x11, 0x0A);       //CLKR: CSet internal clock to use external clock    
  OV7670_write(0x0C, 0x04);       //COM3: Enable Scaler   
  OV7670_write(0x14,0x6A);       
  
  OV7670_write(0x17, 0x16);      
  OV7670_write(0x18, 0x04);     
  */  
}

void get_cam_register(){
  Serial.println(get_register_value(0x12), HEX); //COM7
  Serial.println(get_register_value(0x11), HEX); //COM7
  Serial.println(get_register_value(0x40), HEX); //COM15
  Serial.println(get_register_value(0x0C), HEX); //COM3
  Serial.println(get_register_value(0x42), HEX); //
  Serial.println(get_register_value(0x14), HEX); 

  Serial.println(get_register_value(0x17), HEX); 
  Serial.println(get_register_value(0x18), HEX); 

}


int OV7670_write(int reg_address, byte data){
  return I2C_write(reg_address, &data, 1);
 }

int I2C_write(int start, const byte *pData, int size){
 //  Serial.println ("I2C init");   
    int n,error;
    Wire.beginTransmission(OV7670_I2C_ADDRESS);
    n = Wire.write(start);
    if(n != 1){
      Serial.println ("I2C ERROR WRITING START ADDRESS");   
      return 1;
    }
    n = Wire.write(pData, size);
    if(n != size){
      Serial.println( "I2C ERROR WRITING DATA");
      return 1;
    }
    error = Wire.endTransmission(true);
    if(error != 0){
      Serial.println( String(error));
      return 1;
    }
    Serial.println ("WRITE OK");
    return 0;
 }

byte get_register_value(int register_address){
  byte data = 0;
   Serial.println ("I2C read");   
  Wire.beginTransmission(OV7670_I2C_ADDRESS);
  Wire.write(register_address);
  Wire.endTransmission();
  Wire.requestFrom(OV7670_I2C_ADDRESS,1);
  while(Wire.available()<1);
  data = Wire.read();
  return data;
}


void set_color_matrix(){
    OV7670_write(0x4f, 0x80);
    OV7670_write(0x50, 0x80);
    OV7670_write(0x51, 0x00);
    OV7670_write(0x52, 0x22);
    OV7670_write(0x53, 0x5e);
    OV7670_write(0x54, 0x80);
    OV7670_write(0x56, 0x40);
    OV7670_write(0x58, 0x9e);
    OV7670_write(0x59, 0x88);
    OV7670_write(0x5a, 0x88);
    OV7670_write(0x5b, 0x44);
    OV7670_write(0x5c, 0x67);
    OV7670_write(0x5d, 0x49);
    OV7670_write(0x5e, 0x0e);
    OV7670_write(0x69, 0x00);
    OV7670_write(0x6a, 0x40);
    OV7670_write(0x6b, 0x0a);
    OV7670_write(0x6c, 0x0a);
    OV7670_write(0x6d, 0x55);
    OV7670_write(0x6e, 0x11);
    OV7670_write(0x6f, 0x9f);
    OV7670_write(0xb0, 0x84);
}


void loop(){
  
 }
