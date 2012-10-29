
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include "includes.h"
#include "alt_ucosii_simple_error_check.h"
#include "reader_writer.h"



/* Definition of shared_buf_sem Semaphore */
OS_EVENT *mutex_access;         // exclusive access for either all the readers of the writer
OS_EVENT *mutex_num_readers;    // protect the 'num_readers' variable

/* Definition of Task Stacks */
OS_STK reader_1_stk[TASK_STACKSIZE];
OS_STK reader_2_stk[TASK_STACKSIZE];
OS_STK reader_3_stk[TASK_STACKSIZE];
OS_STK writer_stk[TASK_STACKSIZE];

// number of readers accessing the buffer
unsigned char num_readers = 0;

void elipsis(){
	INT8U i;
	for(i=0; i<3; i++){
		printf(".");
		OSTimeDlyHMSM(0,0,1,0);
	}
}

void reader(void *pdata){
	INT8U return_code;

	while(true)
	{

        // request access to the 'num_readers' variable
		OSSemPend(mutex_num_readers, 0, &return_code);

        // if we are the first reader request exclusive access for the readers
        if (num_readers == 0)
            OSSemPend(mutex_access, 0, &return_code);

        // we are currently readering so increase the count
        num_readers++;

        // release the 'num_readers' variable
        OSSemPost(mutex_num_readers);

        printf("\e[1;36mReader %d: ", pdata);
        INT8U index = 0;
        while(index < book_mark){
            printf("%s ", book[index][0]);
            index += 1;
        }
        printf("\n");

        // request access to the 'num_readers' variable
        OSSemPend(mutex_num_readers, 0, &return_code);

        // we are done reading
        num_readers--;

        // if we are the last reader, release exclusive access
        if (num_readers == 0)
            OSSemPost(mutex_access);

        // release the 'num_readers' variable
        OSSemPost(mutex_num_readers);
        
        OSTimeDlyHMSM(0,0,1,0);
	}
}

void writer(void *pdata){
	INT8U return_code;

	while(true){

        // request exclusive access
		OSSemPend(mutex_access, 0 , &return_code);

		if(book_mark == WORDS_IN_BOOK -1){
			book_mark = 0;
		}

		book[book_mark][0] = pangram[book_mark][0];
		printf("\e[1;31mWriter: %s \n", book[book_mark][0]);

		book_mark += 1;

        // no longer need exclusive access
        OSSemPost(mutex_access);

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
    
    mutex_access = OSSemCreate(1);
    mutex_num_readers = OSSemCreate(1);

    printf("Init..\n");

	reader_writer_init();
    
    printf("Starting..\n");

	OSStart();

	return 0;
}
