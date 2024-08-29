## Generating/applying the machine config

Talconfig is essentially values for a template. We use it plus the encrypted secrets to
generate an actual machine config that can be applied using talosctl.

Generate the config:

    talhelper genconfig

Apply it to all nodes:

    eval $(talhelper gencommand apply)

## Upgrading Talos

Pulling the image from talconfig:

    export TALOS_IMAGE=$(talhelper genurl installer --config-file ./talconfig.yaml)

Upgrade nodes one at a time. **Don't forget --preserve=true**!!!

    talosctl upgrade --preserve=true --image $TALOS_IMAGE --nodes 192.168.1.31

## Upgrading Kubernetes

Pulling the k8s version from talconfig:

    export KUBERNETES_VERSION=$(yq .kubernetesVersion talconfig.yaml)

Do the upgrade just once for the cluster

    talosctl upgrade-k8s --to $KUBERNETES_VERSION --nodes 192.168.1.31
