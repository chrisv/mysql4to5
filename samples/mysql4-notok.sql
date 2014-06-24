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

# the below should be updated...
	# Axoni/Common3.pm
    execQuery("update membership set mba_id = 17 where mmp_id = ?", $dbh, $mmp);
	# Viw/Services/OrlExplorerNEW.pm
    my $drn_ore = execQuery("select ore.ore_id from drnore, orgleveltype ore
                             where drnore.drn_id = ? and
                                   ore.ore_id = drnore.ore_id", $dbh, $drn);

      my $drn_rle = execQuery("select ore.ore_id, rle.rle_id
                               from drnorerle, orgleveltype ore, orgrole rle
                               where drnorerle.drn_id = ? and
                                     ore.ore_id = drnorerle.ore_id and
                                     rle.rle_id = drnorerle.rle_id and
                                     rle.rle_status = 1", $dbh, $drn);

  my $rs_rle = execQuery("select mbr.mbr_id, ore.ore_id, orl.orl_id, rle.rle_id,
                                 tlrle.rle_title, tlorl.orl_name, tlore.ore_name
                          from member mbr, orgrole rle, tlrle, orglevel orl, tlorl,
                               orgleveltype ore, tlore
                          where mbr.acr_id = ? and
                                mbr.mbr_status = 1 and
                                rle.rle_id = mbr.rle_id and
                                rle.rle_status = 1 and
                                rle.rle_hidden != 'y' and
                                rle.rle_type = ? and
                                tlrle.rle_id = rle.rle_id and
                                tlrle.lng_id = ? and
                                orl.orl_id = mbr.orl_id and
                                orl.orl_status = 1 and
                                tlorl.orl_id = orl.orl_id and
                                tlorl.lng_id = ? and
                                ore.ore_id = orl.ore_id and
                                tlore.ore_id = ore.ore_id and
                                tlore.lng_id = ?
                          order by tlore.ore_name, tlorl.orl_name, tlrle.rle_title",
                          $dbh, $acr, $type, $p->{LNG}, $p->{LNG}, $p->{LNG});

  # Axoni/Common2.pm
    if ($mmp) {
      $from .= ", membership mmp";
      $where .= "and mmp.mmp_id = $mmp\n" .
                "and mmp.mba_id = iremba.mba_id\n" .
                "and ire.ire_from <= from_unixtime(mmp.mmt_whenset)\n" .
                "and ire.ire_to > from_unixtime(mmp.mmt_whenset)\n";
    }

    my $rs_ire = execQueryArrayref("SELECT ire.ire_id FROM iremba, insurance ire $from
                                    WHERE iremba.mba_id = ? AND 
                                          iremba.ire_status = 1 AND
                                          iremba.ire_id = ire.ire_id AND
                                          ire.ire_status = 1
                                          $where", $dbh, $mba);
              #                           ( curdate() BETWEEN ire.ire_from AND ire.ire_to )", $dbh, $mba);

        
        warn "begin query: $date_from and $mgz_to";
        
        #Axoni::Common3::loggedQuery( $dbh, $p, $logId, 40, $acr, $orl,
        #                            { ID     => 'abt_id',
        #                              ACTION => 'INSERT',
        #                              TABLE  => 'abonnement',
        #                              SET    => { acr_id          => $acr,
        #                                          mgz_id          => $_->[0],
        #                                          abe_id          => $_->[1],
        #                                          abt_from        => "$date_from", 
        #                                          abt_to          => "$mgz_to",
        #                                          abt_whenupdated => time,
        #                                          abt_number      => $_->[2],
        #                                          abs_id          => $abs
        #                                        },
        #                              FUNC   => [ qw/abt_to/ ],
        #                            }
        #                          );
        warn "end query";

      } else {
        
        $abt = $mgz_check if $mgz_check > 0;
        my $abe = getId($dbh, "select abe_id from abonnement where abt_id = $abt");

