#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

#define MAX_QUERY 22
#define MAX_CMD_LEN 1024

// Function to run a single query
void run_query(int query_num) {
    char cmd[MAX_CMD_LEN];
    pid_t pid;
    int status;

    // Set QDIR environment variable
    // setenv("QDIR", "./queries", 1);

    // Generate the query using qgen
   snprintf(cmd, MAX_CMD_LEN, "./qgen %d > query%d.sql", query_num, query_num);

    system(cmd);

    // Execute the query using psql
    snprintf(cmd, MAX_CMD_LEN, "psql -d tpch -f queries/query%d.sql", query_num);
    pid = fork();
    
    if (pid == 0) {
        // Child process
        execl("/bin/sh", "sh", "-c", cmd, NULL);
        exit(1);
    } else if (pid > 0) {
        // Parent process
        waitpid(pid, &status, 0);
        if (WIFEXITED(status)) {
            printf("Query %d completed with status %d\n", query_num, WEXITSTATUS(status));
        }
    }
}

// Function to run all queries
void run_all_queries() {
    printf("Running all TPC-H queries...\n");
    for (int i = 1; i <= MAX_QUERY; i++) {
        printf("\nExecuting Query %d...\n", i);
        run_query(i);
    }
}

// Function to run specific queries
void run_specific_queries(int* queries, int count) {
    printf("Running specific TPC-H queries...\n");
    for (int i = 0; i < count; i++) {
        printf("\nExecuting Query %d...\n", queries[i]);
        run_query(queries[i]);
    }
}

int main(int argc, char** argv) {
    // Check if database exists
    if (system("psql -lqt | cut -d \\| -f 1 | grep -qw tpch") != 0) {
        printf("Error: TPC-H database not found. Please create it first.\n");
        return 1;
    }

    if (argc > 1) {
        // Run specific queries
        int* queries = malloc((argc - 1) * sizeof(int));
        for (int i = 1; i < argc; i++) {
            queries[i-1] = atoi(argv[i]);
            if (queries[i-1] < 1 || queries[i-1] > MAX_QUERY) {
                printf("Error: Query number must be between 1 and %d\n", MAX_QUERY);
                free(queries);
                return 1;
            }
        }
        run_specific_queries(queries, argc - 1);
        free(queries);
    } else {
        // Run all queries
        run_all_queries();
    }

    return 0;
} 