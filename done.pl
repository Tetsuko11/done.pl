#! /usr/bin/env perl

use strict;
use warnings;

my $memo = "path of memo file"; # メモファイル
my $doneLog = "path of DONE"; # DONEを保存するファイル

my @afterMemo;
my $flag = 0;

unless (-f $doneLog) {
    open DONE, ">", $doneLog
        or die "cannot open $doneLog because $!\n";
    print DONE "*DONE logfile\n";
    close DONE;
}

open MEMO, "<", $memo
    or die "cannot open $memo because $!\n";
open DONE, ">>", $doneLog
    or die "cannot open $doneLog because $!\n";

for my $done (<MEMO>) {
    if ($done =~ /^\*\*\sDONE/) {
        print DONE $done;
        $flag = 1;
    } elsif ($flag) {
        if ($done =~ /^\*+\s/ and $done !~ /^\*+\sDONE/) {
            push @afterMemo, $done;
            $flag = 0;
        } else {
            print DONE $done;
        }
    } else {
        push @afterMemo, $done;
    }
}
close MEMO;
close DONE;

open MEMO, ">", $memo
    or die "cannot open $memo because $!\n";

print MEMO @afterMemo;

close MEMO;
