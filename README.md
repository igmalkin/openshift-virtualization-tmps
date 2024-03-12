### Network Attachment
1) Install NMstate operator
2) Create a new instance for the NMState pressing Create instance
3) Create Linux Bridge on Worker Nodes:
      Administration → CustomResourceDefinitions: see NodeNetworkConfigurationPolicy.yaml
4) Create Network Attachment Definition

### Creating a Windows Virtual Machine
1) Use autounattend.xml for automation
2) Install VirtIO drivers after VM provisioning


### How to put VDDK in Red Hat Openshift internal registry
The Migration Toolkit for Virtualization (MTV) uses the VMware Virtual Disk Development Kit (VDDK) SDK to transfer virtual disks from VMware vSphere.
There is a way how to put VDDK in Openshift Internal Registry. [See the link](https://github.com/nirvkot/openshift-virtualization-tmps/blob/main/vmware-vddk-uploading.md).
