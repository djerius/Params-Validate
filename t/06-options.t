use strict;

BEGIN
{
    $ENV{PERL_NO_VALIDATION} = 0;
    require Params::Validate;
    Params::Validate->import(':all');
}

use Test;
BEGIN { plan test => 7 }

Params::Validate::validation_options( stack_skip => 2 );

sub foo
{
    validate(@_, { bar => 1 });
}

sub bar { foo(@_) }

sub baz { bar(@_) }

eval { baz() };

ok( $@ );
ok( $@ =~ /mandatory.*missing.*call to main::bar/i );

Params::Validate::validation_options( stack_skip => 3 );

eval { baz() };

ok( $@ );
ok( $@ =~ /mandatory.*missing.*call to main::baz/i );

Params::Validate::validation_options( on_fail => sub { die { hash => 'ref' } } );

eval { baz() };

ok( $@ );
ok( ref $@ eq 'HASH' );
ok( $@->{hash} eq 'ref' );
