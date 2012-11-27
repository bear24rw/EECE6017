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
"              | 0 ,   |              ",
"             c|hhhhhhh|c             ",
"--------------v       l--------------",
"             h         h5            ",
"             h         h------ - - - ",
"             h         h4            ",
"=============h         h=============",
"            1h         h             ",
" - - - ------h         h             ",
"            2h         h             ",
"--------------n       r--------------",
"             c|hhhhhhh|c             ",
"              |   , 3 |              ",
"              |   ,   |              ",
"              |   ,   |              ",
"              |   ,   |              "
};

int light_loc[6][2] = {
    { 4, 17}, // light 0
    {11, 13}, // light 1
    {13, 13}, // light 2
    {16, 21}, // light 3
    { 9, 25}, // light 4
    { 7, 25}  // light 5
};

int car_loc[2][2] = {
    {11, 12}, // car 0
    { 9, 26}  // car 1
};

int walk_loc[4][2] = {
    { 5, 14}, // cross walk 0
    {15, 14}, // cross walk 1
    { 5, 24}, // cross walk 2
    {15, 24}  // cross walk 3
 };

// mutex to protect ourselves while we print out a line
OS_EVENT *print_lock;

void init_print(void) {
    print_lock = OSSemCreate(1);
    draw_street();
}

void set_light_color(int state) {
    switch (state) {
        case RED:       set_color_bold(FG_RED);     break;
        case YELLOW:    set_color_bold(FG_YELLOW);  break;
        case GREEN:     set_color_bold(FG_GREEN);   break;
        case WAITING:   set_color_bold(FG_CYAN);    break;
        case OFF:       set_color_bold(FG_BLACK);   break;
    }
}


void draw_status(int y, const char *msg) {
    // obtain the lock so no other thread can interrupt us
    pend(print_lock);

    goto_line(1, HEIGHT+1+y);
    clear_line();
    set_color_bold(FG_WHITE);
    printf(msg);

    // we're done, release the lock
    post(print_lock);
}

void draw_walk(int state) {

    // obtain the lock so no other thread can interrupt us
    pend(print_lock);

    int i;
    for (i = 0; i < 4; i++) {
        goto_line(walk_loc[i][1], walk_loc[i][0]); 
        set_light_color(state);
        printf("C");
    }

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
                case 'c': printf("C"); break;

                default: printf("%c", diagram[y][x]);
            }
        }
        printf("\n");
    }

    // draw the keymapping
    set_color_bold(FG_WHITE);
    goto_line(WIDTH+1,1); printf("[c] - Car in turn lane");
    goto_line(WIDTH+1,2); printf("[w] - Press walk button");
    goto_line(WIDTH+1,3); printf("[b] - Toggle broken");
    goto_line(WIDTH+1,4); printf("[m] - Toggle manual");
    goto_line(WIDTH+1+4, 5); printf("[j/k] - Next/Prev light");
    goto_line(WIDTH+1+4, 6); printf("[1/2/3] - Red/Yellow/Green");

    // we're done, release the lock
    post(print_lock);
}


void draw_lights(int *lights) {

    // obtain the lock so no other thread can interrupt us
    pend(print_lock);
   
    char light_arrows[6][6] = {
        "\u2193", // down
        "\u2191", // up
        "\u2192", // right
        "\u2191", // up
        "\u2193", // down
        "\u2190"  // left
    };

    int i = 0;
    for (i = 0; i < 6; i++) {
        // goto light x,y
        goto_line(light_loc[i][1], light_loc[i][0]); 
        
        if (manual_mode && i == selected_light) set_color_bold(BG_BLUE);

        // set it to proper color
        set_light_color(lights[i]); 

        // draw the arrow for this light
        printf(light_arrows[i]);

        reset_color();
    }

    // move cursor to bottom
    goto_line(1, HEIGHT);

    // we're done, release the lock
    post(print_lock);
}

