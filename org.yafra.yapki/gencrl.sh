#!/bin/sh
#-------------------------------------------------------------------------------
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# (c) yafra.org, 2002, Switzerland
#
# function:	generate revocation list
#
# argument: NONE
#
# CVS tag:   $Name:  $
# author:    $Author: mwn $
# revision:  $Revision: 24 $
#-------------------------------------------------------------------------------

# arguments are: 1: crl days
if [ -z "$1" ]; then
        echo Please specify crl days
        exit
fi

openssl ca -gencrl -config openssl.cnf -crldays $1 -crlexts crl_ext -out CA_ROOT/crl/cayafra.crl
openssl crl -in CA_ROOT/crl/cayafra.crl -outform DER -out CA_ROOT/crl/cayafra-der.crl

# copy your crl's to a publishing location now
#cp *.crl /YOUR_WWW
#cp *.crl /etc/apache2/ssl
#/usr/sbin/service apache2 reload