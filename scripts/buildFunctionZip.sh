#!/bin/bash

cd function

python -m venv venv
. venv/bin/activate
pip install -r requirements.txt

zip function.zip *.txt
