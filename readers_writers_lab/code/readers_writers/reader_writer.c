#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include "includes.h"
#include "alt_ucosii_simple_error_check.h"
#include "reader_writer.h"

/* Definition of shared_buf_sem Semaphore */
OS_EVENT *mutex_wr;
OS_EVENT *mutex_rd;
OS_EVENT *mutex_num_readers;

/* Definition of Task Stacks */
OS_STK reader_1_stk[TASK_STACKSIZE];
OS_STK reader_2_stk[TASK_STACKSIZE];
OS_STK reader_3_stk[TASK_STACKSIZE];
OS_STK writer_stk[TASK_STACKSIZE];

// number of readers accessing the buffer
unsigned char num_readers = 0;

// helper functions to make code more readable
void pend(OS_EVENT *pevent) { OSSemPend(pevent, 0, NULL); }
void post(OS_EVENT *pevent) { OSSemPost(pevent); }

void reader(void *pdata){

    while(true)
    {

        // wait for exclusive read access
        pend(mutex_rd);

        // request access to the 'num_readers' variable
        pend(mutex_num_readers);

        // if we are the first reader wait for writer to finish
        if (num_readers == 0) {
            printf_debug("Waiting to lock out writer...\n");
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

        printf_reader("Reader %d: ", pdata);
        INT8U index = 0;
        while(index < book_mark ){
            printf_reader("%s ", book[index][0]);
            index += 1;
        }
        printf("\n");

        OSTimeDlyHMSM(0,0,1,0);

        // request access to the 'num_readers' variable
        pend(mutex_num_readers);

        // we are done reading
        num_readers--;

        // if we are the last reader release the write lock
        if (num_readers == 0)
            post(mutex_wr);

        // release the 'num_readers' variable
        post(mutex_num_readers);

    }
}

void writer(void *pdata){

    while(true){

        // wait for reader to finish
        printf_debug("Writer: Waiting to lock out reader...\n");
        pend(mutex_rd);

        // request exclusive access
        printf_debug("Writer: Waiting for gain write lock...\n");
        pend(mutex_wr);

        if (book_mark == WORDS_IN_BOOK) book_mark = 0;

        book[book_mark][0] = pangram[book_mark][0];
        printf_writer("Writer: %s \n", book[book_mark][0]);

        book_mark++;

        // no longer need exclusive write access
        printf_debug("Writer: giving up write lock...\n");
        post(mutex_wr);

        // let the readers continue
        printf_debug("Writer: giving up reader lockout...\n");
        post(mutex_rd);

        OSTimeDlyHMSM(0,0,1,0);
    }
}


void  reader_writer_init()
{
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
    pangram[7][0] = "lazy\0";\
    pangram[8][0] = "dog\0";

    //create writer
    return_code = OSTaskCreate(writer, NULL, (void*)&writer_stk[TASK_STACKSIZE-1], WRITER_PRIO);
    alt_ucosii_check_return_code(return_code);

    //create reader
    return_code = OSTaskCreate(reader, (void*)1, (void*)&reader_1_stk[TASK_STACKSIZE-1], READER_1_PRIO);
    alt_ucosii_check_return_code(return_code);

    return_code = OSTaskCreate(reader, (void*)2, (void*)&reader_2_stk[TASK_STACKSIZE-1], READER_2_PRIO);
    alt_ucosii_check_return_code(return_code);

    return_code = OSTaskCreate(reader, (void*)3, (void*)&reader_3_stk[TASK_STACKSIZE-1], READER_3_PRIO);
    alt_ucosii_check_return_code(return_code);
}


int main (int argc, char* argv[], char* envp[])
{
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
