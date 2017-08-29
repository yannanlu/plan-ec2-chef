Description
===========
This cookbook is to install OpenJDK.

Requirements
============

Usage
=====
The most important attribute is `node['common'][:platform]['pkg_list']`.

    include_recipe "java::default"

or just add the recipe to the run_list:

    recipe[java::default]
