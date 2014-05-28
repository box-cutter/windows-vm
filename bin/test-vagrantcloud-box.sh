#!/bin/bash -eux

create_vagrantfile_linux() {
vagrant plugin install vagrant-serverspec
cat << EOF > $tmp_path/Vagrantfile
Vagrant.configure('2') do |config|
config.vm.box = '$box_path'

config.vm.provision :serverspec do |spec|
spec.pattern = '$test_src_path'
end
end
EOF
}

box_path=$1
box_provider=$2
vagrant_provider=$3
test_src_path=$4

box_filename=$(basename "${box_path}")
box_name=${box_filename%.*}
tmp_path=/tmp/vagrantcloudtest

rm -rf ${tmp_path}
rm -f ~/.ssh/known_hosts

vagrant box remove ${box_path} --provider ${vagrant_provider} 2>/dev/null || true
vagrant box add ${box_path} --provider=${vagrant_provider}
mkdir -p ${tmp_path}

pushd ${tmp_path}
create_vagrantfile_linux
VAGRANT_LOG=warn vagrant up --provider=${box_provider}
sleep 10
vagrant destroy -f
popd

vagrant box remove ${box_path} --provider=${vagrant_provider}
