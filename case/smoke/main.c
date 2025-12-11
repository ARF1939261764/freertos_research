#include "stdio.h"
#include "printf.h"
#include "uart.h"
#include "rocc.h"
#include "riscv_csr_encoding.h"
#include "cpu.h"

volatile int a = 5;
volatile int b;

int main(void){
  uint32_t value; 
  value = read_csr(misa);
  printf("hello world,misa=%08x\n",value);
  cpu_switch_to_hs_mode();
  cpu_switch_to_vs_mode();
  printf("Enter to s mode.\n");
}

 