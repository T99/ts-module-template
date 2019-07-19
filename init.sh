#!/usr/bin/env bash

# Print start message.
	echo "Running js-module-template initialization script..."

# Prompt for relevant package information to find-and-replace template placeholder strings.
	read -p "  Package name: "			packageName
	read -p "  Package description: "	packageDesc
	read -p "  GitHub org: "			gitHubOrg
	read -p "  NPM org: "				npmOrg
	read -p "  readme title: "			readmeTitle

# Print a spacer line.
	echo ""

# If the GitHub organization name was left blank, assume the package belongs to T99.
	if [[ -z $gitHubOrg ]]; then

		gitHubOrg="T99"

	fi

# Derive the full package name from the NPM organization and base package name.
	if [[ -z $npmOrg ]]; then

		fullPackageName="${packageName}"

	else

		fullPackageName=$(echo -n "@${npmOrg}/${packageName}")

	fi

# Modify template files to use correct package information.
	echo -n "  Modifying template files to use correct package information... "

	files=("ts/main.ts" "gulpfile.js" "license.md" "package.json" "readme.md")

	for file in "${files[*]}"; do

		sed -i "s_<name>_${fullPackageName}_g" ${file} > /dev/null 2>&1
		sed -i "s/<desc>/$packageDesc/g" ${file} > /dev/null 2>&1
		sed -i "s/<title>/$readmeTitle/g" ${file} > /dev/null 2>&1
		sed -i "s/<base_name>/$packageName/g" ${file} > /dev/null 2>&1
		sed -i "s/<github_org>/$gitHubOrg/g" ${file} > /dev/null 2>&1

	done

	echo "DONE"

# Stop tracking certain files that were pulled from the template.
	echo -n "  Stopping Git from tracking certain files from the template... "
	git rm --cached ./ts/tslint.json ./.gitignore > /dev/null 2>&1
	echo "DONE"

# Delete the readmes that were used to track otherwise-empty dirs.
	echo -n "  Removing placeholder readme files... "
	rm ./.d.ts/readme.md ./js/readme.md ./ts/readme.md ./ts/tests/readme.md > /dev/null 2>&1
	echo "DONE"

# Install the missing packages from our package.json file.
	echo -n "  Installing packages from package.json... "
	npm install > /dev/null 2>&1
	echo "DONE"

# Print an 'exiting' statement.
	echo ""
	echo "  Exiting..."
	echo ""

# Make the script remove itself.
	rm -- "$0"

# Exit from the script.
	exit 0