# NAME

Keyword::Simple - define new keywords in pure Perl

# SYNOPSIS

```perl
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
```

# DESCRIPTION

Warning: This module is still new and experimental. The API may change in
future versions. The code may be buggy.

This module lets you implement new keywords in pure Perl. To do this, you need
to write a module and call
[`Keyword::Simple::define`](#keywordsimpledefine) in your `import`
method. Any keywords defined this way will be available in the lexical scope
that's currently being compiled.

## Functions

- `Keyword::Simple::define`

    Takes two arguments, the name of a keyword and a coderef. Injects the keyword
    in the lexical scope currently being compiled. For every occurrence of the
    keyword, your coderef will be called with one argument: A reference to a scalar
    holding the rest of the source code (following the keyword).

    You can modify this scalar in any way you like and after your coderef returns,
    perl will continue parsing from that scalar as if its contents had been the
    real source code in the first place.

- `Keyword::Simple::undefine`

    Takes one argument, the name of a keyword. Disables that keyword in the lexical
    scope that's currently being compiled. You can call this from your `unimport`
    method to make the `no Foo;` syntax work.

# BUGS AND LIMITATIONS

This module depends on the [pluggable keyword](https://metacpan.org/pod/perlapi.html#PL_keyword_plugin)
API introduced in perl 5.12. Older versions of perl are not supported.

Every new keyword is actually a complete statement by itself. The parsing magic
only happens afterwards. This means that e.g. the code in the ["SYNOPSIS"](#synopsis)
actually does this:

```perl
provided ($foo > 2) {
  ...
}

# expands to

; if
($foo > 2) {
  ...
}
```

The `;` represents a no-op statement, the `if` was injected by the Perl code,
and the rest of the file is unchanged.

This also means your new keywords can only occur at the beginning of a
statement, not embedded in an expression.

There are barely any tests.

# SUPPORT AND DOCUMENTATION

After installing, you can find documentation for this module with the
[`perldoc`](https://metacpan.org/pod/perldoc) command.

```sh
perldoc Keyword::Simple
```

You can also look for information at
[https://metacpan.org/pod/Keyword::Simple](https://metacpan.org/pod/Keyword::Simple).

To see a list of open bugs, visit
[https://rt.cpan.org/Public/Dist/Display.html?Name=Keyword-Simple](https://rt.cpan.org/Public/Dist/Display.html?Name=Keyword-Simple).

To report a new bug, send an email to
`bug-Keyword-Simple [at] rt.cpan.org`.

# AUTHOR

Lukas Mai, `<l.mai at web.de>`

# COPYRIGHT & LICENSE

Copyright (C) 2012, 2013 Lukas Mai.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.
