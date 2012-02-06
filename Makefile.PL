use inc::Module::Install;
name 'Yomico';
all_from 'lib/Yomico.pm';

requires 'Plack';
requires 'Text::Markdown';
requires 'Text::Xslate';
requires 'Path::Class';

install_script 'yomico';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
