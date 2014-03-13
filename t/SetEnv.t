# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Exceptions.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use lib '../lib';
use Test::More tests => 9;
use Shell::SetEnv;
ok(1); # If we made it this far, we're ok.

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

use File::Temp qw(tempfile);

## create temporary .bat file ##
my ($file, $filename) = tempfile(SUFFIX => '.bat', UNLINK => 1);

## generate a free variable name ##
my $uniq_var = "NOT_EXISTING_VARIABLE";
$uniq_var .= 'X' while exists $ENV{$uniq_var};

## set new variable in the .bat file ##
print $file "set $uniq_var=1\n";
close $file;

## execute .bat  file ##
my %h = %ENV;
eval{ setenv($filename) };
is($@, '');
ok(exists $ENV{$uniq_var});
ok($ENV{$uniq_var} == 1);
%ENV = %h;

## compile-time version ##
eval "use Shell::SetEnv '$filename'";
is($@, '');
ok(exists $ENV{$uniq_var});
ok($ENV{$uniq_var} == 1);
%ENV = %h;

#### check errors ####

## make name for not existing file ##
(undef, $filename) = tempfile(SUFFIX => '.bat', OPEN => 0);
eval{ setenv($filename) };
ok($@);

## compile-time version ##
eval "use Shell::SetEnv '$filename'";
ok($@);
