# Fudging the "added at" time to get a thing out of Recently Added

to get a sqlite shell

    k -n plex exec -it deploy/plex -- /usr/lib/plexmediaserver/Plex\ Media\ Server --sqlite /config/Library/Application\ Support/Plex\ Media\ Server/Plug-in\ Support/Databases/com.plexapp.plugins.library.db

see the current values

    select id, added_at, title from metadata_items where lower(title) like '%title%' order by added_at;

copy the id and timestamp (often these records are duplicated, using the older timestamp will put it back where it should actually be)

update the record that needs updated

    update metadata_items set added_at = 123456 WHERE id = 4321;
