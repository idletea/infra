#################
## infra setup ##
#################

tofu-platform:
    #!/bin/fish
    cd tofu/platform
    tofu-op apply

tofu-zones:
    #!/bin/fish
    cd tofu/zones
    run zone-gen
    tofu-op apply

iac:
    #!/bin/fish
    run pyinfra --yes \
        iac/inventory.py \
        iac/vk_nodes.py

tofu-kubernetes:
    #!/bin/fish
    proxy-vk
    cd tofu/kubernetes
    tofu-op apply

cluster:
    #!/bin/fish
    proxy-vk

    if kubectl get namespace flux-system &>/dev/null
        nop "flux-system already bootstrapped"; exit 0
    end

    set tmp_dir (mktemp -d)
    op item get --vault Infra FLUX_SSH_KEY \
        --reveal --fields "private key" \
        | sed '/^"$/d' > $tmp_dir/ssh-key

    flux bootstrap git \
        --url=ssh://git@github.com/idletea/infra \
        --branch=trunk \
        --author-name=flux \
        --author-email=flux@vk.idte.net \
        --path=cluster/flux \
        --cluster-domain=vk.idte.net \
        --private-key-file="$tmp_dir/ssh-key"

    rm -rf $tmp_dir
