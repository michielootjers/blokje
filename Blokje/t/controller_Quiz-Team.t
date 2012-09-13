use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Blokje' }
BEGIN { use_ok 'Blokje::Controller::Quiz::Team' }

ok( request('/quiz/team')->is_success, 'Request should succeed' );
done_testing();
