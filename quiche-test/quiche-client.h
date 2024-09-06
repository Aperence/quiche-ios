//
//  quiche-client.h
//  quiche-test
//
//  Created by Anthony Doeraene on 05/09/2024.
//

#ifndef quiche_client_h
#define quiche_client_h

#include <stdio.h>

typedef struct response {
    int status;
    char *res;
    int number_bytes;
} response_t;

response_t *fetch(const char *host, const char *port);

#endif /* quiche_client_h */
