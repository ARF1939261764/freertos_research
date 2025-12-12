#ifndef __PORT_H
#define __PORT_H

#define store_x          sd
#define load_x           ld

#define portWORD_SIZE         (8)
#define portSTACK_FRAME_SIZE  (32*portWORD_SIZE)

 #define portSTACK_RESERVED_IDX                31
 #define portSTACK_SSTATUS_IDX                 30
 #define portSTACK_XCRITICALNESTING_IDX        29
 #define portSTACK_X31_IDX                     28
 #define portSTACK_X30_IDX                     27
 #define portSTACK_X29_IDX                     26
 #define portSTACK_X28_IDX                     25
 #define portSTACK_X27_IDX                     24
 #define portSTACK_X26_IDX                     23
 #define portSTACK_X25_IDX                     22
 #define portSTACK_X24_IDX                     21
 #define portSTACK_X23_IDX                     20
 #define portSTACK_X22_IDX                     19
 #define portSTACK_X21_IDX                     18
 #define portSTACK_X20_IDX                     17
 #define portSTACK_X19_IDX                     16
 #define portSTACK_X18_IDX                     15
 #define portSTACK_X17_IDX                     14
 #define portSTACK_X16_IDX                     13
 #define portSTACK_X15_IDX                     12
 #define portSTACK_X14_IDX                     11
 #define portSTACK_X13_IDX                     10
 #define portSTACK_X12_IDX                     09
 #define portSTACK_X11_IDX                     08
 #define portSTACK_PVPARAMETERS_IDX            07
 #define portSTACK_X9_IDX                      06
 #define portSTACK_X8_IDX                      05
 #define portSTACK_X7_IDX                      04
 #define portSTACK_X6_IDX                      03
 #define portSTACK_X5_IDX                      02
 #define portSTACK_PORTTASK_RETURN_ADDRESS_IDX 01
 #define portSTACK_PXCODE_IDX                  00

#endif
