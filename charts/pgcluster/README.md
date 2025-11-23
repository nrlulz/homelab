# Backup/Restore

## `pg_dump`/`pg_restore`ing a database

https://cloudnative-pg.io/documentation/1.27/troubleshooting/#emergency-backup

Dump:

    kubectl exec $POD -c postgres -- \
        pg_dump -Fc -c --user $DBUSER --dbname $DBNAME \
        > something.dump

Restore:

    kubectl exec -i $POD -c postgres -- \
        pg_restore --no-owner --role=$DBUSER --dbname $DBNAME \
        < something.dump

## Restoring to a point in time

See [values.yaml](values.yaml)
