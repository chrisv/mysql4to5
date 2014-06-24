# NAME

mysql4to5 - converts MySQL4-queries to MySQL5-compatible-queries

# USAGE

This is a perl-script; you start it from the terminal like so:

	perl mysql4to5.pl

Remember to put its location in your `$PATH` if you use it regularly. 

# DESCRIPTION

This scripts encloses, between round brackets, *all* SQL-statements
that don't enclose the tables (and their aliases, joins etc) listed 
between `FROM .. WHERE` and `UPDATE .. SET`

It doesn't matter if the SQL statements have been written out over 
multiple lines of code or not.

More specifically, this script does the following:

1. globs (recursively, from path of execution) for *.sql files

2. updates (via regex) SQL-statements found in each file

3. leaves original .sql files untouched

4. creates a .sql.new file for those files that needed updating

Sample .sql files can be found in the `/sample` directory

## SELECT statements:

Before: 

	select a.fone, b.fone, b.ftwo from atable a, btable b 
   		where a.fone=b.fone

After:

	select a.fone, b.fone, b.ftwo from (atable a, btable b) 
   		where a.fone=b.fone

## UPDATE statements:

Before:

	update atable a, btable b 
   		set a.fone="else", b.fone="else" where a.fone="something"

After:

	update (atable a, btable b) 
		set a.fone="else", b.fone="else" where a.fone="something"


# AUTHOR

Chris Vertonghen <chrisv(at)cpan(dot)org>

# COPYRIGHT AND LICENSE

Copyright (C) 2014 Chris Vertonghen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
