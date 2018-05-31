#!/usr/bin/env awk

{
    if ($0 ~ /^; joins /)
        members[$3] = 1;
    else if ($0 ~ /^; leaves /)
        delete members[$3];
}

END {
    for (key in members)
        print key;
}
