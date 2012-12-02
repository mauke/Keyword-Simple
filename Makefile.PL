#!perl
# vi: set et sw=4 sts=4:
use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Keyword::Simple',
    AUTHOR              => q{Lukas Mai <l.mai@web.de>},
    VERSION_FROM        => 'lib/Keyword/Simple.pm',
    ABSTRACT_FROM       => 'lib/Keyword/Simple.pm',
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '6.56',
    },
    LICENSE => 'perl',
    PL_FILES => {},
    BUILD_REQUIRES => {
        'strict' => 0,
        'Dir::Self' => 0,
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'Carp' => 0,
        'XSLoader' => 0,
        'warnings' => 0,
        'B::Hooks::EndOfScope' => 0,
    },
    MIN_PERL_VERSION => '5.12.0',
    META_MERGE => {
        resources => {
            repository => {
                url => 'git://github.com/mauke/Keyword-Simple.git',
                web => 'https://github.com/mauke/Keyword-Simple',
                type => 'git',
            },
        },
    },
    depend => { Makefile => '$(VERSION_FROM)' },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Keyword-Simple-*' },
);
