#!/usr/bin/env python3
"""Qutebrowser userscript for extraction of miRNAs from miRNAsong
"""

import json
import os
import re

import pyperclip

FIFO_PATH = os.getenv("QUTE_FIFO")


def message_fifo(message, level="warning"):
    """Send message to qutebrowser FIFO. The level must be one of 'info',
    'warning' (default) or 'error'."""
    with open(FIFO_PATH, "w") as fifo:
        fifo.write("message-{} '{}'".format(level, message))


source = os.getenv("QUTE_TEXT")
with open(source) as f:
    text = f.read()

# find DOIs on page using regex
mval = re.compile(r'\w+-(?:miR|let)-[0-9\-p]*')
# https://stackoverflow.com/a/10324802/3865876, too strict
# mval = re.compile(r'\b(10[.][0-9]{4,}(?:[.][0-9]+)*/(?:(?!["&\'<>])\S)+)\b')
mirnas = [e for e in mval.findall(text)]

pyperclip.copy(json.dumps(mirnas))
