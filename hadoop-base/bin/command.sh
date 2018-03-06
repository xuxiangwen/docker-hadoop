#!/bin/bash
command=$1
echo `date "+%Y-%m-%d %H:%M:%S"`: $command
eval $command

