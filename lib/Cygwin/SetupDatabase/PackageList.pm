package Cygwin::SetupDatabase::PackageList;

use strict;
use warnings;
use v5.10;
use Moo;
use warnings NONFATAL => 'all';
use Cygwin::SetupDatabase::Package;

# ABSTRACT: Cygwin package list
# VERSION

sub BUILDARGS
{
  my $class = shift;
  if(@_ % 2) {  # FIXME single hash arg
    my $raw = shift;    
    my %ret = @_;
    my($preamble, @package_list) = split /@/, $raw;
    foreach my $line (split /\n/, $preamble)
    {
      $line =~ s/^#.*$//;
      next if $line =~ /^\s*$/;
      if($line =~ /^(.*):\s*(.*)$/)
      {
        my($key,$val) = ($1,$2);
        $key =~ s/-/_/g;
        $ret{$key} = $val;
      }
    }
    $ret{packages} = \@package_list;
    return \%ret;
  }
  return $class->SUPER::BUILDARGS(@_);
}

has packages => (
  is      => 'ro',
  default => sub { [] },
  coerce  => sub {
    [map { ref $_ ? $_ : Cygwin::SetupDatabase::Package->new($_) } @{ $_[0] }];
  },
);

sub size { int @{ shift->packages } }

foreach my $key (qw( release arch setup_timestamp setup_version ))
{ has $key => ( is => 'ro' ) }

1;