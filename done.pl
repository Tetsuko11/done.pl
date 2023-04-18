#! /usr/bin/env perl

use strict;
use warnings;

my $memo = "path of memo file"; # メモファイル
my $done_log = "path of DONE"; # DONEを保存するファイル

my @after_memo;
my $flag = 0;

unless (-f $done_log) {
    open DONE, ">", $done_log
        or die "cannot open $done_log because $!\n";
    print DONE "*DONE logfile\n";
    close DONE;
}

open MEMO, "<", $memo
    or die "cannot open $memo because $!\n";
open DONE, ">>", $done_log
    or die "cannot open $done_log because $!\n";

for my $done (<MEMO>) {
    if ($done =~ /^\*\*\sDONE/) {
        print DONE $done;
        $flag = 1;
    } elsif ($flag) {
        if ($done =~ /^\*+\s(?!DONE)/) {
            push @after_memo, $done;
            $flag = 0;
        } else {
            print DONE $done;
        }
    } else {
        push @after_memo, $done;
    }
}
close MEMO;
close DONE;

open MEMO, ">", $memo
    or die "cannot open $memo because $!\n";

print MEMO @after_memo;

close MEMO;
