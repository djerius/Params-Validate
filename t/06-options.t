use strict;

use Params::Validate qw(:all);

use Test;
BEGIN { plan test => 4 }

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
