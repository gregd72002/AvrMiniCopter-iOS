//
//  getgateway.h
//  RPiCameraStreamer
//
//  Created by Gregory Dymarek on 27/01/2015.
//
//

#ifndef __RPiCameraStreamer__getgateway__
#define __RPiCameraStreamer__getgateway__

#include <stdio.h>
#include <stdio.h>
#include <netinet/in.h>
#include <stdlib.h>
#include <sys/sysctl.h>
#include "route.h"
#include <net/if.h>

int getdefaultgateway(in_addr_t * addr);

#endif /* defined(__RPiCameraStreamer__getgateway__) */
