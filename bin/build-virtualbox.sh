#!/bin/bash

set -ex

FULL_PATH=`pwd "$(dirname $0)/.."`

fetch_bosh_lite_ovf(){
  mkdir -p tmp

  (
    cd tmp
    rm -f virtualbox.box

    box_name=bosh-lite-virtualbox-ubuntu-trusty-${BOSH_LITE_VERSION}.box
    if [ ! -f $box_name ]; then
      wget http://d2u2rxhdayhid5.cloudfront.net/${box_name}
    fi
    cp ${box_name} virtualbox.box
    tar xf virtualbox.box
  )

  echo "${FULL_PATH}/tmp/box.ovf"
}

set_virtualbox_home(){
  VBoxManage setproperty machinefolder "/var/vcap/data/VirtualBox\ VMs"
}

main() {
  set_virtualbox_home
  ovf_file=`fetch_bosh_lite_ovf`

  template_path="${FULL_PATH}/templates/virtualbox.json"
  packer build -var "source_path=${ovf_file}" -var "build_number=${GO_PIPELINE_COUNTER}" $template_path
}

main
