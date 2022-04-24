#!/bin/bash

# adjust working directory
if [[ -f empty_commit.sh ]]  # in scripts dir
then
  cd ..
fi

flutter test --coverage
genhtml coverage/lcov.info -o coverage
open coverage/index.html
