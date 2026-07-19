# Incident — OU name collision at domain root

What I saw: could not create an OU named "Users" directly under corp.atlas.test — creation was rejected.
What I expected: it would just create.
What I thought was wrong: unclear at the time — assumed a permissions or typo issue.
What was ACTUALLY wrong: name collision — the domain root already has a built-in "Users" container (not an OU) occupying that name.
How I found out: asked why, learned container vs OU distinction — default containers can't take GPO links, which is exactly why a separate OU structure is needed.
The fix: created a single ATLAS OU first, then nested Users/Admins/Computers/Groups inside it — different parent, no collision.
How I know it's fixed: OU tree now shows correctly under ATLAS in ADUC.
How I'd spot it faster next time: check whether a name is already taken by a default container before assuming the OU tree structure — domain root already owns Users, Computers, Domain Controllers, etc.
