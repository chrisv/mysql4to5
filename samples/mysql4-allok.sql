select atable.fone from (atable) where a.fone="something"
select atable.fone from (atable a) where a.fone="something"
update (atable a) set a.fone="else"
update (atable, btable) set a.fone="else" where b.fone="something"
update (atable a, btable b) set a.fone="else" where b.fone="something"
update (atable a, btable b) 
set a.fone="else"
where b.fone="something"
