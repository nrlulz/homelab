## Running `occ` commands

    kubectl -n nextcloud exec -it deploy/nextcloud -c nextcloud -- su -s /bin/sh www-data -c 'php occ ...'
