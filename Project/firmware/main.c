#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <irq.h>
#include <uart.h>
#include <console.h>
#include <generated/csr.h>


static void wait_ms(unsigned int ms)
{
	timer0_en_write(0);
	timer0_reload_write(0);
	timer0_load_write(100000000/1000*ms);
	timer0_en_write(1);
	timer0_update_value_write(1);
	while(timer0_value_read()) timer0_update_value_write(1);
}



int main(void)
{
	irq_setmask(0);
	irq_setie(1);
	uart_init();

	puts("\nexample   lm32-CONFIG camera"__DATE__" "__TIME__"\n");

	uint8_t color = 0;
	uint8_t done = 0;
	uint8_t error = 0;

	
	while(1) {
		color = Cam_res_read(); 
		done = Cam_done_read();
		error = Cam_error_read();
		if(done){
			if(!error){
				switch (color){
	 				case 1: printf("Azul \n"); break;
	 				case 2: printf("Verde \n"); break;
	 				case 4: printf("Rojo \n"); break;
	 				case 7: printf("Ninguno \n"); break;
				}
			}
		}
        //printf("Color: %d  \n", color);
	//printf("Done: %d  \n", done);
	//printf("Error: %d  \n", error);
	Cam_init_write(1);
	wait_ms(10);
	Cam_init_write(0);
	wait_ms(90);
	}

	return 0;
}	
