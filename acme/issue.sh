#!/bin/sh -ex

# Usage: ./issue.sh domain1 '*.domain1' domain2 ...
#   where domain1 will be the "name" of the certificate that will be reused for other commands (-d).

domain_args() {
        for d in "$@"; do
                printf " -d %s" "$d"
        done
        if [ "${FORCE:-0}" -gt 0 ]; then
                printf " --force"
        fi
}

makecert() {
        d="$1"
        shift 1
#        ./acme.sh --issue --dns dns_pdns -d "$d" "$@"
        ./acme.sh --issue -w /var/www/letsencrypt/ -d "$d" "$@"

}

installcert() {
        d="$1"
        target="${2:-$d}"
        shift 2
	docker-compose run --rm acmesh mkdir "/certs/$target"
        ./acme.sh --installcert "$@" -d "$d" \
                --cert-file "/certs/$target/cert.cer" \
                --key-file "/certs/$target/cert.key" \
                --ca-file "/certs/$target/ca.cer" \
                --fullchain-file "/certs/$target/fullchain.cer"
#                --fullchain-file "/certs/$target/fullchain.cer" \
#                --reloadCmd "post-hook.sh"
}

d="$1"
shift 1

# request and install RSA certificate
makecert "$d" --keylength 4096 $(domain_args "$@")
installcert "$d" "$d"

# request and install ECDSA certificate
makecert "$d" --ecc --keylength ec-384 $(domain_args "$@")
installcert "$d" "${d}_ecc" --ecc

