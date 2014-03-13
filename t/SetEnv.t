# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Exceptions.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use lib '../lib';
use Test::More tests => 4;
use Shell::SetEnv;
ok(1); # If we made it this far, we're ok.

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

use File::Temp qw(tempfile);
my ($file, $filename) = tempfile(SUFFIX => '.bat', UNLINK => 1);

my $uniq_var = "NOT_EXISTING_VARIABLE";
$uniq_var .= 'X' while exists $ENV{$uniq_var};

print $file "set $uniq_var=1\n";
close $file;

my ($exists, $val);
eval{
  setenv($filename);
  $exists = exists $ENV{$uniq_var};
  $val = $ENV{$uniq_var};
};
is($@, '');
ok($exists);
ok($val == 1);
