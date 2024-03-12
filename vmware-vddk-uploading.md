# How to put VDDK in Red Hat Openshift internal registry 

The Migration Toolkit for Virtualization (MTV) uses the VMware Virtual Disk Development Kit (VDDK) SDK to transfer virtual disks from VMware vSphere.

Documentation link: 

https://access.redhat.com/documentation/en-us/migration_toolkit_for_virtualization/2.5/html/installing_and_using_the_migration_toolkit_for_virtualization/prerequisites#creating-vddk-image_mtv 


There is a way how to put VDDK in Openshift Internal Registry. Tested on OCP 4.14.14.

1) Navigate to Builds → ImageStreams

2) Press Create ImageStream

3) Replace the YAML content with the following code:
```  
apiVersion: image.openshift.io/v1
kind: ImageStream
metadata:
  name: vddk
  namespace: vmexamples # <- Put your namespace here
```

4) Navigate to Builds → BuildConfigs

5) Press Create BuildConfig

6) Replace the YAML content with the following code:
```
kind: BuildConfig
apiVersion: build.openshift.io/v1
metadata:
  name: vddk-build
  namespace: vmexamples # <- Put your namespace here
spec:
  output:
    to:
      kind: ImageStreamTag
      name: 'vddk:latest'
  strategy:
    type: Docker
    dockerStrategy:
      from:
        kind: ImageStreamTag
        namespace: openshift
        name: 'tools:latest'
  source:
    type: Dockerfile
    dockerfile: |
      FROM registry.access.redhat.com/ubi8/ubi-minimal
      RUN curl -L -O PUT_VDDK_URL_HERE # <- i.e http://example.local/VMware-vix-disklib-7.0.3-20134304.x86_64.tar.gz
      RUN tar -xzf VMware-vix-disklib-7.0.3-20134304.x86_64.tar.gz # <- name of VDDK tar-archive
      RUN mkdir -p /opt
      ENTRYPOINT ["cp", "-r", "/vmware-vix-disklib-distrib", "/opt"]
  triggers:
    - type: ImageChange
      imageChange: {}
    - type: ConfigChange
```

Now you can use VDDK init image link: image-registry.openshift-image-registry.svc:5000/vmexamples/vddk:latest
