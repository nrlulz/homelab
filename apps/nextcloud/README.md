## Running `occ` commands

    kubectl -n nextcloud exec -it sts/nextcloud -c nextcloud -- su -s /bin/sh www-data -c 'php occ ...'
