/***************************************************************************
 *   Copyright (C) 2012 by Max Thrun                                       *
 *   Copyright (C) 2012 by Ian Cathey                                      *
 *   Copyright (C) 2012 by Mark Labbato                                    *
 *                                                                         *
 *   Embedded System - Readers Writers                                     *
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
#include "reader_writer.h"

// mutexes
OS_EVENT *mutex_wr;
OS_EVENT *mutex_rd;
OS_EVENT *mutex_num_readers;

// task stacks
OS_STK reader_stk[NUM_READERS][TASK_STACKSIZE];
OS_STK writer_stk[TASK_STACKSIZE];

// number of readers currently accessing the buffer
unsigned char num_readers = 0;

// helper functions to make code more readable
void pend(OS_EVENT *pevent) { OSSemPend(pevent, 0, NULL); }
void post(OS_EVENT *pevent) { OSSemPost(pevent); }

void reader(void *pdata) {

    INT8U i = 0;

    while(true) {

        // wait for exclusive read access
        printf_debug("[R%d] Waiting for read lock...\n", pdata);
        pend(mutex_rd);

        // request access to the 'num_readers' variable
        printf_debug("[R%d] Waiting for num_readers lock...\n", pdata);
        pend(mutex_num_readers);

        // if we are the first reader wait for writer to finish
        if (num_readers == 0) {
            printf_debug("[R%d] Waiting to lock out writer...\n", pdata);
            pend(mutex_wr);
        }

        // we are currently reading so increase the count
        num_readers++;

        // release the 'num_readers' variable
        post(mutex_num_readers);

        // we don't really need exclusive read access anymore.
        // realeasing this allows the higher priority write task
        // to run if it's waiting
        post(mutex_rd);

        printf_reader("[R%d] ", pdata);
        for (i=0; i<book_mark; i++)
            printf_reader("%s ", book[i][0]);
        printf("\n");

        OSTimeDlyHMSM(0,0,5-(int)pdata,0);
        //OSTimeDlyHMSM(0,0,1,0);

        // request access to the 'num_readers' variable
        pend(mutex_num_readers);

        // we are done reading
        printf_debug("[R%d] Decrementing num_readers...\n", pdata);
        num_readers--;

        // if we are the last reader release the write lock
        if (num_readers == 0) {
            printf_debug("[R%d] Releasing the writer lockout...\n", pdata);
            post(mutex_wr);
        }

        // release the 'num_readers' variable
        post(mutex_num_readers);
    }
}

void writer(void *pdata) {

    while(true) {

        // wait for reader to finish
        printf_debug("[W0] Waiting to lock out reader...\n");
        pend(mutex_rd);

        // request exclusive access
        printf_debug("[W0] Waiting for gain write lock...\n");
        pend(mutex_wr);

        if (book_mark == WORDS_IN_BOOK) book_mark = 0;

        book[book_mark][0] = pangram[book_mark][0];
        printf_writer("[W0] %s \n", book[book_mark][0]);

        book_mark++;

        // no longer need exclusive write access
        printf_debug("[W0] giving up write lock...\n");
        post(mutex_wr);

        // let the readers continue
        printf_debug("[W0] giving up reader lockout...\n");
        post(mutex_rd);

        OSTimeDlyHMSM(0,0,1,0);
    }
}


void  reader_writer_init() {

    INT8U i = 0;
    INT8U return_code = OS_NO_ERR;
    book_mark = 0;

    //initialize pangram
    pangram[0][0] = "A\0";
    pangram[1][0] = "quick\0";
    pangram[2][0] = "brown\0";
    pangram[3][0] = "fox\0";
    pangram[4][0] = "jumps\0";
    pangram[5][0] = "over\0";
    pangram[6][0] = "the\0";
    pangram[7][0] = "lazy\0";
    pangram[8][0] = "dog\0";

    //create writer
    return_code = OSTaskCreate(writer, NULL, (void*)&writer_stk[TASK_STACKSIZE-1], WRITER_PRIO);
    alt_ucosii_check_return_code(return_code);

    //create reader
    for (i=0; i<NUM_READERS; i++) {
        return_code = OSTaskCreate(reader, (void*)i, (void*)&reader_stk[i][TASK_STACKSIZE-1], READER_PRIO+i);
        alt_ucosii_check_return_code(return_code);
    }
}


int main (int argc, char* argv[], char* envp[]) {

    printf("\e[0m");
    printf("----------------------\n");
    
    mutex_wr = OSSemCreate(1);
    mutex_rd = OSSemCreate(1);
    mutex_num_readers = OSSemCreate(1);

    printf("Init..\n");

    reader_writer_init();
    
    printf("Starting..\n");

    OSStart();

    return 0;

}
