#!/bin/sh -x
# Automatically builds CentOS 6x RPMs for latest Apache httpd
# tested in centos:6 latest docker image

# ebal, Wed, 07 Aug 2019 20:44:52 +0300

# declare versions
apr_version=1.7.0
apr_util_version=1.6.1
apr_iconv_version=1.2.2
httpd_version=2.4.40

function init (){
    yum -y update &> /dev/null
    yum -y install rpm-build rpmlint \
        curl gcc make automake autoconf pkg-config libtool &> /dev/null
    mkdir -p /root/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
}

function buildconf(){
    cd /tmp/
    tar xf /root/rpmbuild/SOURCES/$1.tar.gz
    case "$2" in
        "apr") true;
            yum -y install doxygen libuuid-devel &> /dev/null ;
            continue;
            ;;
        "apr-util") true;
            yum -y install expat-devel db4-devel postgresql-devel mysql-devel sqlite-devel unixODBC-devel openldap-devel openssl-devel nss-devel &> /dev/null ;
            $(ls -d /tmp/apr-$apr_version &> /dev/null) && cp -ra /tmp/apr-$apr_version /tmp/apr || echo does not exist ;
            continue;
            ;;
        "httpd") true;
            yum -y install pcre-devel lua-devel libxml2-devel mailcap &> /dev/null ;
            $(ls -d /tmp/apr-$apr_version &> /dev/null) && cp -ra /tmp/apr-$apr_version /tmp/apr || echo does not exist ;
            $(ls -d /tmp/apr-util-$apr_util_version &> /dev/null) && cp -ra /tmp/apr-util-$apr_util_version /tmp/apr-util || echo does not exist
            continue;
            ;;
        esac
    cd $1
    sh ./buildconf
    cd ../
    tar cjf /root/rpmbuild/SOURCES/$1.tar.bz2 $1
}

function build() {
    export name=$1
    export version=$2

    curl -sLo /root/rpmbuild/SOURCES/$name-$version.tar.gz \
         https://github.com/apache/$name/archive/$version.tar.gz

    buildconf $name-$version $name
    rpmbuild -ts /root/rpmbuild/SOURCES/$name-$version.tar.bz2
    rpm -ih /root/rpmbuild/SRPMS/*.src.rpm

    sed -i -e 's/exit 1/exit 0/g' /root/rpmbuild/SPECS/$name.spec

    rpmbuild --clean -ba /root/rpmbuild/SPECS/$name.spec
    rpm -ih /root/rpmbuild/RPMS/x86_64/$name-$version*.x86_64.rpm
}

init
build apr $apr_version
build apr-util $apr_util_version
build httpd $httpd_version
