#include "stdio.h"
#include "printf.h"
#include "uart.h"
#include "rocc.h"
#include "riscv_csr_encoding.h"
#include "cpu.h"
#include "FreeRTOS.h"
#include "task.h"

volatile int a = 5;
volatile int b;

TaskHandle_t task_0_main_handler;

void vApplicationStackOverflowHook( TaskHandle_t xTask,
                                        char * pcTaskName ){

                                        }

void task_0_main( void * arg ){

}

int freertos_main(void){
    xTaskCreate(task_0_main,"task_0_main",512,NULL,0,&task_0_main_handler);
    vTaskStartScheduler();
    printf("vTaskStartScheduler:exit......\r\n");
    return 0;
}

 