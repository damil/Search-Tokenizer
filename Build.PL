use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Search::Tokenizer',
    license             => 'perl',
    dist_author         => q{Laurent Dami <lau......da..@justice.ge.ch>},
    dist_version_from   => 'lib/Search/Tokenizer.pm',
    requires            => { 'Text::Transliterator::Unaccent' => 0, },
    build_requires      => { 'Test::More'                     => 0, },
    add_to_cleanup      => [ 'Search-Tokenizer-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
