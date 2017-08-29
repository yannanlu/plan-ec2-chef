Description
===========
This cookbook is to install a bunch of packages.

Requirements
============

Usage
=====
The most important attribute is `node['common'][:platform]['pkg_list']`.

    include_recipe "common::default"

or just add the recipe to the run_list:

    recipe[common::default]
