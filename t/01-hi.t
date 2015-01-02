#!perl
use warnings FATAL => 'all';
use strict;

use Test::More tests => 1;

{
  package MyIdiom;
  our @greetings;

  use Keyword::Simple;
  
  sub import {
    Keyword::Simple::define hi => sub {
      my($ref)=@_;
      substr($$ref, 0, 0) = 'push @MyIdiom::greetings, "Hello!";'; # inject greeting at beginning of parse buffer
    };
  }

  sub unimport {
    Keyword::Simple::undefine 'hi';
  }

  BEGIN { $INC{"MyIdiom.pm"} = 1; }
}

use MyIdiom;

hi    hi  hi hi hi 
hi    hi     hi
hi hi hi     hi
hi    hi     hi
hi    hi  hi hi hi

is_deeply(\@MyIdiom::greetings,[("Hello!") x 20],"We can chain and stack keywords");