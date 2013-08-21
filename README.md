Description
===========

Installs the [burp](https://github.com/grke/burp) client and server from source.

It adds "plugin" directories (pre.d, post.d) to place backup scripts, such a dumping a database or other program output, for easy integration with other cookbooks.

On Debian and Ubuntu, debconf selections are already kept in /var/backups/debconf-package-list/ using such a plugin.

Requirements
============

* `git`
* `build-essential`
* `openssl`

Create your own .deb (Ubuntu)
==========

Install program dependencies:
`apt-get install build-essential git librsync-dev libz-dev libssl-dev uthash-dev`

Install build dependencies:
`apt-get install debhelper autotools-dev libncurses5-dev libacl1-dev libattr1-dev`

Get the source
`git clone https://github.com/grke/burp.git`

If you wish tar-up the source to comply with AGPL
cd burp; tar cvzf ../burp_1.3.26.orig.tar.gz ./

Build the package
`dpkg-buildpackage -us -uc` # add -b to skip source

Usage
=====

=======
chef-burp
=========
