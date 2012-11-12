package Keyword::Simple;

use v5.12.0;
use warnings;

use Carp qw(croak);
use B::Hooks::EndOfScope;

use XSLoader;
BEGIN {
	our $VERSION = '0.01';
	XSLoader::load;
}

# all shall burn
our @meta;

sub define {
	my ($kw, $sub) = @_;
	$kw =~ /^\p{XIDS}\p{XIDC}*\z/ or croak "'$kw' doesn't look like an identifier";
	ref($sub) eq 'CODE' or croak "'$sub' doesn't look like a coderef";

	my $n = @meta;
	push @meta, $sub;

	$^H{+HINTK_KEYWORDS} .= " $kw:$n";
	on_scope_end {
		delete $meta[$n];
	};
}

sub undefine {
	my ($kw) = @_;
	$kw =~ /^\p{XIDS}\p{XIDC}*\z/ or croak "'$kw' doesn't look like an identifier";

	$^H{+HINTK_KEYWORDS} .= " $kw:-";
}

'ok'

__END__

=encoding UTF-8

=head1 NAME

Keyword::Simple - define new keywords in pure Perl

=head1 SYNOPSIS

 package Some::Module;
 
 use Keyword::Simple;
 
 sub import {
     # create keyword 'provided', expand it to 'if' at parse time
     Keyword::Simple::define 'provided', sub {
         my ($ref) = @_;
         substr($$ref, 0, 0) = 'if';  # inject 'if' at beginning of parse buffer
     };
 }
 
 sub unimport {
     # lexically disable keyword again
     Keyword::Simple::undefine 'provided';
 }

 'ok'

=head1 DESCRIPTION

XXX write me

=head1 BUGS AND LIMITATIONS

Every new keyword is actually a complete statement by itself. The parsing magic
only happens afterwards. This means that e.g. the code in the L</SYNOPSIS>
actually does this:

  provided ($foo > 2) {
    ...
  }

  # expands to

  ; if
  ($foo > 2) {
    ...
  }

The C<;> represents a no-op statement, the C<if> was injected by the Perl code,
and the rest of the file is unchanged.

This also means your new keywords can only occur at the beginning of a
statement, not embedded in an expression.

There is no documentation.

There are barely any tests.

=head1 AUTHOR

Lukas Mai, C<< <l.mai at web.de> >>

=head1 COPYRIGHT & LICENSE

Copyright 2012 Lukas Mai.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
