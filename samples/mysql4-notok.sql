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

  my $mmt = getId($dbh, "select mmt.mmt_id
                         from mmcstep mmt
                         join mmpcycle mmc on mmc.mmc_id = mmt.mmc_id
                         join mbrformula mba on mba.mmc_id = mmc.mmc_id
                         where mba.mba_id = ? and mms_id = ?", $mba, $c->{MMS_REQUESTED}->());

  
  for my $key ( keys %$left ){
    if ( $left->{$key} ){
      push @left, $key;
    } else {
      warn "$function ( Left Join ): There has been no value assigned to key: $key";
    }
  }

  for my $key ( keys %$set ){
    if ( $set->{$key} eq 'sysdate()' ){
      my ($sec, $min, $hour, $day, $month, $year) = (localtime())[0, 1, 2, 3, 4, 5];
      $set->{$key} = ($year+1900) . '-' . ($month+1) . '-' . $day . ' ' . $hour . ':' . $min . ':' . $sec; 
    }
     
    push @set, $key;
    if (not exists $func{$key}) {
      push @args, $set->{$key};
    }
  }
  
  if ( $action ne 'INSERT' ){
    for my $key ( keys %$where ){
      if ( $where->{$key} ){
        push @where, $key;
        push @args, $where->{$key};
      } else {
        warn "$function ( Where ): There has been no value assigned to key: $key";
      }
    }
  }
 
  if ( $action && $table ){
    $table = 'INTO ' . $table, if ( $action eq 'INSERT' );
    $table = 'FROM ' . $table, if ( $action eq 'SELECT' );
  
    push @query, $action;
    push @query,            join( ', ', map { "$_" } @select ),       if ( @select );
    push @query, $table;     
    push @query,            join( 'LEFT JOIN ', map { "$_" } @left ), if ( @left );
    push @query, 'SET '   . join( ', ', map { exists $func{$_} ? "$_ = $set->{$_}" : "$_ = ?" } @set ),      if ( @set );
    push @query, 'WHERE ' . join( ' and ', map { "$_ = ?" } @where ),    if ( @where );
    
    $query = join( ' ', @query );
  } else {
    warn "$function: There has been a update attempt, but not all the data needed was available";
  }

sub getTags {
  my ($dbh, $txo, $obj, $txe, $lng, $separator) = @_;

  $separator = ', ' unless defined $separator;

  my $rs_tag = execQueryArrayref("
                 SELECT txo.txo_id, tltxo.txo_title
                 FROM taxo txo
                 LEFT JOIN tltxo ON tltxo.txo_id = txo.txo_id AND
                                    tltxo.lng_id = ?
                 INNER join txoobj txj ON txj.txo_id = txo.txo_id AND 
                                          txj.obj_id = ? AND 
                                          txj.txe_id = ?
                 WHERE txo.parent_txo_id = ? 
                 ORDER by tltxo.txo_title", $dbh, $lng, $obj, $txe, $txo);
 
  my %tag_titles = map { $_->[0] => $_->[1] } @$rs_tag;

  return wantarray() ? %tag_titles : join ($separator, sort {$a cmp $b} values %tag_titles);
}

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

# Viw/Services/Data/OrlExplorerNEW.pm
  $self->type('ade', ED_DROPDOWN, sub {
                                   "select ade.ade_id, tlade.ade_sdesc 
                                    from adstype ade
                                         left join tlade on tlade.ade_id = ade.ade_id and
                                                            tlade.lng_id = $_[1][0]"
                                  }, undef, -class => 'editor_dropdown');

  $self->type('cry', country_data({ extra => { } }));

  $self->type('dob_cry', country_data({ extra => { } }));

  $self->type('orig_cry', country_data({ extra => { } }));
                                  
  # members
  $self->type('find_family', ED_TEXT, 80, 70, -class => 'editor_textfield');
  $self->type('famtype', ED_DROPDOWN, sub {
                                   "select fae_id, fae_name from famtype where lng_id = $_[1][0]"
                                  }, undef, -class => 'editor_dropdown');


  $self->type('language', ED_DROPDOWN, 
                          sub {
                            my ($self, $vars) = @_; 
                            my $lng = splice @$vars, 0, 1;
                            my $rs_lng = $self->execQueryArrayref("
                                                  select lng.lng_id, tllng.lng_name 
                                                  from language lng
                                                       left join tllng on tllng.lng_id = lng.lng_id and
                                                                          tllng.lng_lng_id = $lng
                                                  order by lng.lng_order");

                            my (@lng, %lng);
                            my $i = 0;
                            for( @$rs_lng ){
                              push @lng, $rs_lng->[$i][0];
                              $lng{$rs_lng->[$i][0]} = $rs_lng->[$i][1];
                              $i++;
                            }
                            return (\@lng, \%lng);
                          },
                          -class => 'editor_dropdown');                          
  $self->type('tte', ED_DROPDOWN, 
                       sub {
                         my ($self, $vars) = @_; 
                         my $lng = splice @$vars, 0, 1;
                         my $rs_tte = $self->execQueryArrayref("select tte_id, tte_name from title where lng_id = $lng");

                         my (@tte, %tte);
                         push @tte, 0;
                         $tte{0} = '';

                         my $i = 0;
                         for( @$rs_tte ){
                           push @tte, $rs_tte->[$i][0];
                           $tte{$rs_tte->[$i][0]} = $rs_tte->[$i][1];
                           $i++;
                         }
                         return (\@tte, \%tte);
                       },
                       -class => 'editor_dropdown',
                       (CFG_EXTRA_NEOS() ? ( -onchange => 'if( this.value == 1 || this.value == 6 ){ 
                                                           document.getElementById("genderM").checked = true;
                                                         };
                                                         if( this.value == 3 || this.value == 4 ){
                                                           document.getElementById("genderV").checked = true;
                                                         };
                                                        ') : ())
                       );


  return ([[@ok{qw(name fname ddob mdob ydob gender street dmbrfrom mmbrfrom ymbrfrom email
                   cteid cmyemailwork mbrtype rle_c rle_b membership new_mba_parent new_mba_child
                   new_mba_child_parent fromfut bankaccount feb)}]], 
                qw(name_ok fname_ok ddob_ok mdob_ok ydob_ok gender_ok street_ok mbr_d_ok mbr_m_ok mbr_y_ok email_ok 
                   cteid_ok cmyemailwork_ok mbrtype_ok rle_c_ok rle_b_ok membership_ok new_mba_parent_ok new_mba_child_ok
                   new_mba_child_parent_ok fromfut_ok bankaccount_ok feb_ok));
  
} 

sub _saveOrlExplorerUser {
  my ($self, $vars) = @_;
  my ($par, $mbr, $orl, $updmbr, $emailisuname) = splice @$vars, 0, 5;
  my $acr;
  
  ($mbr, $acr) = $self->_saveUser($par,$mbr, $orl, $updmbr, $emailisuname);

  my ($rs_orl) = $self->_orglevelIsCompany([$orl]); 
  if ($rs_orl->[0][0]){
    $self->execQuery("replace acrcmy (acr_id, cpy_id, acy_title)
                      select $acr, cmy.cpy_id, ifnull(acy.acy_title, '')
                      from company cmy
                           left join acrcmy acy on acy.cpy_id = cmy.cpy_id and
                                                   acy.acr_id = $acr
                      where cmy.orl_id = $orl");
  } 

  return ([[$mbr, $acr]], qw(mbr acr));
}

sub _listOrlExplorerUserMagazines {
  my ($self, $vars) = @_;
  my ($mbr, $lng) = splice @$vars, 0, 2;

  my $rs_mgz = $self->execQuery("select date_format(abt_from, '%d-%m-%Y'), date_format(abt_to, '%d-%m-%Y'), mgz_name, abe_name 
                                 from member, abonnement, tlmgz, tlabe
                                 where abonnement.acr_id = member.acr_id and
                                       tlmgz.mgz_id = abonnement.mgz_id and
                                       tlabe.abe_id = abonnement.abe_id and
                                       tlmgz.lng_id = ? and
                                       tlabe.lng_id = ? and
                                       member.mbr_id = ?
                                 order by abt_to desc", $lng, $lng, $mbr);

  return ($rs_mgz, qw(from to mgzname abttype));
}

sub _editMailSettingsMail {
  my ($self, $vars) = @_;
  my ($mbr) = splice @$vars, 0, 1;

  my $rs_acl = $self->execQuery("select acl_onmessage, acl_ontask from member, acrmail 
                                 where acrmail.acr_id = member.acr_id and
                                       member.mbr_id = $mbr");

  return ($rs_acl, qw(onmessage ontask));
}

  my ($join, $where, $select2) = ("", "", "null");
  if ($type eq 'membership' or $type eq 'contact' or CFG_EXTRA_KVG()) {
    $select2 = 'mmp.mmp_parent_id';

    $join .= "left join mmpacr on mmpacr.acr_id = acr.acr_id and mmpacr.mmp_status = 1\n" .
             "left join membership mmp on mmp.mmp_id = mmpacr.mmp_id and mmp.mmp_status = 1 " .
                                          ($orl == ORL_TOP() ? "and mmp.orl_id = $orl" : "") . "\n";

    if ($type eq 'membership') {
      $where .= " and mmp.mmp_id is not null\n";
    } elsif (CFG_EXTRA_KVG()) {
    } else {
      $where .= " and mmp.mmp_id is null\n";
    }
  }

  
  if ($type eq 'beheerder') {
     $where .= " and rle.rle_type = 'b'";
  } else {
     $where .= " and rle.rle_type in ('b', 'c')"
  }

  if ( $rle && $rle != -1 ){
     $where .= " and rle.rle_id = $rle";
  }
  
  my $order = 'order by prn.prn_lname, prn.prn_fname';
  if ( CFG_EXTRA_EKONOMIKA() ){
    $order = "order by REPLACE( prn_lname, ' ', '' ), prn.prn_fname";
  }
  
  #Changed by Viraj - CR8625
  my ($orl_select, $orl_from, $orl_join, $orl_where);
  
  if (CFG_EXTRA_SPORTIMONIUM())
  {
    $orl_select = qq{, tlorl.orl_name};
    $orl_from = qq{, orglevel orl}; 
    $orl_join = qq{left join tlorl on tlorl.orl_id = orl.orl_id and
                                               tlorl.lng_id = $lng}; 
    $orl_where = qq{orl.orl_id = mbr.orl_id and };
  }
  else
  {
  $orl_select = qq{, ''};  
  }
  
  
  my $rs_mbr = $self->execQuery("
                        select mbr.mbr_id, mbr.acr_id, prn.prn_fname, ucase(prn.prn_lname), rle.rle_id, $select, 
                               ucase(tlrle.rle_title), prn.prn_memberid, mbr.orl_id, 
                               if (rle.rle_type in ('b', 'c'), 1, 0),
                               if (rle.rle_sendmail = 'y', 1, 0), $select2 $orl_select 
                        from actor acr, person prn, member mbr, orgrole rle, tlrle $orl_from
                        $join
      $orl_join
                        where $orl_where
            acr.acr_status = 1 and
                              mbr.acr_id      = acr.acr_id and
                              prn.acr_id      = acr.acr_id and
                              mbr.rle_id      = rle.rle_id and
                              mbr.mbr_hidden != 'y' and
                              mbr.mbr_status  = 1 and
                              -- rle.rle_type   in ('b', 'c') and
                              rle.rle_hidden != 'y' and
                              mbr.orl_id      = ? and
                              rle.rle_status  = 1 and
                              tlrle.rle_id    = rle.rle_id and
                              tlrle.lng_id    = ?
                              $where
                        group by acr.acr_id
                        $order", $orl, $lng);
      
  return ($rs_mbr, qw(mbr acr fname lname rleid acrid rletitle memberid orlid rle_ok pwd_ok pmmp orl_name));
  #End - Changed by Viraj - CR8625
}
