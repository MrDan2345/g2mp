/* Startup code for programs linked with GNU libc.
   Copyright (C) 1998, 1999, 2000, 2001 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02111-1301 USA.  */

    .section ".text"
    .globl FPC_SHARED_LIB_START
    .type  FPC_SHARED_LIB_START,@function
FPC_SHARED_LIB_START:
    mflr     0
    stw      0,4(1)
    stwu     1,-32(1)

    /* store argument count (in r3)*/
    lis     11,operatingsystem_parameter_argc@ha
    stw      3,operatingsystem_parameter_argc@l(11);
    /* store argument vector (in r4) */
    lis     11,operatingsystem_parameter_argv@ha
    stw      4,operatingsystem_parameter_argv@l(11);
    /* store environment pointer (in r5) */
    lis     11,operatingsystem_parameter_envp@ha
    stw      5,operatingsystem_parameter_envp@l(11);

    lis     11,__stkptr@ha
    stw      1,__stkptr@l(11);

    /* call library initialization */
    bl         PASCALMAIN

    /* return to the caller */
    addi     1,1,32
    lwz      0,4(1)
    mtlr     0
    blr

    .globl  _haltproc
     .type   _haltproc,@function
_haltproc:
    lis     11,operatingsystem_result@ha
    lwz      3,operatingsystem_result@l(3)
    li       0,234        /* exit group call */
    sc

    lis     11,operatingsystem_result@ha
    lwz      3,operatingsystem_result@l(3)
    li       0,1          /* exit call */
    sc
    /* we should not reach here. Crash horribly */
    trap

/* Define a symbol for the first piece of initialized data.  */
    .section ".data"
    .globl __data_start
__data_start:
data_start:

    .section ".bss"

    .type __stkptr, @object
    .size __stkptr, 4
    .global __stkptr
__stkptr:
    .skip 4

    .type operatingsystem_parameters, @object
    .size operatingsystem_parameters, 12
operatingsystem_parameters:
    .skip 3 * 4
    .global operatingsystem_parameter_argc
    .global operatingsystem_parameter_argv
    .global operatingsystem_parameter_envp
    .set operatingsystem_parameter_argc, operatingsystem_parameters+0
    .set operatingsystem_parameter_argv, operatingsystem_parameters+4
    .set operatingsystem_parameter_envp, operatingsystem_parameters+8

.section .note.GNU-stack,"",%progbits
