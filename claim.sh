#!/bin/bash

## Run ledger to find the balance in the checkings account.  Divide by
## the number of current members and round up to the £0.5.
##
## Each time we claim the cost for the coffee, we also claim £1 for
## the savings accounts.  This is to be used in the longer run, to buy
## cleaning and descaling tablets, parts, repairs, and maybe buy a new
## machine in the future.

set -e

N_MEMBERS=`awk -f current-members.awk journal.dat | wc -l`
BALANCE=`ledger -f journal.dat balance checking | awk '{print $2}'`

CHARGE="8.0" # TODO

printf '%s claim from members\n' "$(date +%Y/%m/%d)"
printf '  checking\n'
printf '  savings  £%.1f\n' $(expr $N_MEMBERS \* 1)
for NAME in $(awk -f current-members.awk journal.dat | sort); do
   printf '  member:%s  £-%s\n' "$NAME" "$CHARGE"
done
