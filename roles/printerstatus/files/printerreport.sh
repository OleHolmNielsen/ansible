#!/bin/sh

/usr/local/bin/printerstatus.sh b307-m830 ly307-225-co1 ly307-225-bw1 b307-m602 b311-4525 |& mail -s 'Fysik B307/311 printers status' henning@fysik.dtu.dk
/usr/local/bin/printerstatus.sh ly307-001-bw1 LY311-070-CO1 |& mail -s 'Fysik B307/311 printers status' ljcoe@dtu.dk
/usr/local/bin/printerstatus.sh cryoprt b309-4525 ws4525 ppfe-5550dn |& mail -s 'Fysik B309 printers status' snim@fysik.dtu.dk
/usr/local/bin/printerstatus.sh ipf8300 ly309-142-co1 b309-m577 |& mail -s 'Fysik B309 printers status' maje@fysik.dtu.dk
/usr/local/bin/printerstatus.sh case4015 ly307-east-co1 b312-m725 cinf4015 b312-m553 |& mail -s 'Fysik B307/312 printers status' bpkn@fysik.dtu.dk
