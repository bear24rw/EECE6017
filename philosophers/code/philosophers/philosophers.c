/***************************************************************************
 *   Copyright (C) 2012 by Max Thrun                                       *
 *   Copyright (C) 2012 by Ian Cathey                                      *
 *   Copyright (C) 2012 by Mark Labbato                                    *
 *                                                                         *
 *   Embedded System - Dining Philosophers                                 *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.              *
 ***************************************************************************/

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include "includes.h"
#include "alt_ucosii_simple_error_check.h"
#include "philosophers.h"
#include "random.h"

// each fork is its own mutex
OS_EVENT *forks[NUM_EATERS];

// task stacks
OS_STK stack[NUM_EATERS][TASK_STACKSIZE];

// helper functions to make code more readable
void pend(OS_EVENT *pevent) { OSSemPend(pevent, 0, NULL); }
void post(OS_EVENT *pevent) { OSSemPost(pevent); }

void eater(void *pdata) {

    int num = (int)pdata;
    int left_fork = num;
    int right_fork = (num+1) % NUM_EATERS;
    int time = 0;

    while(1) {

        // think
        time = random(1,8);
        printf_eater(num, "[%d] Thinking for %ds...\n", num, time);
        OSTimeDlyHMSM(0,0,time,0);

        // wait to pick up left fork
        printf_debug("[%d] Waiting to pick up left fork (%d)...\n", num, left_fork);
        pend(forks[left_fork]);

        // wait to pick up right fork
        printf_debug("[%d] Waiting to pick up right fork (%d)...\n", num, right_fork);
        pend(forks[right_fork]);

        // eat
        time = random(1,8);
        printf_eater(num, "[%d] Eating for %ds...\n", num, time);
        OSTimeDlyHMSM(0,0,time,0);

        // put down right fork
        printf_debug("[%d] Putting down right fork(%d)...\n", num, right_fork);
        post(forks[right_fork]);

        // put down left fork
        printf_debug("[%d] Putting down left fork (%d)...\n", num, left_fork);
        post(forks[left_fork]);

    }
}


void init(void) {

    int i = 0;
    int return_code = OS_NO_ERR;

    // init mutexes
    for (i=0; i<NUM_EATERS; i++)
        forks[i] = OSSemCreate(1);

    //create eaters
    for (i=0; i<NUM_EATERS; i++) {
        return_code = OSTaskCreate(eater, (void*)i, (void*)&stack[i][TASK_STACKSIZE-1], i);
        alt_ucosii_check_return_code(return_code);
    }

}


int main (int argc, char* argv[], char* envp[]) {

    printf_debug("----------------------\n");
    
    printf_debug("Init..\n");

    init();
    
    printf_debug("Starting..\n");

    OSStart();

    return 0;

}

