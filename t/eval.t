#!perl
use warnings FATAL => 'all';
use strict;

use Test::More tests => 4;

{
    package Foo;

    use Keyword::Simple;

    sub import {
        Keyword::Simple::define class => sub {
            substr ${$_[0]}, 0, 0, "package";
        };
    }

    sub unimport {
        Keyword::Simple::undefine 'peek';
    }

    BEGIN { $INC{"Foo.pm"} = 1; }
}

use Foo;

ok 1, "start";

{ class Gpkg0; our $v = __PACKAGE__; }

is $Gpkg0::v, 'Gpkg0';

eval q{ class Gpkg1; our $v = __PACKAGE__; };
is $@, '';
TODO: {
    local $TODO = "source filters don't work in string eval";
    no warnings 'once';
    is $Gpkg1::v, 'Gpkg1';
}
