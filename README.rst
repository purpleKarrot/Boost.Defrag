Boost.CMake is an approach to a modularized build of the `Boost C++ Libraries <http://www.boost.org/>`_ with `CMake <http://cmake.org/>`_.

This fork will eventually include modules for:
    * Boost.Context
    * Boost.Fiber
    * Boost.Atomic
    * Boost.Lockfree
    * Boost.Move
    * Boost.Task
    * Boost.Tasklets

I would like to turn these modules into CMake 'options' that are off by default so that this fork
can be merged back into purpleKarrot's sources.  

**This is an experimental project. Usage for other purposes than testing is strongly discouraged!**

Already implemented features:
--------------------------------------------
* Aggregate modules from different sources (CVS, SVN, GIT, ...).
* Build, Test, Install
* Create a binary installer with selectable components for Windows and Mac OS.
* Create a source package (with the modules included) that can do everything in this list (except the first entry).
* Create a Debian source package that can be uploaded to a Launchpad PPA where it is built and packaged into many binary Debian packages.
* Build Documentation (the usual quickbook-doxygen-boostbook-chain).
* Tested on Windows (Visual Studio 10), Ubuntu (GCC) and Mac OS X (GCC).
* Precompiled headers (currently MSVC only). 
* Build two Boost.MPI libraries on Debian: boost_openmpi and boost_mpich2.
* Tests actually make use of Boost's autolinking feature.

In the near future:
-------------------------
* Install and package multiple configurations (Debug AND Release).
* Install and package the generated documentation.

Aggregation:
------------------
Modules can be fetched from a number of different sources:

* Checkout the module's CVS repository (requires cvs command line client).
* Checkout the module's Subversion repository (requires svn command line client).
* Clone the module's Git repository (requires git command line client).
* Download and extract a compressed archive (No additional requirements: .tar.bz2, .tar.gz, .tgz and .zip are supported by CMake).
* Copy from pristine Boost release (currently all modules use this one).
