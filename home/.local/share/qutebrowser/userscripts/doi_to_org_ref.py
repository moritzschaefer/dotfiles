#!/usr/bin/env python3
"""Qutebrowser userscript scraping the current web page for DOIs and opening org-protocol"""

import os
import re
import sys
from collections import Counter
from urllib import parse as url_parse
from urllib import request as url_request

FIFO_PATH = os.getenv("QUTE_FIFO")

def message_fifo(message, level="warning"):
    """Send message to qutebrowser FIFO. The level must be one of 'info',
    'warning' (default) or 'error'."""
    with open(FIFO_PATH, "w") as fifo:
        fifo.write("message-{} '{}'".format(level, message))

source = os.getenv("QUTE_HTML")
with open(source) as f:
    text = f.read()

# only search for DOI if nothing is selected
if not (doi := os.getenv('QUTE_SELECTED_TEXT', None)):
    url = os.getenv("QUTE_URL")

    # find DOIs on page using regex
    dval = re.compile(r'(10\.(\d)+/([^(\s\>\"\<)])+[^(\s\>\"\<).])')
    # https://stackoverflow.com/a/10324802/3865876, too strict
    # dval = re.compile(r'\b(10[.][0-9]{4,}(?:[.][0-9]+)*/(?:(?!["&\'<>])\S)+)\b')
    dois = dval.findall(text)


    # if 'nature.com/' in url:  # hacky maybe not even smart/necessary
    #     # use the last one
    #     doi = dois[-1][0]
    #     href = f'org-protocol://doi-to-bibtex?doi={url_parse.quote(doi)}'
    if 'arxiv.org/' in url:
        # doi variable is isused vor arxiv-id
        doi = re.compile(r'arXiv:((\d){4}\.(\d)+)').findall(text)[0][0]
        href = f'org-protocol://arxiv-to-bibtex?arxiv={url_parse.quote(doi)}'
    else:
        dois = Counter(e[0] for e in dois)
        try:
            doi = re.sub('v[0-9]$', '', dois.most_common(1)[0][0])
        except IndexError:
            message_fifo("No DOIs found on page")
            sys.exit()
        href = f'org-protocol://doi-to-bibtex?doi={url_parse.quote(doi)}'
else:
    href = f'org-protocol://doi-to-bibtex?doi={url_parse.quote(doi)}'
    
message_fifo(f"Selecting {doi}", level="info")

# Now call org-capture or so...
# options:
# - org-protocol
try:
    k = 'QUTE_FIFO'
    cmd_fifo = os.environ[k] if k in os.environ else ''
    with open(cmd_fifo, 'w') as f:
        #f.write('message-info "pykeepass failed to be imported."\n')
        f.write(f'message-info "Found DOI/arXiv: {doi} "\n')
        f.write(f'open javascript:void(location.href=\'{href}\')\n')
        f.flush()
except FileNotFoundError as e:
    pass

