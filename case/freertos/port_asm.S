
#include "port.h"
#include "port_asm.h"

.global pxPortInitialiseStack_asm
.global xPortStartFirstTask_asm
.global freertos_risc_v_mtimer_interrupt_handler
.global freertos_risc_v_stimer_interrupt_handler
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
 */
pxPortInitialiseStack_asm:
    //stack
    addi a0,a0,-portSTACK_FRAME_SIZE
    //satstus
    csrr t0, sstatus                    /* Obtain current mstatus value. */
    andi t0, t0, ~0x102                   /* Ensure interrupts are disabled when the stack is restored within an ISR.  Required when a task is created after the schedulre has been started, otherwise interrupts would be disabled anyway. */
    addi t1, x0, 0x020                   /* Generate the value 0x22, which are the SPIE and SIE bits to set in sstatus. */
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
    portcontext_RESTORE_CONTEXT
    sret//ret to U mode
    
freertos_risc_v_mtimer_interrupt_handler:
    j .

freertos_risc_v_exception_handler:
    portcontext_SAVE_CONTEXT_EXCEPTION
    call vTaskSwitchContext

    load_x t0, pxCurrentTCB /* Load pxCurrentTCB. */
    load_x sp, 0 ( t0 )     /* Read sp from first TCB member. */


    load_x  x1,  portSTACK_X1_IDX * portWORD_SIZE(sp)
    load_x  x5,  portSTACK_X5_IDX * portWORD_SIZE(sp)
    load_x  x6,  portSTACK_X6_IDX * portWORD_SIZE(sp)
    load_x  x7,  portSTACK_X7_IDX * portWORD_SIZE(sp)
    load_x  x8,  portSTACK_X8_IDX * portWORD_SIZE(sp)
    load_x  x9,  portSTACK_X9_IDX * portWORD_SIZE(sp)
    load_x x10, portSTACK_X10_IDX * portWORD_SIZE(sp)
    load_x x11, portSTACK_X11_IDX * portWORD_SIZE(sp)
    load_x x12, portSTACK_X12_IDX * portWORD_SIZE(sp)
    load_x x13, portSTACK_X13_IDX * portWORD_SIZE(sp)
    load_x x14, portSTACK_X14_IDX * portWORD_SIZE(sp)
    load_x x15, portSTACK_X15_IDX * portWORD_SIZE(sp)
    load_x x16, portSTACK_X16_IDX * portWORD_SIZE(sp)
    load_x x17, portSTACK_X17_IDX * portWORD_SIZE(sp)
    load_x x18, portSTACK_X18_IDX * portWORD_SIZE(sp)
    load_x x19, portSTACK_X19_IDX * portWORD_SIZE(sp)
    load_x x20, portSTACK_X20_IDX * portWORD_SIZE(sp)
    load_x x21, portSTACK_X21_IDX * portWORD_SIZE(sp)
    load_x x22, portSTACK_X22_IDX * portWORD_SIZE(sp)
    load_x x23, portSTACK_X23_IDX * portWORD_SIZE(sp)
    load_x x24, portSTACK_X24_IDX * portWORD_SIZE(sp)
    load_x x25, portSTACK_X25_IDX * portWORD_SIZE(sp)
    load_x x26, portSTACK_X26_IDX * portWORD_SIZE(sp)
    load_x x27, portSTACK_X27_IDX * portWORD_SIZE(sp)
    load_x x28, portSTACK_X28_IDX * portWORD_SIZE(sp)
    load_x x29, portSTACK_X29_IDX * portWORD_SIZE(sp)
    load_x x30, portSTACK_X30_IDX * portWORD_SIZE(sp)
    load_x x31, portSTACK_X31_IDX * portWORD_SIZE(sp)


    load_x t0,portSTACK_PXCODE_IDX * portWORD_SIZE(sp)
    csrw sepc,t0

    load_x t0, portSTACK_SSTATUS_IDX * portWORD_SIZE( sp )
    csrw sstatus, t0  

    addi sp, sp, portSTACK_FRAME_SIZE

    sret
  
freertos_risc_v_stimer_interrupt_handler:
    portcontext_SAVE_CONTEXT_INTR
    call irq_stimer_handler
    call prvTickISR
    portcontext_RESTORE_CONTEXT
    sret


