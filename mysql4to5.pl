#!/usr/bin/perl
#
# mysql4to5 - converts MySQL4-queries to MySQL5-compatible-queries
#
# For USAGE & DESCRIPTION please refer to accompanying README.md
#
# AUTHOR
# Chris Vertonghen <chrisv(at)cpan(dot)org>
#
# COPYRIGHT AND LICENSE
# Copyright (C) 2014 Chris Vertonghen
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

use 5.006;

use strict;
use warnings;
use File::Find qw(finddepth);
use File::Copy qw(move);

my @files;
finddepth(sub {
	return if($_ eq '.' || $_ eq '..');
	push @files, $File::Find::name if($_ =~ /\.sql$/);
}, '.');

local $/=undef;
foreach my $infile (@files) {
	open (IN, "<$infile") or die "Couldn't open '$infile' for reading: $!\n";
	my ($oldline, $newline);
	$oldline = $newline = <IN>;
	close IN;

	# fix SELECT statements
	$newline =~ s/\s+from\s+([^\(].*?)(?!,\s+)where\s+/ from \($1\) where /ig;
	$newline =~ s/from\s+\=\>\s+'(.*?)',/FROM \=\> '\($1\)',/ig;
	# fix UPDATE statements
	$newline =~ s/\s+update\s+([^\(].*?)(?!,\s+)set\s+/ update \($1\) set /ig;

	# if changed, backup original file and write out updated file
	if ($newline ne $oldline) {
		my $bakfile = $infile . ".pre-mysql4to5";
		if (move($infile, $bakfile)) {
			print "$infile\n";
			open (OUT, ">$infile") or die "Can't open '$infile' for writing: $!\n";
			print OUT $newline;
			close OUT;
		} else {
			die "Can't move '$infile' to '$bakfile': $!\n";
		}
	}
}
1;
