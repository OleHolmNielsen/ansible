#!/usr/bin/env python2
# -*- coding: iso-8859-1 -*-
"""
    MoinMoin - CGI/FCGI Driver script

    @copyright: 2000-2005 by Juergen Hermann <jh@web.de>,
                2008 by MoinMoin:ThomasWaldmann,
                2008 by MoinMoin:FlorianKrupicka
    @license: GNU GPL, see COPYING for details.
"""

import sys, os

# Addition at fysik.dtu.dk:
sys.path.insert(0, '/var/www/wiki')
from MoinMoin import log
log.load_config('/usr/share/moin/config/logging/stderr')

# this works around a bug in flup's CGI autodetection (as of flup 1.0.1):
os.environ['FCGI_FORCE_CGI'] = 'Y' # 'Y' for (slow) CGI, 'N' for FCGI

from MoinMoin.web.flup_frontend import CGIFrontEnd
CGIFrontEnd().run()

