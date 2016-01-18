#!/bin/bash

for i in {0..10}
do
    ../../utils/iltrans -il "mytest1.opq.$i.il" -il-formula "f$i.stp"
done
