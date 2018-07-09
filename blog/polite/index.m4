m4_include(`commons.m4')

_HEADER_HL1(`"Polite customer" problem and Z3 SMT-solver')

<p>This is probably not relevant in the era of credit cards, but...</p>

<p>In shop or bar, you have to pay something in cash and, as a polite customer, you try to give such a set of banknotes,
so that the cashier will not touch small banknotes in his/her cash desk, which are valuable (because of
impoliteness of other customers).</p>

<p>For small amount of money, this can be solved in one's mind, but for large...</p>

<p>The problem is surprisingly easy to solve using Z3 SMT-solver:</p>

_PRE_BEGIN
m4_include(`blog/polite/polite.py')
_PRE_END

_PRE_BEGIN
sat                                                                                                                               
from_cash_register_1= 0
from_cash_register_3= 0
from_cash_register_5= 0
from_cash_register_10= 2
from_cash_register_25= 0
from_cash_register_50= 0
from_cash_register_100= 0
from_cash_register= 20

from_customer_wallet_1= 2
from_customer_wallet_3= 1
from_customer_wallet_5= 0
from_customer_wallet_10= 0
from_customer_wallet_25= 0
from_customer_wallet_50= 11
from_customer_wallet_100= 16
from_customer= 2155
_PRE_END

<p>Now what if we don't care about small banknotes, but want to make transaction as paperless as possible:</p>

_PRE_BEGIN
...

# minimize number of all banknotes in transaction:
s.minimize(
from_cash_register_1 + 
from_cash_register_3 + 
from_cash_register_5 + 
from_cash_register_10 + 
from_cash_register_25 + 
from_cash_register_50 + 
from_cash_register_100 +
from_customer_wallet_1 +
from_customer_wallet_3 +
from_customer_wallet_5 +
from_customer_wallet_10 +
from_customer_wallet_25 +
from_customer_wallet_50 +
from_customer_wallet_100)

...
_PRE_END

_PRE_BEGIN
sat
from_cash_register_1= 0
from_cash_register_3= 0
from_cash_register_5= 1
from_cash_register_10= 1
from_cash_register_25= 0
from_cash_register_50= 0
from_cash_register_100= 0
from_cash_register= 15

from_customer_wallet_1= 0
from_customer_wallet_3= 0
from_customer_wallet_5= 0
from_customer_wallet_10= 0
from_customer_wallet_25= 0
from_customer_wallet_50= 3
from_customer_wallet_100= 20
from_customer= 2150
_PRE_END

<p>Likewise, you can minimize banknotes from cashier only, or from customer only.</p>

_BLOG_FOOTER()

