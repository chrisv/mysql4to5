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