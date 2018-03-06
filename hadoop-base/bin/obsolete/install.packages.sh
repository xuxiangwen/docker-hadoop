export http_proxy=http://web-proxy.atl.hp.com:8080
echo install package : $1
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
$scriptpath/R/install.packages.R $1
