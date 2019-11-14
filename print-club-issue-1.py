#!/usr/bin/env python

import subprocess

p = subprocess.run(['awk', '-f', 'current-members.awk', 'journal.dat'],
                   capture_output=True)
current_users = p.stdout.decode().splitlines()

p = subprocess.run(['ledger', '-f', 'journal.dat', 'balance', '--empty',
                    '--flat','--no-total', 'payees', 'member:'],
                   capture_output=True)

print('email | credit (£)\n'
      '------|------:')
for member_line in p.stdout.decode().splitlines():
    # Split will be (currency, value, member_id) if value is non-zero,
    # otherwise it will be (value, member_id).
    member_line_k = member_line.split()
    credit = float(member_line_k[-2])
    email = member_line_k[-1]
    if email.startswith('member:'):
        email = email[len('member:'):]
    else:
        raise RuntimeError('member balance query did not return member: name')
    if email in current_users:
        print('%s | %.2f' % (email, credit))
    elif credit != 0.0:
        raise RuntimeError('non current member %s has credit %f'
                           % (email, credit))
