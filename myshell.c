#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/syscall.h>

void myShell(void) {
    const char *env = getenv("PATH");
    //printf("%s\n",env);
    int stop = 0; // the variable to stop the loop
    char commandHistory[100][100];
    int index = 0;
    pid_t process1;
    pid_t selfpid = getpid();

    // the main loop of the shell
    while (stop == 0) {
        char *token;
        char *command;
        char commandBuffer[100] = {0};
        char** arguments = (char*) calloc(100,sizeof(char*));
        for( int i=0; i<100; i++ ) {
            arguments[i] = (char*)malloc(101);
        }

        // prompt user for input
        printf("$ ");
        fflush(stdout);
        fgets(commandBuffer, 100, stdin);
        token = strtok(commandBuffer, " ");
        command = token;
        command[strcspn(command, "\n")] = 0;
        strcpy(arguments[0], command);
        int j = 1;
        while (token != NULL) {
            token = strtok(NULL, " ");
            if (token != NULL) {
                token[strcspn(token, "\n")] = 0;
                strcpy(arguments[j], token);
            }
            j++;
        }
        //strcpy(arguments[j], "\0");
        arguments[j-1] = NULL;

        // commandHistory[index] = *(command);

        if (strcmp(command, "exit") == 0) {
            stop = 1;
        } else if (strcmp(command, "history") == 0) {
            char temp[106]={0};
            sprintf(temp,"%d",selfpid);
            strcat(temp," ");
            strcat(temp,command);
            strcpy(commandHistory[index], temp);
            index++;
            for (int i = 0; i <= index; i++) {
                // check if the string is terminated with \n
                printf("%s\n", commandHistory[i]);
            }
        } else if (strcmp(command, "cd") == 0) {
            char temp[106]={0};
            sprintf(temp,"%d",selfpid);
            strcat(temp," ");
            strcat(temp,command);
            strcpy(commandHistory[index], temp);
            index++;
            if (chdir(arguments[1]) != 0) {
                perror("chdir failed");
            }
        } else {
            process1 = fork();
            //if the fork is successful and we are in child process
            if (process1 == 0) {
//                if (execvp(command, arguments) != 0) {
//                    perror(error);
//                }
                execvp(command, arguments);
                for( int i=0; i<100; i++ ) {
                    free(arguments[i]);
                }
                free(arguments);
            }
            else if(process1==-1){
                perror("fork failed");
            }
            // parent process
            else {
                char temp[106]={0};
                sprintf(temp,"%d",process1);
                strcat(temp," ");
                strcat(temp,command);
                strcpy(commandHistory[index], temp);
                index++;
                wait(&process1);
            }

        }
    }
}

int main(int argc, char *argv[]) {
    char cwd[1024];
    getcwd(cwd, sizeof(cwd));
    //printf("Current working dir: %s\n", cwd);
    myShell();
    return 0;
}