/***************************************************************************
 *   Copyright (C) 2012 by Max Thrun                                       *
 *   Copyright (C) 2012 by Ian Cathey                                      *
 *   Copyright (C) 2012 by Mark Labbato                                    *
 *                                                                         *
 *   Embedded System - Traffic Light                                       *
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
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include "traffic.h"
#include "print.h"

// task stacks
OS_STK stack_a[TASK_STACKSIZE];
OS_STK stack_b[TASK_STACKSIZE];
OS_STK stack_c[TASK_STACKSIZE];
OS_STK stack_d[TASK_STACKSIZE];
OS_STK stack_e[TASK_STACKSIZE];
OS_STK stack_f[TASK_STACKSIZE];

// traffic light values
int lights[6];

// traffic light mutex
OS_EVENT *light_lock;

// state of the whole system
int traffic_state = PRI_GREEN;

// helper functions to make code more readable
inline void pend(OS_EVENT *pevent) { INT8U rt;  OSSemPend(pevent, 0, &rt); alt_ucosii_check_return_code(rt);}
inline void post(OS_EVENT *pevent) { INT8U rt = OSSemPost(pevent);         alt_ucosii_check_return_code(rt);}

void task_a(void *pdata) {

    /*
        Primary Street is a main thoroughfare, with heavy traffic. Secondary Street is used by fewer vehicles.
        This difference should be reflected in the relative times that traffic on each street has a green signal.
    */


    int delay_time = 0;

    while(1) { 
        pend(light_lock);

        switch (traffic_state) {

            // primary street green
            case PRI_GREEN:

                lights[PRI_STRAIGHT_1] = GREEN;
                lights[PRI_STRAIGHT_2] = GREEN;
                delay_time = PRI_GREEN_TIME;
                traffic_state = PRI_YELLOW;
                draw_status("Primary green");
                break;

            // primary street yellow
            case PRI_YELLOW:

                lights[PRI_STRAIGHT_1] = YELLOW;
                lights[PRI_STRAIGHT_2] = YELLOW;
                delay_time = PRI_YELLOW_TIME;
                traffic_state = PRI_RED;
                draw_status("Primary yellow");
                break;

            // primary street red
            case PRI_RED:

                lights[PRI_STRAIGHT_1] = RED;
                lights[PRI_STRAIGHT_2] = RED;
                delay_time = PRI_RED_TIME;
                traffic_state = SEC_GREEN;
                draw_status("Primary red");
                break;

            // secondary street green
            case SEC_GREEN:

                lights[SEC_1] = GREEN;
                lights[SEC_2] = GREEN;
                delay_time = SEC_GREEN_TIME;
                traffic_state = SEC_YELLOW;
                draw_status("Secondary green");
                break;
   
            // secondary street yellow
            case SEC_YELLOW:

                lights[SEC_1] = YELLOW;
                lights[SEC_2] = YELLOW;
                delay_time = SEC_YELLOW_TIME;
                traffic_state = SEC_RED;
                draw_status("Secondary yellow");
                break;

            // secondary street red
            case SEC_RED:

                lights[SEC_1] = RED;
                lights[SEC_2] = RED;
                delay_time = SEC_RED_TIME;
                traffic_state = PRI_GREEN;
                draw_status("Secondary red");
                break;
        }

        // update the display with new light values
        draw_lights(lights);  

        // we are done changing the lights
        post(light_lock);

        // delay for however long this light is on for
        delay(delay_time);   
    }
}

void task_b(void *pdata) {

    /*
       Primary Street also has left turn lanes onto Secondary Street (in both directions). If there is a vehicle in
       either of these lanes when it is time for Primary Street to have a green signal, there should first be a task
       run to enable these vehicles to make left turns, while the other traffic on Primary Street and Secondary
       Street gets a stop signal.
    */

    int turn_state = CHECK_CARS;

    while(1) {
    
        switch (turn_state) {

            case CHECK_CARS:

                // delay a little bit so there isn't _always_ a car there
                delay(1);

                // 1 / 10 chance of there being a car there
                if (rand() % 10 == 0) {
                    draw_car(1);
                    draw_sub_status("Car waiting");
                    turn_state = WAIT_FOR_GREEN;
                } else {
                    draw_car(0);
                }

                break;

            case WAIT_FOR_GREEN:
                // is it time for the primary street to turn green?
                if (traffic_state == PRI_GREEN) {

                    draw_sub_status("Light about to be green. Taking control of lights");

                    // take control of the lights
                    pend(light_lock);

                    draw_sub_status("Turn in progress");
                    
                    turn_state = TURN_GREEN;
                }

                break;

            case TURN_GREEN:
                // its green, cars are gone
                draw_car(0);

                // turn on the turn lights
                lights[PRI_TURN_1] = GREEN;
                lights[PRI_TURN_2] = GREEN;

                // all other lights should be red
                lights[SEC_1] = RED;
                lights[SEC_2] = RED;
                lights[PRI_STRAIGHT_1] = RED;
                lights[PRI_STRAIGHT_2] = RED;
               
                // update the diagram with new light values
                draw_lights(lights);

                draw_status("Turn green");

                // wait for green light
                delay(TURN_GREEN_TIME);

                turn_state = TURN_YELLOW;

                break;

            case TURN_YELLOW:
                // turn lights are now yellow
                lights[PRI_TURN_1] = YELLOW;
                lights[PRI_TURN_2] = YELLOW;

                draw_status("Turn yellow");

                // update the diagram with new light values
                draw_lights(lights);

                // wait for yellow light
                delay(TURN_YELLOW_TIME);

                turn_state = TURN_RED;

                break;

            case TURN_RED:
                // turn lights are now red
                lights[PRI_TURN_1] = RED;
                lights[PRI_TURN_2] = RED;

                draw_status("Turn red");
                draw_sub_status("Turn complete");

                // update the diagram with new light values
                draw_lights(lights);

                // go back to wait for more cars
                turn_state = CHECK_CARS;

                // release control of the lights
                post(light_lock);

                break;
        }

        delay_ms(10);
    }
}

void task_c(void *pdata) {

    /*
       There are also pedestrian buttons for crossing both Primary Street and Secondary Street. If any of these
       buttons is pushed, a task to make all vehicles stop and allow for pedestrians to cross the streets should be
       run.
    */

    while(1) {
        delay(10);
    }
}

void task_d(void *pdata) {

    /*
       There is also an emergency setting, which sets lights in all directions to flashing red. This setting is
       triggered by a special signal which includes a specific duration to be in this state. At the end of this
       time, the system should return to task A.
    */

    while(1) {
        delay(10);
    }
}


void task_e(void *pdata) {

    /*
       There is also a “broken” setting which is activated when there is a power outage, e.g., and which sets the
       signals on Primary Street to flashing YELLOW and the signals on Secondary Street to flashing RED.
       This setting is deactivated manually, with a return to task A.
    */

    while(1) {
        delay(10);
    }
}


void task_f(void *pdata) {

    /*
       And finally there is a manual setting in which the signals are switched by hand. This task is triggered by
       a switch operated by a human and is turned off by another switch, at which time the system should
       return to task A.
    */

    while(1) {
        delay(10);
    }
}

void init(void) {

    // initialize print function
    init_print();

    // initialize light mutex
    light_lock = OSSemCreate(1);

    // initialize all lights to RED
    int i = 0;
    for (i = 0; i < 6; i++)
        lights[i] = RED;

    int rt;
    rt = OSTaskCreate(task_a, NULL, (void*)&stack_a[TASK_STACKSIZE-1], 5); alt_ucosii_check_return_code(rt);
    rt = OSTaskCreate(task_b, NULL, (void*)&stack_b[TASK_STACKSIZE-1], 4); alt_ucosii_check_return_code(rt);
    rt = OSTaskCreate(task_c, NULL, (void*)&stack_c[TASK_STACKSIZE-1], 3); alt_ucosii_check_return_code(rt);
    rt = OSTaskCreate(task_d, NULL, (void*)&stack_d[TASK_STACKSIZE-1], 2); alt_ucosii_check_return_code(rt);
    rt = OSTaskCreate(task_e, NULL, (void*)&stack_e[TASK_STACKSIZE-1], 1); alt_ucosii_check_return_code(rt);
    rt = OSTaskCreate(task_f, NULL, (void*)&stack_f[TASK_STACKSIZE-1], 0); alt_ucosii_check_return_code(rt);
}


int main (int argc, char* argv[], char* envp[]) {

    init();

    clear_screen();
    draw_lights(lights);
    draw_street();

    OSStart();

    return 0;

}

