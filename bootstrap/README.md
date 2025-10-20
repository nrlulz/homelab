## Generating/applying the machine config

Talconfig is essentially values for a template. We use it plus the encrypted secrets to
generate an actual machine config that can be applied using talosctl.

Generate the config:

    talhelper genconfig

Apply it to all nodes:

    eval $(talhelper gencommand apply)

For a new cluster:

    eval $(talhelper gencommand apply --extra-flags --insecure)

## Upgrading Talos

Update the `talosVersion` in talconfig.yaml

Pulling the image from talconfig:

    export TALOS_IMAGE=$(talhelper genurl installer --config-file ./talconfig.yaml)

Upgrade nodes one at a time. **Don't forget --preserve=true**!!!

    talosctl upgrade --preserve=true --image $TALOS_IMAGE --nodes 192.168.1.31

Wait for all volumes and apps to get back to healthy status before upgrading the next

## Upgrading Kubernetes

Update the `kubernetesVersion` in talconfig.yaml

Pulling the k8s version from talconfig:

    export KUBERNETES_VERSION=$(yq .kubernetesVersion talconfig.yaml)

Do the upgrade just once for the cluster

    talosctl upgrade-k8s --to $KUBERNETES_VERSION --nodes 192.168.1.31

## Nuking and recreating the cluster from scratch

1.  Backups, obviously

1.  Nuke nodes (do for each node):

        talosctl reset --graceful=false --nodes 192.168.1.31

1.  Boot machines from ISO
1.  Apply machine config using `--insecure` (see above)
1.  Bootstrap Kubernetes (do only once on one node):

        talosctl bootstrap --nodes 192.168.1.31 --endpoints 192.168.1.31

1.  Install ArgoCD

        cd system/argocd
        kubectl create ns argocd
        helm dependency update

    First, install ArgoCD without the apps, so that CRDs get installed:

        helm upgrade --install --namespace argocd --set argocd-apps.enabled=false argocd .

    Then install the apps too:

        helm upgrade --install --namespace argocd --set argocd-apps.enabled=true argocd .

1.  Log in

        k -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d | pbcopy
        k -n argocd port-forward svc/argocd-server 8443:80

    Go to http://localhost:8443 and log in with `admin` and copied password

1.  Install External Secrets

    Create a secret with the bitwarden secrets manager machine account access token:

        k -n external-secrets create secret generic bitwarden-access-token --from-literal=token=<token goes here>
