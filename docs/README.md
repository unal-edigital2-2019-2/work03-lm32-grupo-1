# Proyecto Electrónica Digital II

El objetivo del proyecto es usar el módulo 0V7670 para capturar una imagen la cuál después de su debido procesamiento será enviada al procesador LM32 dentro de un system on chip (SoC) para que este por medio del periférico UART pueda determinar cuál componente de RGB es el que predomina en la imagen.


A continuación se enlistan y describen los diferentes periféricos y módulos tanto de Hardaware como de Software empleados para la realización del proyecto final del curso de Electrónica Digital II.

## Periféricos

### Cámara OV7670

![DIAGRAMA](./figs/camara-ov7670.jpg)


La cámara 0V7670 es el principal periférico externo del proyecto y la fuente de los datos a procesar por medio de Hardware y Software. Es una cámara CMOS la cuál tiene 16 conectores que funcionan de la siguiente manera:

Los primeros dos conectores **3V3** y **GND**, son los pines de alimentación, donde el conector **3V3** debe recibir una tensión DC de 2.5 - 3.3 V, mientras el conector **GND** debe corresponder con el punto de tierra de la tensión aplicada. Los dos pines siguientes se denominan **SIOC** y **SIOD** y corresponden a las señales de clock y data para el bus serial de control de la cámara, o SCCB por sus siglas en inglés, las cuales permiten cambiar la configuración de la cámara por medio de los registros correspondientes en la cámara, cuya descripción más detallada se encuentra consginada en el [datasheet](https://github.com/unal-edigital2-2019-2/work03-lm32-grupo-1/blob/master/docs/datasheet/OV7670_2006.pdf).

Los siguientes 4 conectores corresponden a señales de sincronización de ldea cámara, las primeras 3 señales se denominan **VSYNC**, **HREF** y **PCLK** y corresponden a señales cuadradas generadas por la cámara, que determinan los tiempos de captura y transmisión de los datos por medio de la cámara, mientras la cuarta, denominada **XCLK**, es una señal externa de clock para la sincronización de la cámara. A continuación, se encuentran los pines de datos de salida de la cámara numeradas de **D7** a **D0** para formar una salida de 8 bits cuyo formato puede corresponder con YUV/YCbCr (4:2:2), RGB565/555, GRB (4:2:2) o Raw RGB Data, según cómo se la configure. Por último se encuentran las señales **PWDN** y **RESET**, las cuales son señales externas para la habilitación de los procesos de sincronización de la cámara, de modo que para operar sin interrupciones la señal **PWDN** debe estar en bajo y la señal **RST** en alto, ya que este es un reset negado.


## Configuración de la cámara
La cámara trae incluido un procesamiento de la imagen que captura lo cual le permite enviar la imagen en diferentes formatos...

## Hardware

A continuación se enlistan y describen los módulos de verilog empleados para la configuración de hardware por medio de la FPGA para la conexión con el periférico de la cámara y el procesamiento de sus datos de salida.

### Módulo clk24_25_nexys4
Este módulo corresponde al archivo ***clk24_25_nexys4.v***, es el encargado de generar los clocks necesarios para que funcione adecuadamente la comunicación con la cámara y el procesamiento de la información relativa a esta por medio de los demás módulos de verilog, además de enviar la señal de reloj que alimenta la cámara. Este módulo fue generado empleando la herramienta *clocking wizard* del Core Generator de Xilinx, para facilitar el proceso de división del clock original de la FPGA, correspondiente a 100 MHz y obtener las señales de reloj de 24 y 25 MHz requeridas.

El diagrama de bloques de este módulo se presenta en la siguiente gráfica, donde es posible observar sus entradas, correspondientes a la señal de reloj original y la señal de reset global; y sus salidas, correspondientes a las señales de reloj antes mencionadas y una salida LOCKED generada por el wizard.

![DIAGRAMA](./figs/clk24_Block.jpeg)


### Módulo cam_read
Este es el módulo encargado del procesamiento de los datos y las señales de sincronización de la cámara para poder leer los datos enviados por la cámara en formato RGB 565 y enviarlos a la memoria RAM en formato 332 para su almacenamiento.

![DIAGRAMA](./figs/read_Block.jpeg)

### Módulo buffer_ram_dp
Este módulo es el encargado de recibir los datos en formato 332 y almacenarlos para su posterios envio al módulo Analizer.

![DIAGRAMA](./figs/Buffer_Block.jpeg)


### Módulo Analyzer
El módulo Analyzer pide información a la RAM y la procesa devolviendo que componente RGB es el predominante en la foto tomada y es conectado al Wishbone para poder ser leído por el procesador.  

![DIAGRAMA](./figs/Analyzer_Block.jpeg)

### Módulo test_cam
Este módulo instancia los cuatro módulos anteriores y conecta sus salidas al wishbone para ser usadas por el procesador

![DIAGRAMA](./figs/Test_Block.jpeg)


## LM32
El procesador LM32 es el maestro que recibe señales de status de la cámara y de 

## UART

## WB

El wishbone es un bus de datos que conecta los perifericos del SoC. Esto con la finalidad de hacer que el procesador vea a los perifericos como registros en memoria, el mapeo de los periféricos en la memoria se muestra a continuación:

![DIAGRAMA](./figs/WB_MemMap.jpeg)

Cada uno de estos espacios de memoria tiene el mapeo de sus señales de estatus y control que son las que finalmente usa el procesador. Este mapero es el siguiente:



## SoC

El system on chip (SoC) es el lugar donde se unen todos los periféricos y se conectan al wishbone para poder ser usador por el procesador, que los vé como memoria.

El diagrama de conexión deL Soc se muestra a continuación:

![DIAGRAMA](./figs/SoC_Block.jpeg)
