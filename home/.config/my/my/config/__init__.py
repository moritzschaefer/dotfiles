### HPI personal config
## see
# https://github.com/karlicoss/HPI/blob/master/doc/SETUP.org#setting-up-modules
# https://github.com/karlicoss/HPI/blob/master/doc/MODULES.org
## for some help on writing your own config

# to quickly check your config, run:
# hpi config check

# to quickly check a specific module setup, run hpi doctor <module>, e.g.:
# hpi doctor my.reddit

import pytz  # yes, you can use any Python stuff in the config
### useful default imports
from my.core import PathIsh, Paths, get_files

### you can insert your own configuration below
### but feel free to delete the stuff above if you don't need ti


class google:
    # you can pass the directory, a glob, or a single zip file
    takeout_path = '/backups/takeouts/*.zip'

# (reddit)
# twitter!
# github
# feedly

# class instapaper:
#     export_path = '/data/exports/instapaper'


class pdfs:
    paths = ['/home/moritz/tmp/papers/']  # TODO s/tmp/wiki

class twint:
    export_path = '/home/moritz/orger/data/twint/db.sqlite'

class twitter_archive:
    export_path = '/home/moritz/orger/data/twitter_archives/*.zip'
