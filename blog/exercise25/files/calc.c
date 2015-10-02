// copypasted from http://stackoverflow.com/a/13895198 and reworked

// Bare bones scanner and parser for the following LL(1) grammar:
// expr -> term { [+-] term }     ; An expression is terms separated by add ops.
// term -> factor { [*/] factor } ; A term is factors separated by mul ops.
// factor -> unsigned_factor      ; A signed factor is a factor, 
//         | - unsigned_factor    ;   possibly with leading minus sign
// unsigned_factor -> ( expr )    ; An unsigned factor is a parenthesized expression 
//         | NUMBER               ;   or a number
//
// The parser returns the floating point value of the expression.

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

// The token buffer. We never check for overflow! Do so in production code.
char buf[1024];
int n = 0;

// The current character.
int ch;

// The look-ahead token.  This is the 1 in LL(1).
enum { ADD_OP, MUL_OP, LEFT_PAREN, RIGHT_PAREN, NOT_OP, NUMBER, END_INPUT, PIPE } look_ahead;

// Forward declarations.
void init(void);
void advance(void);
int expr(void);
void error(char *msg);

void print_bin (int v)
{
	bool one_printed=false;
	for (int i=31; i>=0; i--)
	{
		int digit=(v>>i)&1;
		if (one_printed)
			printf ("%d", digit);
		else
			if (digit)
			{
				printf ("1");
				one_printed=true;
			}
			else
			{
				// supress leading zero
			};
	};
};

// Parse expressions, one per line. 
int main(void)
{
	init();
	while (1)
	{
		int val = expr();
		printf("(unsigned) dec: %u hex: 0x%X ", val, val);
		printf (" bin: ");
		print_bin (val);
		printf ("\n");

		if (val<0)
		{
			printf("(signed) dec: -%d hex: -0x%X ", -val, -val);
			printf (" bin: -");
			print_bin (-val);
			printf ("\n");
		};

		if (look_ahead != END_INPUT)
			error("junk after expression");
		advance();  // past end of input mark
	}
	return 0;
}

// Just die on any error.
void error(char *msg)
{
	fprintf(stderr, "Error: %s. Exiting.\n", msg);
	exit(1);
}

// Buffer the current character and read a new one.
void read()
{
	buf[n++] = ch;
	buf[n] = '\0';  // Terminate the string.
	ch = getchar();
}

// Ignore the current character.
void ignore()
{
	ch = getchar();
}

// Reset the token buffer.
void reset()
{
	n = 0;
	buf[0] = '\0';
}

// including 'x' to handle numbers like 0xabcd
bool my_is_digit (char c)
{
	if (isxdigit (c))
		return true;
	if (c=='x' || c=='X')
		return true;
	return false;
};

// The scanner.  A tiny deterministic finite automaton.
int scan()
{
	reset();
START:
	// first character is digit?
	if (my_is_digit (ch))
		goto DIGITS;

	switch (ch)
	{
		case ' ': case '\t': case '\r':
			ignore();
			goto START;

		case '-': case '+': case '^':
			read();
			return ADD_OP;

		case '~':
			read();
			return NOT_OP;

		case '*': case '/': case '%':
			read();
			return MUL_OP;

		case '(':
			read();
			return LEFT_PAREN;

		case ')':
			read();
			return RIGHT_PAREN;
		
		case '|':
			read();
			return PIPE;
		
		case '\n':
			ch = ' ';    // delayed ignore()
			return END_INPUT;

		default:
			error("bad character");
	}

DIGITS:
	if (my_is_digit (ch))
	{
		read();
		goto DIGITS;
	}
	else	
		return NUMBER;
}

// To advance is just to replace the look-ahead.
void advance()
{
	look_ahead = scan();
}

// Clear the token buffer and read the first look-ahead.
void init()
{
	reset();
	ignore(); // junk current character
	advance();
}
			
int get_number(char *buf)
{
	int rt;
	char *endptr;
	if (buf[0]=='0')
	{
		if (buf[1]=='x')
		{
			// hexadecimal: 0xabcd
			rt=strtoul (buf+2, &endptr, 16);
		}
		else if (buf[1]=='b')
		{
			// binary: 0b10101010
			rt=strtoul (buf+2, &endptr, 2);
		}
		else 
		{
			// octal: 0600
			rt=strtoul (buf+1, &endptr, 8);
		}
	}
	else
	{
		// decimal
		rt=strtoul (buf, &endptr, 10);
	};

	// is the whole buffer has been processed?
	if (strlen(buf)!=endptr-buf)
	{
		fprintf (stderr, "invalid number: %s\n", buf);
		exit(0);
	};
	return rt;
};

int my_abs(int v)
{
	if (v<0)
		return -v;
	return v;
};

int unsigned_factor()
{
	int rtn = 0;
	switch (look_ahead)
	{
		case NUMBER:
			rtn=get_number(buf);
			advance();
			break;

		case LEFT_PAREN:
			advance();
			rtn = expr();
			if (look_ahead != RIGHT_PAREN) error("missing ')'");
			advance();
			break;

		case PIPE:
			advance();
			rtn = my_abs(expr());
			if (look_ahead != PIPE) error("missing enclosing '|'");
			advance();
			break;

		default:
			error("unexpected token");
	}
	return rtn;
}

int factor()
{
	int rtn = 0;
	// If there is a leading minus...
	if (look_ahead == ADD_OP && buf[0] == '-')
	{
		advance();
		rtn = -unsigned_factor();
	}
	else if (look_ahead == NOT_OP && buf[0] == '~') // NOT
	{
		advance();
		rtn = ~unsigned_factor();
	}
	else
		rtn = unsigned_factor();

	return rtn;
}

int term()
{
	int rtn = factor();
	while (look_ahead == MUL_OP)
	{
		switch(buf[0])
		{
			case '*':
				advance(); 
				rtn *= factor(); 
				break; 

			case '/':
				advance();
				rtn /= factor();
				break;
			case '%':
				advance();
				rtn %= factor();
				break;
		}
	}
	return rtn;
}

int expr()
{
	int rtn = term();
	while (look_ahead == ADD_OP)
	{
		switch(buf[0])
		{
			case '+': 
				advance();
				rtn += term(); 
				break; 

			case '-':
				advance();
				rtn -= term();
				break;
			case '^':
				advance();
				rtn ^= term();
				break;
		}
	}
	return rtn;
}

