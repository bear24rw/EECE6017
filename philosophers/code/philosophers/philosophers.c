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
#include "print.h"

// each fork is its own mutex
OS_EVENT *forks[NUM_EATERS];

// task stacks
OS_STK stack[NUM_EATERS][TASK_STACKSIZE];

// helper functions to make code more readable
void pend(OS_EVENT *pevent) { INT8U rt;  OSSemPend(pevent, 0, &rt); alt_ucosii_check_return_code(rt);}
void post(OS_EVENT *pevent) { INT8U rt = OSSemPost(pevent);         alt_ucosii_check_return_code(rt);}
void delay(int x)           { OSTimeDlyHMSM(0,0,x,0); }

void eater(void *pdata) {

    // which number philosopher are we?
    int num = (int)pdata;

    // figure out which number fork is to our right and left
    int right_fork = num;
    int left_fork = (num+1) % NUM_EATERS;

    // time in seconds to 'think' and 'eat'
    int time = 0;

    // number of times this eater has eaten
    int bites = 0;

    while(1) {

        // think
        time = random(1,8);
        print(NORM, num, bites, "Thinking for %ds...\n", time);
        delay(time);

        // we always pick up the lowest numbered fork first
        if (left_fork < right_fork) {

            // wait to pick up left fork
            print(DEBUG, num, bites, "Waiting to pick up left fork (%d)...\n", left_fork);
            pend(forks[left_fork]);

            // wait to pick up right fork
            print(DEBUG, num, bites, "Waiting to pick up right fork (%d)...\n", right_fork);
            pend(forks[right_fork]);

        } else {

            // wait to pick up right fork
            print(DEBUG, num, bites, "Waiting to pick up right fork (%d)...\n", right_fork);
            pend(forks[right_fork]);

            // wait to pick up left fork
            print(DEBUG, num, bites, "Waiting to pick up left fork (%d)...\n", left_fork);
            pend(forks[left_fork]);

        }

        // eat
        time = random(1,8);
        print(NORM, num, bites, "Eating for %ds...\n", time);
        delay(time);
        bites++;

        // put down right fork
        print(DEBUG, num, bites, "Putting down right fork(%d)...\n", right_fork);
        post(forks[right_fork]);

        // put down left fork
        print(DEBUG, num, bites, "Putting down left fork (%d)...\n", left_fork);
        post(forks[left_fork]);

    }
}


void init(void) {

    int i = 0;

    // initialize random number gen
    init_random();

    // initialize print function
    init_print();

    // init mutexes
    for (i=0; i<NUM_EATERS; i++)
        forks[i] = OSSemCreate(1);

    //create eaters
    for (i=0; i<NUM_EATERS; i++) {
        int return_code = OSTaskCreate(eater, (void*)i, (void*)&stack[i][TASK_STACKSIZE-1], i);
        alt_ucosii_check_return_code(return_code);
    }

}


int main (int argc, char* argv[], char* envp[]) {

    printf("----------------------\n");

    init();

    clear_screen();

    OSStart();

    return 0;

}

