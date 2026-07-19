# 0002 — OU and group naming convention

Decision: OU structure nested under a single ATLAS OU (Users, Admins, Computers, Groups). Security groups prefixed SG-<area>-<right>.

Why: OUs target policy/delegation by location in the tree; groups grant access by membership. Keeping them structurally separate makes each easy to reason about independently, and the prefix makes group type/purpose readable at a glance without opening it.

What I rejected: flat structure with no OU tree under the domain root — harder to delegate and target policy cleanly later, and it would have collided with the built-in Users/Computers containers.

How I'll know it was right: GPO linking in Session 8 targets OUs cleanly, permissions in Session 9 use groups cleanly, no overlap or confusion between the two systems.
