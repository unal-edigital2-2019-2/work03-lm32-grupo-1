# Proyecto Electrónica Digital II

A continuación se enlistan y describen los diferentes periféricos y módulos tanto de Hardaware como de Software empleados para la realización del proyecto final del curso de Electrónica Digital II.

## Cámara OV7670

![DIAGRAMA](./figs/camara-ov7670.jpg)


La cámara 0V7670 es el principal periférico externo del proyecto y la fuente de los datos a procesar por medio de Hardware y Software. Es una cámara CMOS la cuál tiene 16 conectores que funcionan de la siguiente manera:

Los primeros dos conectores **3V3** y **GND**, son los pines de alimentación, donde el conector **3V3** debe recibir una tensión DC de 2.5 - 3.3 V, mientras el conector **GND** debe corresponder con el punto de tierra de la tensión aplicada. Los dos pines siguientes se denominan **SIOC** y **SIOD** y corresponden a las señales de clock y data para el bus serial de control de la cámara, o SCCB por sus siglas en inglés, las cuales permiten cambiar la configuración de la cámara por medio de los registros correspondientes en la cámara, cuya descripción más detallada se encuentra consginada en el [datasheet](https://github.com/unal-edigital2-2019-2/work03-lm32-grupo-1/blob/master/docs/datasheet/OV7670_2006.pdf).

Los siguientes 4 conectores corresponden a señales de sincronización de ldea cámara, las primeras 3 señales se denominan **VSYNC**, **HREF** y **PCLK** y corresponden a señales cuadradas generadas por la cámara, que determinan los tiempos de captura y transmisión de los datos por medio de la cámara, mientras la cuarta, denominada **XCLK**, es una señal externa de clock para la sincronización de la cámara. A continuación, se encuentran los pines de datos de salida de la cámara numeradas de **D7** a **D0** para formar una salida de 8 bits cuyo formato puede corresponder con YUV/YCbCr (4:2:2), RGB565/555, GRB (4:2:2) o Raw RGB Data, según cómo se la configure. Por último se encuentran las señales **PWDN** y **RESET**, las cuales son señales externas para la habilitación de los procesos de sincronización de la cámara, de modo que para operar sin interrupciones la señal **PWDN** debe estar en bajo y la señal **RST** en alto, ya que este es un reset negado.


## Configuración de la cámara
La cámara trae incluido un procesamiento de la imagen que captura lo cual le permite enviar la imagen en diferentes formatos...

## Módulo clk24_25_nexys4
Este módulo es el encargado de generar los clocks necesarios para que funcionen adecuadamente los demás módulos de verilog y envía la señal de reloj que alimenta la cámara.

![DIAGRAMA](./figs/clk24_Block.jpeg)


## Módulo cam_read
Este es el módulo encargado del procesamiento de los datos y las señales de sincronización de la cámara para poder leer los datos enviados por la cámara en formato RGB 565 y enviarlos a la memoria RAM en formato 332 para su almacenamiento.

![DIAGRAMA](./figs/read_Block.jpeg)

## Módulo buffer_ram_dp
Este módulo es el encargado de recibir los datos en formato 332 y almacenarlos para su posterios envio al módulo Analizer.

![DIAGRAMA](./figs/Buffer_Block.jpeg)


## Módulo Analyzer
El módulo Analyzer pide información a la RAM y la procesa devolviendo que componente RGB es el predominante en la foto tomada y es conectado al Wishbone para poder ser leído por el procesador.  

![DIAGRAMA](./figs/Analyzer_Block.jpeg)

## Módulo test_cam
Este módulo instancia los cuatro módulos anteriores y conecta sus salidas al wishbone para ser usadas por el procesador

![DIAGRAMA](./figs/Test_Block.jpeg)


## LM32
El procesador LM32 es el maestro que recibe señales de status de la cámara y de 

## UART

## WB

## SoC

![DIAGRAMA](./figs/SoC_Block.jpeg)
