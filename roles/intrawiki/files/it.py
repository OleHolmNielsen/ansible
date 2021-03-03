# -*- coding: iso-8859-1 -*-
# IMPORTANT! This encoding (charset) setting MUST be correct! If you live in a
# western country and you don't know that you use utf-8, you probably want to
# use iso-8859-1 (or some other iso charset). If you use utf-8 (a Unicode
# encoding) you MUST use: coding: utf-8
# That setting must match the encoding your editor uses when you modify the
# settings below. If it does not, special non-ASCII chars will be wrong.

"""
This is a sample config for a wiki that is part of a wiki farm and uses
farmconfig for common stuff. Here we define what has to be different from
the farm's common settings.
"""

# we import the FarmConfig class for common defaults of our wikis:
from farmconfig import FarmConfig

# now we subclass that config (inherit from it) and change what's different:
class Config(FarmConfig):

    # basic options (you normally need to change these)
    sitename = u'IT-wiki' # [Unicode]
    interwikiname = u'IT-wiki' # [Unicode]

    # name of entry page / front page [Unicode], choose one of those:

    # a) if most wiki content is in a single language
    #page_front_page = u"MyStartingPage"

    # b) if wiki content is maintained in many languages
    page_front_page = u"it"

    # Must NOT be under the web-server tree /var/www, see docs/INSTALL.html
    data_dir = '/var/moin/it/data/'

    # The default theme anonymous or new users get
    theme_default = 'classic'
    # Use Restructured text as default markup
    default_markup = 'rst'

    # Allow read access ONLY to the AdminGroup
    acl_rights_before = u"AdminGroup:read,write,delete,revert,admin"
    acl_rights_default = u"All:"
    acl_rights_after = u"ReadGroup:read"
