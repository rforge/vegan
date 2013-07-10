# TODO List

A TODO list for **permute** - or things I know are broken or needed.

 * `summary.allPerms` - is not printing the permutation scheme

 * `print.permControl` - this needs to be updated to new API, and I don't
   like the `*** Foo ***` headings I used before. *Done in 0.7-3*

 * Need a way to update the permutation scheme, e.g. when a control
   object already exists and want to tweak it. Example is in `?allPerms`
   where I turn mirroring on via

       ctrl$within$mirror <- TRUE

   But how? Best idea currently is an `update.permControl` method. The
   generic is in namespace `stats`. Or a `modify()` function, perhaps
   coupled with specific replacement functions for certain components.

 * `permControl` - deprecate this in favour of `how` as in "how to
   permute"? *DONE Completed in 0.7-4*

 * `permuplot` - this may be fundamentally bust - it only worked in the
   original API and never got updated. Now the API is 2 versions further
   on! It is also more complex than the original - not sure it'll be
   easy without a lot of work to visualise all possible schemes.

 * `check` insists on returning all permutations *without* the observed
   on.