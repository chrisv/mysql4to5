select a.fone, b.fone, b.ftwo from atable a, btable b where a.fone="something"
select a.fone from atable a where a.fone="something"
select atable.fone, btable.fone from atable, btable where a.fone="something"
select atable.fone, btable.fone from (atable, btable) where a.fone="something"
select atable.fone from (atable) where a.fone="something"
select atable.fone from (atable a) where a.fone="something"
update atable set fone="else"
update (atable a) set a.fone="else"
update atable, btable set a.fone="else" where b.fone="something"
update atable a, btable b set a.fone="else" where b.fone="something"
update (atable, btable) set a.fone="else" where b.fone="something"
update (atable a, btable b) set a.fone="else" where b.fone="something"
update (atable a, btable b) 
set a.fone="else"
where b.fone="something"
update atable a, btable b 
set a.fone="else"
where b.fone="something"
SELECT left_tbl.*
  FROM left_tbl LEFT JOIN right_tbl ON left_tbl.id = right_tbl.id
  WHERE right_tbl.id IS NULL;

# the below should remain untouched...
my %queries = (
    person => {
        FROM   => 'person prn',
        WHERE  => 'prn.acr_id = ?',
        PARAMS => [ \'ACR' ],
    },
    prnext => {
        FROM   => 'person prn, prnext',
        WHERE  => 'prn.acr_id = ? and prnext.prn_id = prn.prn_id',
        PARAMS => [ \'ACR' ],
    },
    passport => {
        FROM   => 'passport pst, actor acr',
        WHERE  => 'pst.pst_id = acr.pst_id and acr.acr_id = ?',
        PARAMS => [ \'ACR' ],
    },
    address => {
        FROM   => 'acrads, address ads',
        WHERE  => 'acrads.acr_id = ? and
                   acrads.ade_id = 1 and
                   acrads.ads_status = 1 and
                   ads.ads_id = acrads.ads_id and
                   ads.ads_status = 1',
        PARAMS => [ \'ACR' ],
    },
#    opleiding => {
#        FROM   => 'acropl, opleiding opl',
#        WHERE  => 'acropl.acr_id = ? and opl.opl_id = acropl.opl_id'
#        PARAMS => [ \'ACR' ],
#    },
    acrfct => {
         FROM   => 'acrfct',
         WHERE  => 'acr_id = ?',
         PARAMS => [ \'ACR' ],
    },
);

