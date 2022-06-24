//Daniel Bronfman 

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

void myShell(void) {

    char commandHistory[100][100];
    int index = 0; // current index in the history array
    int process1;
    int selfpid = getpid();

    // the main loop of the shell
    while (1) {
        char *token;
        char *command;
        char commandBuffer[100] = {0};
        char **arguments = (char **) calloc(100, sizeof(char *));
        int i;
        for (i = 0; i < 100; i++) {
            arguments[i] = (char *) malloc(101);
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
        arguments[j - 1] = NULL;

        if (strcmp(command, "exit") == 0) {
            for (i = 0; i < 100; i++) {
                free(arguments[i]);
            }
            free(arguments);
            break;
        }
        else if (strcmp(command, "history") == 0) {
            char temp[106] = {0};
            sprintf(temp, "%d", selfpid);
            strcat(temp, " ");
            int i;
            for (i = 0; i < 100; i++) {
                if (arguments[i] == NULL)break;
                strcat(temp, arguments[i]);
                strcat(temp, " ");
            }
            strcpy(commandHistory[index], temp);
            index++;
            for (i = 0; i <= index; i++) {
                printf("%s\n", commandHistory[i]);
            }
        } else if (strcmp(command, "cd") == 0) {
            char temp[106] = {0};
            sprintf(temp, "%d", selfpid);
            strcat(temp, " ");
            int i;
            for (i = 0; i < 100; i++) {
                if (arguments[i] == NULL)break;
                strcat(temp, arguments[i]);
                strcat(temp, " ");
            }
            strcpy(commandHistory[index], temp);
            index++;
            if (chdir(arguments[1]) != 0) {
                perror("chdir failed");
            }
        }
        else {
            process1 = fork();
            char temp[106] = {0};
            // convert the pid of the process to int and add a space
            sprintf(temp, "%d", process1);
            strcat(temp, " ");
            int i;
            for (i = 0; i < 100; i++) {
                if (arguments[i] == NULL)break;
                strcat(temp, arguments[i]);
                strcat(temp, " ");
            }
            strcpy(commandHistory[index], temp);
            index++;
            //if the fork is successful and we are in child process
            if (process1 == 0) {
                if (execvp(command, arguments) != 0) {
                    perror("execvp failed");
                }
                int i;
                for (i = 0; i < 100; i++) {
                    free(arguments[i]);
                }
                free(arguments);
                return;
            } else if (process1 == -1) {
                perror("fork failed");
                for (i = 0; i < 100; i++) {
                    free(arguments[i]);
                }
                free(arguments);
            }
                // parent process
            else {
                wait(&process1);
            }
        }
    }
}

int main(int argc, char *argv[]) {
    char *env = getenv("PATH");
    int i;
    for (i = 0; i < argc; i++) {
        strcat(env, ":");
        strcat(env, argv[i]);
    }
    setenv("PATH", env, 1);

    myShell();
    return 0;
}
