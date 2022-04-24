#!/bin/bash

# adjust working directory
if [[ -f empty_commit.sh ]]  # in scripts dir
then
  cd ..
fi

flutter test --coverage --dart-define='ENVIRONMENT=testing' --dart-define='URI_BASE=http://127.0.0.1:8000'
genhtml coverage/lcov.info -o coverage
open coverage/index.html
