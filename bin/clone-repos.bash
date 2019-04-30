#!/bin/bash

set -e -u -o pipefail

_main() {
	local workspace
	local bare_repo

	workspace=$1

	bare_repo="${workspace}/bare_reference_repo.git"

	init_reference_repo
	fast_clone https://github.com/greenplum-db/gporca "${workspace}/gporca"
	fast_clone https://github.com/greenplum-db/gp-xerces "${workspace}/gp-xerces"
	fast_clone https://github.com/greenplum-db/gpdb "${workspace}/gpdb"
	fast_clone git@github.com:greenplum-db/gpdb4 "${workspace}/gpdb4"
	fast_clone git@github.com:greenplum-db/gpdb-historical "${workspace}/gpdb-historical"
	fast_clone https://github.com/postgres/postgres ~/src/postgres/postgres
	fast_clone https://github.com/llvm/llvm-project ~/src/llvm/llvm-project
	fast_clone git@github.com:pivotal/gp-QP-ORCA "${workspace}/QP-ORCA"
	fast_clone git@github.com:pivotal/gp-QP "${workspace}/QP"
	fast_clone git@github.com:greenplum-db/gp-QP-GPOS "${workspace}/QP-GPOS"
	fast_clone https://github.com/postgres/postgres "${workspace}/postgres"
	fast_clone git@github.com:greenplum-db/gp-QP-MAIN "${workspace}/QP-MAIN"
}

init_reference_repo() {
	if [ -d "${bare_repo}" ] && git -C "${bare_repo}" rev-parse --is-bare-repository; then
		true
	else
		git init --bare "${bare_repo}"
	fi
}

very_unique_csum() {
	(
		set -e
		printf '%s' "${remote_repo}" | gmd5sum | cut -c 1-8
	)
}

fast_clone() {
	local remote_repo local_repo remote_name
	remote_repo=$1
	local_repo=$2
	remote_name=$(basename "${remote_repo}")
	remote_name=${remote_name}-$(very_unique_csum)

	if git -C "${bare_repo}" remote set-url "${remote_name}" "${remote_repo}"; then
		true
	else
		git -C "${bare_repo}" remote add --no-tags "${remote_name}" "${remote_repo}"
	fi
	if git -C "${local_repo}" rev-parse --is-inside-work-tree; then
		true
	else
		git -C "${bare_repo}" fetch "${remote_name}"
		time git clone --reference "${bare_repo}" --dissociate "${remote_repo}" "${local_repo}"
	fi
}

_main "$@"
