use inc::Module::Install;
name 'Yomico';
all_from 'lib/Yomico.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
