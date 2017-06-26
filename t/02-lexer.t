use v6.c;
use Test;
use Time::Spec::at;
use Time::Spec::at::Grammar;

my sub tp ($rule,$str) { Time::Spec::at::Grammar::At.parse($str,:$rule) }

ok tp(<INT1DIGIT>, 9), "match an integer";

ok tp(<HOURMIN>, "12:30"), "hm 12:30";
ok tp(<HOURMIN>, "12h30"), "hm 12h30";
ok tp(<HOURMIN>, "12'30"), "hm 12'30";
ok tp(<HOURMIN>, "2'30"), "hm 2'30";
ok tp(<HOURMIN>, "2,30"), "hm 2,30";

ok tp(<DOTTEDDATE>, "12.08.69"), "dd 12.08.69";
ok tp(<DOTTEDDATE>, "12.08.1969"), "dd 12.08.1969";
ok tp(<DOTTEDDATE>, "2.08.69"), "dd 2.08.69";

ok tp(<HYPHENDATE>, "69-12-08"), "hd 69-12-08";
ok tp(<HYPHENDATE>, "1969-12-08"), "hd 1969-12-08";
ok tp(<HYPHENDATE>, "1969-12-8"), "hd 1969-12-8";

ok tp(<inc_dec_period>, "min"), "min min";
ok tp(<inc_dec_period>, "minute"), "min minute";
ok tp(<inc_dec_period>, "minutes"), "min minutes";

ok tp(<month_name>, "dec"), "month_name dec";
ok tp(<month_name>, "Dec"), "month_name Dec";
ok tp(<month_name>, "december"), "month_name december";

done-testing;
