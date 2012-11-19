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

// list of eaters
Eater eater[NUM_EATERS];

// task stacks
OS_STK stack[NUM_EATERS][TASK_STACKSIZE];

// helper functions to make code more readable
void pend(OS_EVENT *pevent) { INT8U rt;  OSSemPend(pevent, 0, &rt); alt_ucosii_check_return_code(rt);}
void post(OS_EVENT *pevent) { INT8U rt = OSSemPost(pevent);         alt_ucosii_check_return_code(rt);}
void delay(int x)           { OSTimeDlyHMSM(0,0,x,0); }

void eater_task(void *pdata) {

    Eater eater = *(Eater*)pdata;

    while(1) {

        eater.state = THINKING;             // we are now thinking
        eater.time = random(1,8);           // set how much time we want to think for
        print(INFO, eater);                 // display the new state
        delay(eater.time);                  // think

        // always pick up the lowest numbered fork first
        if (eater.left_fork < eater.right_fork) {

            eater.state = WAITING_LEFT;     // we are now waiting for left fork
            print(DEBUG, eater);            // display this as a debug message
            pend(forks[eater.left_fork]);   // wait for the fork to become free

            eater.state = WAITING_RIGHT;    // we are now waiting for right fork
            print(DEBUG, eater);            // display this as a debug message
            pend(forks[eater.right_fork]);  // wait for the fork to become free

        } else {

            eater.state = WAITING_RIGHT;    // we are now waiting for right fork
            print(DEBUG, eater);            // display this as a debug message
            pend(forks[eater.right_fork]);  // wait for the fork to become free

            eater.state = WAITING_LEFT;     // we are now waiting for left fork
            print(DEBUG, eater);            // display this as a debug message
            pend(forks[eater.left_fork]);   // wait for the fork to become free

        }

        eater.state = EATING;               // we are now eating
        eater.time = random(1,8);           // set how much time we want to eat for
        eater.bites++;                      // we ate another bite
        print(INFO, eater);                 // display this new state
        delay(eater.time);                  // eat

        eater.state = PUTTING_RIGHT;        // we are now putting right fork down
        print(DEBUG, eater);                // display this as a debug message
        post(forks[eater.right_fork]);      // release the fork

        eater.state = PUTTING_LEFT;         // we are now putting left fork down
        print(DEBUG, eater);                // display this as a debug message
        post(forks[eater.left_fork]);       // release the fork

    }
}


void init(void) {

    int i = 0;

    // initialize random number gen
    init_random();

    // initialize print function
    init_print();

    // initialize eaters
    for (i=0; i<NUM_EATERS; i++) {
        eater[i].num = i;                          // this eaters number
        eater[i].right_fork = i;                   // index of fork on right
        eater[i].left_fork = (i+1) % NUM_EATERS;   // index of fork on left
        eater[i].time = 0;                         // time in seconds to 'think' and 'eat'
        eater[i].bites = 0;                        // number of times this eater has eaten
    }

    // init mutexes
    for (i=0; i<NUM_EATERS; i++)
        forks[i] = OSSemCreate(1);

    //create eaters
    for (i=0; i<NUM_EATERS; i++) {
        int rt = OSTaskCreate(eater_task, (void*)&eater[i], (void*)&stack[i][TASK_STACKSIZE-1], i);
        alt_ucosii_check_return_code(rt);
    }

}


int main (int argc, char* argv[], char* envp[]) {

    printf("----------------------\n");

    init();

    clear_screen();

    OSStart();

    return 0;

}

