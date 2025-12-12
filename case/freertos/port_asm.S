
#include "port.h"

.global pxPortInitialiseStack_asm
.global xPortStartFirstTask_asm
.global freertos_risc_v_mtimer_interrupt_handler
.global freertos_risc_v_exception_handler

/*
 * Unlike other ports pxPortInitialiseStack() is written in assembly code as it
 * needs access to the portasmADDITIONAL_CONTEXT_SIZE constant.  The prototype
 * for the function is as per the other ports:
 * StackType_t *pxPortInitialiseStack( StackType_t *pxTopOfStack, TaskFunction_t pxCode, void *pvParameters );
 *
 * As per the standard RISC-V ABI pxTopOfStack is passed in in a0, pxCode in
 * a1, and pvParameters in a2.  The new top of stack is passed out in a0.
 *
 * RISC-V maps registers to ABI names as follows (X1 to X31 integer registers
 * for the 'I' profile, X1 to X15 for the 'E' profile, currently I assumed).
 *
 * Register      ABI Name    Description                       Saver
 * x0            zero        Hard-wired zero                   -
 * x1            ra          Return address                    Caller
 * x2            sp          Stack pointer                     Callee
 * x3            gp          Global pointer                    -
 * x4            tp          Thread pointer                    -
 * x5-7          t0-2        Temporaries                       Caller
 * x8            s0/fp       Saved register/Frame pointer      Callee
 * x9            s1          Saved register                    Callee
 * x10-11        a0-1        Function Arguments/return values  Caller
 * x12-17        a2-7        Function arguments                Caller
 * x18-27        s2-11       Saved registers                   Callee
 * x28-31        t3-6        Temporaries                       Caller
 *
 * The RISC-V context is saved to FreeRTOS tasks in the following stack frame,
 * where the global and thread pointers are currently assumed to be constant so
 * are not saved:
 *
 * 31 : reserved
 * 30 : sstatus
 * 29 : xCriticalNesting
 * 28 : x31
 * 27 : x30
 * 26 : x29
 * 25 : x28
 * 24 : x27
 * 23 : x26
 * 22 : x25
 * 21 : x24
 * 20 : x23
 * 19 : x22
 * 18 : x21
 * 17 : x20
 * 16 : x19
 * 15 : x18
 * 14 : x17
 * 13 : x16
 * 12 : x15
 * 11 : x14
 * 10 : x13
 * 09 : x12
 * 08 : x11
 * 07 : pvParameters
 * 06 : x9
 * 05 : x8
 * 04 : x7
 * 03 : x6
 * 02 : x5
 * 01 : portTASK_RETURN_ADDRESS
 * 00 : pxCode
 */
pxPortInitialiseStack_asm:
    //stack
    addi a0,a0,portSTACK_FRAME_SIZE - portWORD_SIZE
    //satstus
    csrr t0, sstatus                    /* Obtain current mstatus value. */
    andi t0, t0, ~0x2                   /* Ensure interrupts are disabled when the stack is restored within an ISR.  Required when a task is created after the schedulre has been started, otherwise interrupts would be disabled anyway. */
    addi t1, x0, 0x122                  /* Generate the value 0x122, which are the SPIE and SPP bits to set in mstatus. */
    or t0, t0, t1                       /* Set SPIE and SPP bits in sstatus value. */
    //save context
    store_x t0,portSTACK_SSTATUS_IDX                 * portWORD_SIZE(a0)//sstatus
    store_x x0,portSTACK_XCRITICALNESTING_IDX        * portWORD_SIZE(a0)//xCriticalNesting
    store_x a2,portSTACK_PVPARAMETERS_IDX            * portWORD_SIZE(a0)//pvParameters
    store_x x0,portSTACK_PORTTASK_RETURN_ADDRESS_IDX * portWORD_SIZE(a0)//
    store_x a1,portSTACK_PXCODE_IDX                  * portWORD_SIZE(a0)//
    //ret
    ret

xPortStartFirstTask_asm:
    load_x  sp, pxCurrentTCB  /* Load pxCurrentTCB. */
    load_x  sp, 0( sp )       /* Read sp from first TCB member. */

    load_x  x1, portSTACK_PXCODE_IDX                  * portWORD_SIZE( sp )       /* Note for starting the scheduler the exception return address is used as the function return address. */
    ret
    
freertos_risc_v_mtimer_interrupt_handler:

freertos_risc_v_exception_handler:
  
