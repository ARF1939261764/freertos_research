#include "printf.h"
#include "FreeRTOS.h"
#include "task.h"
#include "task.h" /* RTOS task related API prototypes. */
#include "queue.h" /* RTOS queue related API prototypes. */
#include "timers.h" /* Software timer related API prototypes. */
#include "semphr.h" /* Semaphore related API prototypes. */

volatile int a = 5;
volatile int b;

TaskHandle_t task_0_main_handler;
TaskHandle_t task_1_main_handler;

void vApplicationStackOverflowHook( TaskHandle_t xTask,
                                        char * pcTaskName ){

                                        }

void task_0_main( void * arg ){
    int i=0;
    printf("enter task_0_main...\n");
    while(1){
        printf("task_0_main:%d\n",i++);
        vTaskDelay(1);
    }
}

void task_1_main( void * arg ){
    int i=0;
    printf("demo,enter task_1_main...\n");
    while(1){
        printf("demo,task_1_main:%d\n",i++);
        vTaskDelay(1);
    }
}

int freertos_main(void){
    xTaskCreate(task_0_main,"task_0_main",512,NULL,1,&task_0_main_handler);
    xTaskCreate(task_1_main,"task_1_main",512,NULL,1,&task_1_main_handler);
    vTaskStartScheduler();
    return 0;
}

 