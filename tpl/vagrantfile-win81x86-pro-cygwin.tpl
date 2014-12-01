# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.define "vagrant-win81x86-pro-cygwin"
    config.vm.box = "win81x86-pro-cygwin"

    # Port forward WinRM and RDP
    config.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct:true
    config.vm.communicator = "winrm"
	config.vm.guest = :windows
	#config.windows.set_work_network = true
    config.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct:true
    # Port forward SSH
    config.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", auto_correct:true

    # Berkshelf
    # config.berkshelf.enabled = true

    config.vm.provider :virtualbox do |v, override|
        v.gui = true
        v.customize ["modifyvm", :id, "--memory", 768]
        v.customize ["modifyvm", :id, "--cpus", 1]
        v.customize ["modifyvm", :id, "--vram", "256"]
        v.customize ["setextradata", "global", "GUI/MaxGuestResolution", "any"]
        v.customize ["setextradata", :id, "CustomVideoMode1", "1024x768x32"]
    end

    config.vm.provider :vmware_fusion do |v, override|
        v.gui = true
        v.vmx["memsize"] = "768"
        v.vmx["numvcpus"] = "1"
        v.vmx["cpuid.coresPerSocket"] = "1"
        v.vmx["ethernet0.virtualDev"] = "vmxnet3"
        v.vmx["RemoteDisplay.vnc.enabled"] = "false"
        v.vmx["RemoteDisplay.vnc.port"] = "5900"
        v.vmx["scsi0.virtualDev"] = "lsisas1068"
    end

    config.vm.provider :vmware_workstation do |v, override|
        v.gui = true
        v.vmx["memsize"] = "768"
        v.vmx["numvcpus"] = "1"
        v.vmx["cpuid.coresPerSocket"] = "1"
        v.vmx["ethernet0.virtualDev"] = "vmxnet3"
        v.vmx["RemoteDisplay.vnc.enabled"] = "false"
        v.vmx["RemoteDisplay.vnc.port"] = "5900"
        v.vmx["scsi0.virtualDev"] = "lsisas1068"
    end

    config.vm.provider :parallels do |v, override|
        v.customize ["set", :id, "--cpus", 1]
        v.customize ["set", :id, "--memsize", 768]
        v.customize ["set", :id, "--videosize", "256"]
    end
end
