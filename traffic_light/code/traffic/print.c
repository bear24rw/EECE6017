/***************************************************************************
 *   Copyright (C) 2012 by Max Thrun                                       *
 *   Copyright (C) 2012 by Ian Cathey                                      *
 *   Copyright (C) 2012 by Mark Labbato                                    *
 *                                                                         *
 *   Embedded System - Print Functions                                     *
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
#include <string.h>
#include <unistd.h>
#include <stdarg.h>
#include "includes.h"
#include "print.h"
#include "traffic.h"

#define WIDTH   37
#define HEIGHT  19

const char diagram[HEIGHT][WIDTH] =
{
"              |   ,   |              ",
"              |   ,   |              ",
"              |   ,   |              ",
"              | 4 ,   |              ",
"             c|hhhhhhh|c             ",
"--------------v       l--------------",
"             h         h1            ",
"             h         h------ - - - ",
"             h         h3            ",
"=============h         h=============",
"            2h         h             ",
" - - - ------h         h             ",
"            0h         h             ",
"--------------n       r--------------",
"             c|hhhhhhh|c             ",
"              |   , 5 |              ",
"              |   ,   |              ",
"              |   ,   |              ",
"              |   ,   |              "
};

// light_loc = {x, y, character}
int light_loc[6][2] = {
    {13, 13}, // light 0
    { 7, 25}, // light 1
    {11, 13}, // light 2
    { 9, 25}, // light 3
    { 4, 17}, // light 4
    {16, 21}  // light 5
};

int car_loc[2][2] = {
    {11, 12},
    { 9, 26}
};

// mutex to protect ourselves while we print out a line
OS_EVENT *print_lock;

void init_print(void) {
    print_lock = OSSemCreate(1);
    draw_street();
}

void draw_status(const char *msg) {
    // obtain the lock so no other thread can interrupt us
    pend(print_lock);

    goto_line(1, HEIGHT+2);
    clear_line();
    set_color_bold(FG_WHITE);
    printf(msg);

    // we're done, release the lock
    post(print_lock);
}

void draw_sub_status(const char *msg) {
    // obtain the lock so no other thread can interrupt us
    pend(print_lock);

    goto_line(1, HEIGHT+3);
    clear_line();
    set_color_bold(FG_WHITE);
    printf(msg);

    // we're done, release the lock
    post(print_lock);
}

void draw_car(char yes) {

    // obtain the lock so no other thread can interrupt us
    pend(print_lock);

    // reset the colors
    reset_color();

    // if we are drawing a car make it cyan
    if (yes) set_color_bold(BG_CYAN);

    // draw car 0
    goto_line(car_loc[0][1], car_loc[0][0]);
    printf(" ");

    // draw car 1
    goto_line(car_loc[1][1], car_loc[1][0]);
    printf(" ");

    reset_color();

    // we're done, release the lock
    post(print_lock);
}

void draw_cross_walk(int walk) {
    if (walk) {
        set_color_bold(FG_GREEN);
        printf("\u270C");
    } else {
        set_color_bold(FG_RED);
        printf("\u25CF");
    }
}


void light_color(int light) {
    switch (light) {
        case RED:       set_color_bold(FG_RED);     break;
        case YELLOW:    set_color_bold(FG_YELLOW);  break;
        case GREEN:     set_color_bold(FG_GREEN);   break;
    }
}

void draw_street(void) {
    // obtain the lock so no other thread can interrupt us
    pend(print_lock);

    clear_screen();
    goto_line(0,0);
    set_color_bold(FG_WHITE);

    int x, y;
    for (y = 0; y < HEIGHT; y++)
    {
        for (x = 0; x < WIDTH; x++)
        {
 
            switch (diagram[y][x])
            {
                // http://www.utf8-chartable.de/unicode-utf8-table.pl

                // lane markers
                case '-': set_color_bold(FG_WHITE); printf("\u2500"); break;
                case '=': set_color(FG_YELLOW);     printf("\u2550"); break;
                case '|': set_color_bold(FG_WHITE); printf("\u2502"); break;
                case ',': set_color(FG_YELLOW);     printf("\u2551"); break;
                case 'v': set_color_bold(FG_WHITE); printf("\u2518"); break;
                case 'r': set_color_bold(FG_WHITE); printf("\u250C"); break;
                case 'n': set_color_bold(FG_WHITE); printf("\u2510"); break;
                case 'l': set_color_bold(FG_WHITE); printf("\u2514"); break;

                // cross walks
                //case 'h': set_color(FG_WHITE); printf("\u2573"); break;
                case 'h': printf(" "); break;

                //case 'c': cross_walk(0); break;

                default: printf("%c", diagram[y][x]);
            }
        }
        printf("\n");
    }

    // we're done, release the lock
    post(print_lock);
}


void draw_lights(int *lights) {

    // obtain the lock so no other thread can interrupt us
    pend(print_lock);

    // street lights
    goto_line(light_loc[0][1], light_loc[0][0]); light_color(lights[0]); printf("\u2192"); // right
    goto_line(light_loc[1][1], light_loc[1][0]); light_color(lights[1]); printf("\u2190"); // left
    goto_line(light_loc[2][1], light_loc[2][0]); light_color(lights[2]); printf("\u2191"); // up
    goto_line(light_loc[3][1], light_loc[3][0]); light_color(lights[3]); printf("\u2193"); // down
    goto_line(light_loc[4][1], light_loc[4][0]); light_color(lights[4]); printf("\u2193"); // down
    goto_line(light_loc[5][1], light_loc[5][0]); light_color(lights[5]); printf("\u2191"); // up

    // move cursor to bottom
    goto_line(1, HEIGHT);

    // we're done, release the lock
    post(print_lock);
}

