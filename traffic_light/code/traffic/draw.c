/***************************************************************************
 *   Copyright (C) 2012 by Max Thrun                                       *
 *   Copyright (C) 2012 by Ian Cathey                                      *
 *   Copyright (C) 2012 by Mark Labbato                                    *
 *                                                                         *
 *   Embedded System - Drawing Functions                                   *
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
#include "draw.h"
#include "traffic.h"

#define WIDTH   37
#define HEIGHT  19

const char diagram[HEIGHT][WIDTH] =
{
"              |   ,   |              ",
"              |   ,   |              ",
"              |   ,   |              ",
"              |   ,   |              ",
"             c| 0 ,   |c             ",
"--------------v       l--------------",
"                        5            ",
"                        ------ - - - ",
"                        4            ",
"=============           =============",
"            1                        ",
" - - - ------                        ",
"            2                        ",
"--------------n       r--------------",
"             c|   , 3 |c             ",
"              |   ,   |              ",
"              |   ,   |              ",
"              |   ,   |              ",
"              |   ,   |              "
};

#define FRAME_WIDTH     95
#define FRAME_HEIGHT    25
const char frame[FRAME_HEIGHT][FRAME_WIDTH] =
{
"0---------------------------------------------------------------------------------------------1",
"|                                                                                             |",
"| 0-------------------------------------1  0------------------------------------------------1 |",
"| |                                     |  |                                                | |",
"| |                                     |  |                                                | |",
"| |                                     |  |                                                | |",
"| |                                     |  |                                                | |",
"| |                                     |  |                                                | |",
"| |                                     |  |                                                | |",
"| |                                     |  |                                                | |",
"| |                                     |  |                                                | |",
"| |                                     |  |                                                | |",
"| |                                     |  2------------------------------------------------3 |",
"| |                                     |                                                     |",
"| |                                     |  0------------------------------------------------1 |",
"| |                                     |  |                                                | |",
"| |                                     |  |                                                | |",
"| |                                     |  |                                                | |",
"| |                                     |  |                                                | |",
"| |                                     |  |                                                | |",
"| |                                     |  |                                                | |",
"| |                                     |  |                                                | |",
"| 2-------------------------------------3  2------------------------------------------------3 |",
"|                                                                                             |",
"2---------------------------------------------------------------------------------------------3"
};

char pipes[6][6] = {
    "\u250C", // 0 =  ┌
    "\u2510", // 1 =  ┐
    "\u2514", // 2 =  └
    "\u2518", // 3 =  ┘
};

int keymap_loc[] = { 4, 45};
int street_loc[] = { 4,  4};
int status_loc[] = {16, 45};

int light_loc[6][2] = {
    { 5, 17}, // light 0
    {11, 13}, // light 1
    {13, 13}, // light 2
    {15, 21}, // light 3
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

// mutex to protect ourselves while we draw
OS_EVENT *draw_lock;

void draw_init(void) 
{
    draw_lock = OSSemCreate(1);
    draw_reset();
}

void draw_reset(void) 
{
    clear_screen();
    draw_frame(); 
    draw_keymap();
    draw_street();
    draw_walk(RED);
    draw_lights();
}

void set_light_color(int state) 
{
    switch (state) 
    {
        case RED:       set_color_bold(FG_RED);     break;
        case YELLOW:    set_color_bold(FG_YELLOW);  break;
        case GREEN:     set_color_bold(FG_GREEN);   break;
        case WAITING:   set_color_bold(FG_CYAN);    break;
        case OFF:       set_color_bold(FG_BLACK);   break;
    }
}

void draw_status(int y, const char *msg) 
{
    // obtain the lock so no other thread can interrupt us
    pend(draw_lock);

    set_color(FG_BLACK);
    set_color_bold(BG_WHITE);

    goto_line(status_loc[1], status_loc[0]+y);
    printf("                                               "); 

    goto_line(status_loc[1], status_loc[0]+y);
    printf(msg);

    reset_color();

    // we're done, release the lock
    post(draw_lock);
}

void draw_walk(int state) 
{
    // obtain the lock so no other thread can interrupt us
    pend(draw_lock);

    int i;
    for (i = 0; i < 4; i++) 
    {
        goto_line(street_loc[1] + walk_loc[i][1] - 1, 
                  street_loc[0] + walk_loc[i][0] - 1); 
        set_light_color(state);
        printf("C");
    }

    // we're done, release the lock
    post(draw_lock);
}

void draw_car(char yes) 
{

    // obtain the lock so no other thread can interrupt us
    pend(draw_lock);

    // reset the colors
    reset_color();

    // if we are drawing a car make it cyan
    if (yes) set_color_bold(BG_CYAN);

    // draw car 0
    goto_line(street_loc[1]+car_loc[0][1]-1, street_loc[1]+car_loc[0][0]-1);
    printf(" ");

    // draw car 1
    goto_line(street_loc[1]+car_loc[1][1]-1, street_loc[1]+car_loc[1][0]-1);
    printf(" ");

    reset_color();

    // we're done, release the lock
    post(draw_lock);
}


void draw_street(void) 
{

    // obtain the lock so no other thread can interrupt us
    pend(draw_lock);

    //clear_screen();
    //goto_line(0,0);
    set_color_bold(FG_WHITE);

    int x, y;
    for (y = 0; y < HEIGHT; y++)
    {
        goto_line(street_loc[1], street_loc[0]+y);

        for (x = 0; x < WIDTH; x++)
        {
 
            switch (diagram[y][x])
            {
                // http://www.utf8-chartable.de/unicode-utf8-table.pl

                // lane markers
                case '=': set_color_dim(FG_YELLOW); printf("\u2550"); break;
                case ',': set_color_dim(FG_YELLOW); printf("\u2551"); break;
                case '-': set_color_bold(FG_WHITE); printf("\u2500"); break;
                case '|': set_color_bold(FG_WHITE); printf("\u2502"); break;
                case 'v': set_color_bold(FG_WHITE); printf("\u2518"); break;
                case 'r': set_color_bold(FG_WHITE); printf("\u250C"); break;
                case 'n': set_color_bold(FG_WHITE); printf("\u2510"); break;
                case 'l': set_color_bold(FG_WHITE); printf("\u2514"); break;

                // cross walks
                case 'h': printf(" "); break;
                case 'c': printf("C"); break;

                default: printf("%c", diagram[y][x]);
            }
        }
    }

    reset_color();

    // we're done, release the lock
    post(draw_lock);
}


void draw_keymap(void) 
{
    // obtain the lock so no other thread can interrupt us
    pend(draw_lock);

    // figure out which x y to draw it at
    int x = keymap_loc[1];
    int y = keymap_loc[0];

    // draw the keymapping
    set_color(FG_BLACK);
    set_color_bold(BG_WHITE);
    goto_line(x, y+0); printf("[c] - Car in turn lane");
    goto_line(x, y+1); printf("[w] - Press walk button");
    goto_line(x, y+2); printf("[b] - Toggle broken");
    goto_line(x, y+3); printf("[e] - Emergency for %d seconds", emergency_duration);
    goto_line(x, y+4); printf("    [-/+] - Inc/Dec");
    goto_line(x, y+5); printf("[m] - Toggle manual");
    goto_line(x, y+6); printf("    [j/k] - Next/Prev light");
    goto_line(x, y+7); printf("    [1/2/3] - Red/Yellow/Green");
    goto_line(x, y+8); printf("[r] - Redraw");
    reset_color();

    // we're done, release the lock
    post(draw_lock);
}

void draw_lights(void) 
{

    // obtain the lock so no other thread can interrupt us
    pend(draw_lock);
   
    char light_arrows[6][6] = {
        "\u2193", // down
        "\u2191", // up
        "\u2192", // right
        "\u2191", // up
        "\u2193", // down
        "\u2190"  // left
    };

    int i = 0;
    for (i = 0; i < 6; i++) 
    {
        // goto light x,y
        goto_line(street_loc[1]+light_loc[i][1]-1, street_loc[0]+light_loc[i][0]-1); 
        
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
    post(draw_lock);
}

void draw_frame(void) 
{


    // obtain the lock so no other thread can interrupt us
    pend(draw_lock);

    clear_screen();
    goto_line(0,0);

    set_color_bold(FG_BLACK);
    set_color_bold(BG_WHITE);

    int x, y;
    for (y = 0; y < FRAME_HEIGHT; y++) 
    {
        for (x = 0; x < FRAME_WIDTH; x++) 
        {
            switch (frame[y][x]) 
            {
                case '-': printf("\u2500"); break;
                case '|': printf("\u2502"); break;
                case ' ': printf(" "); break;

                default: printf("%s", pipes[frame[y][x]-'0']);
            }
        }
        printf("\n");
    }

    reset_color();

    // we're done, release the lock
    post(draw_lock);
}


