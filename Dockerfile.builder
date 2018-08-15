FROM openmandriva/cooker
#FROM openmandriva/cooker:aarch64
#FROM openmandriva/cooker:armv7hl
# replace me with armv7hl, aarch64
ENV RARCH x86_64
#ENV RARCH aarch64

RUN sed -i -e 's,^enabled=0,enabled=1,' /etc/yum.repos.d/*contrib*.repo \
 && dnf --nogpgcheck --refresh --assumeyes --nodocs --setopt=install_weak_deps=False upgrade \
 && rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/UTC /etc/localtime \
 && dnf --nogpgcheck --assumeyes --setopt=install_weak_deps=False --nodocs install mock git coreutils curl sudo builder-c procps-ng tar gnutar \
 findutils util-linux wget rpmdevtools sed grep xz gnupg \
 && sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers \
 && echo "%mock ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && adduser omv \
 && usermod -a -G mock omv \
 && chown -R omv:mock /etc/mock \
 && rm -rf /var/cache/dnf/* \
 && rm -rf /var/lib/dnf/yumdb/* \
 && rm -rf /usr/share/man/ /usr/share/cracklib /usr/share/doc \
 && dnf --assumeyes autoremove


RUN if [ $RARCH = "x86_64" ]; then dnf --nogpgcheck --assumeyes install qemu-static-aarch64 qemu-static-arm qemu-static-riscv64; fi

RUN rm -rf /var/lib/dnf/yumdb/* \
 && rm -rf /var/cache/dnf/* \
 && rm -rf /var/lib/rpm/__db.*

## put me in RUN if you have more than 16gb of RAM
# && echo "tmpfs /var/lib/mock/ tmpfs defaults,size=4096m,uid=$(id -u omv),gid=$(id -g omv),mode=0700 0 0" >> /etc/fstab \
#

ENTRYPOINT ["/usr/bin/builder"]
