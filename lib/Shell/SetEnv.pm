package Shell::SetEnv;
use strict;
use base qw(Exporter);
our $VERSION = '0.1';
our @EXPORT = qw(setenv);

=head1 NAME

Shell::SetEnv - Allows to import environment variables set by .bat file.

=head1 SYNOPSIS

  use Shell::SetEnv;
  setenv 'setenv.bat';
  # now %ENV is updated by setenv.bat
  
# or

  use Shell::SetEnv 'setenv.bat';

=cut

use Storable qw(thaw);

# setenv('setenv.bat');
sub setenv
{
  my $file = shift;
  my $script = 'use Storable qw(freeze); print freeze(\%ENV)';
  my $str = `"$file" 1>nul 2>nul & $^X -we "$script"`;
  die "An error occured while executing '$file'.\n";
  %ENV = %{thaw($str)};
}

sub import
{
  my $class = shift;
  my ($pck) = caller;
  no strict 'refs';
  *{$pck.'::'.$_} = \&{$_} for @EXPORT;
  setenv($_) for @_;
}

1;

__END__

=head1 METHODS

=over

=item setenv('filename.bat')

Execute 'filename.bat' and apply changes of environment variables to current %ENV. All variables, set by 'filename.bat', are available through %ENV.

=back

=head1 EXPORT

  setenv

=head1 AUTHOR

  Alexander Smirnov <zoocide@gmail.com>

=cut

